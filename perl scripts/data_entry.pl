#!/usr/bin/perl -w

############################################################
#	text_manipulation.pl
#	02/08/2017
# 	Author: Davis24 (https://github.com/Davis24)
#	Purpose: To assist with inserting new data into Library of Codexes database
#
#	Non-Specific Subroutines:
#		check_author_exists: Check if author exists in database, assigns the codex with the authorID or inserts new author 
#		check_for_null: Checks hash for null values and replaces them with user input
#		insert_author: Inserts new author into database
#		insert_codex: Inserts new codex into database
#		print_hash: Takes in a hash and prints it out
#		replace_ascii: Replaces ASCII that doesn't fall into UTF-8 encoding
#		text_sanitize: Sanitizes codex text
#
#	To Do:
# 	-  Refactor so there is less repeating code
#	-  Clean up lines and variable names
#
##############################################################
use warnings;
use Data::Dumper qw(Dumper);
use HTML::Entities;
$Data::Dumper::Sortkeys = 1;
use DBI;

#Command Line Arguements
my $filename = $ARGV[0];
my $seriesID = $ARGV[1];
my $gameID = $ARGV[2];
my $insertRecords = $ARGV[3]; #If insertRecords == insert, then the records will be intersted otherwise they will just print to screen
my $selectAuthors = $ARGV[4]; #If selectAuthors == authors, then the user will be prompted each time to insert the author name

my $myConnection = DBI->connect("DBI:mysql:library:localhost", "root", "");

my $codex_id;
my $tempNum = 0; #Increases after each record is added to the hash
my $tempString; #Hold text read in from file, used for if codex spans multiple lines
my $authorCount = 10000; #Used as a placeholder if needed for later queries

my %codexHash;

#If the command line argument isn't given set it to zero
if(!defined($insertRecords)){
	$insertRecords = 0;
}
if(!defined($selectAuthors)){
	$selectAuthors = 0;
}
if(!defined($seriesID)){
	$seriesID = 0;
}
if(!defined($gameID)){
	$gameID = 0;
}


sub insert_game{
	open(my $fh, '<:encoding(UTF-8)', $filename) or die "Could not open";
	while(my $row = <$fh>)
	{
		chomp $row;
		$row =~ s/\\xA0/ /g;

		my @words = split('","', $row);

		## Codex Title sanitization
		#$words[4] =~ s/"//g;
		$words[4] =~ s/([\w']+)/$1/g;
		$words[4] = replace_non_utf_8_characters($words[4]);
		$codexHash{$tempNum}{Title} = $words[4];
		
		## Codex Description	
		$codexHash{$tempNum}{Text} = replace_non_utf_8_characters(text_sanitize($words[5]));

		## Codex Authors
		if($selectAuthors eq "authors")
		{
			$codexHash{$tempNum}{Author} = assign_author();
		}
		else
		{
			$codexHash{$tempNum}{Author} = $authorCount;
		}
		
		$tempNum++;
	}

	alert_null();	

	#Insert Codexes
	if($insertRecords eq "insert")
	{
		insert_codex();
	}

	print_hash();
}

########################### Non-Specific Game Subroutines ################################

#Rewrite completed
#NOT TESTED
sub assign_author{
	print "\n";
	print "Codex Title: $codexHash{$tempNum}{Title}\n";
	print "Author Name: ";
	my $tempAuthor = <STDIN>;
	chomp $tempAuthor;

	if($tempAuthor eq "-1")
	{
		print "\nNo, author default assigned.\n";
		$codexHash{$tempNum}{Author} = $authorCount;
	}
	else
	{
		check_author_exists($tempAuthor);
	}
}

#Completed Rewrite
#NOT TESTED
sub check_author_exists{
	#$_[0] is Author Name

	my $query = $myConnection-> prepare("SELECT AUTHOR_ID FROM AUTHORS WHERE NAME LIKE '$_[0]' AND FK_SERIES = $seriesID");
	$query->execute();

	if($query->rows > 0)
	{
		while (@data = $query->fetchrow_array()) {
            my $authorID = $data[0];
            $codexHash{$tempNum}{Author} = $authorID;
          }
	}
	else
	{
		insert_author($_[0]);
	}

	$query->finish();
}

#Completed Rewrite
#NOT TESTED
sub insert_author{
	my $queryAuthor = $myConnection->prepare("INSERT INTO AUTHORS (AUTHOR_ID, NAME, FK_GAME_ID, FK_SERIES_ID) values (?,?,?,?)");
	
	$queryAuthor->execute(null, $_[0], $gameID, $seriesID) or die $DBI::errstr;
	$codexHash{$tempNum}{Author} = $queryAuthor->{mysql_insertid}; #grab previously inserted ID 
	$queryAuthor->finish();

	print "Author successfully added to DB. \n";
}

sub insert_codex{
	my $query = $myConnection->prepare("INSERT INTO CODEXES (CODEX_ID, CODEX_TITLE, CODEX_TEXT, FK_AUTHOR_ID, FK_GAME_ID, FK_SERIES_ID) values (?,?,?,?,?,?)");
	for my $item (keys %codexHash){
		$query->execute(null, $codexHash{$item}{Title}, $codexHash{$item}{Text}, $codexHash{$item}{Author}, $gameID, $seriesID) or die $DBI::errstr;	
		$codex_id = $query->{mysql_insertid};
		$query->finish();
		
		#insert_codex_authors($codexHash{$item}{Author}, $codex_id);
	}
}

## REMOVE THIS ###
sub check_for_null{
	for my $item (keys %codexHash){
		for my $subitem(keys %{$codexHash{$item}}){
	 		if(!$codexHash{$item}{$subitem}){
				print $codexHash{$item}{Title}."\n";
				print $item ." - ".$subitem." is not defined.\n";
				print "---CTRL-Z to break----\n";

				###### Allow user to input text that is missing ######
				my @a;
				while (<STDIN>) {
    				push @a, $_;
				}
				my $arrayString = "";	
				foreach my $i (@a){
					$arrayString .= $i;
				}
				$codexHash{$item}{Text} = $arrayString;
			}
		}
	}
}

### REMOVE ABOVE ###

## Prints which codex entry is not definied.
sub alert_null{
	for my $item (keys %codexHash){
		for my $subitem(keys %{$codexHash{$item}}){
	 		if(!$codexHash{$item}{$subitem}){
				print $codexHash{$item}{Title}.":".$subitem." is not defined.\n";
			}
		}
	}
}






## Ignore till properly fixed
sub insert_codex_authors{
	my $query2 = $myConnection->prepare("INSERT INTO CODEXES_AUTHORS (FK_AUTHOR_ID, FK_CODEX_ID, FK_gameID) values (?,?,?)");
	$query2->execute($_[0], $_[1], $gameID) or die $DBI::errstr;
	$query2->finish();
}
###

sub print_hash{
	print "########################################\n";
	print Dumper \%codexHash;
	print "########################################\n";
}





#Replaces data added from webscraping
sub text_sanitize{
	my $text = $_[0];
	$text =~ s/\[\{""text[0-9]?"":""//g;
	$text =~ s/\[\{""description[0-9]?"":""//g;
	$text =~ s/""\}\]"//g;
	$text =~ s/""\}\]//g;
	$text =~ s/\h+/ /g;
	$text =~ s/(\\n\\n)*""\},\{""text[0-9]?"":""/\n\n/g;
	$text =~ s/(\\n\\n)*""\},\{""description[0-9]?"":""/\n\n/g;
	$text =~ s/\\n\\n/\n\n/g;
	$text =~ s/\\n/\n/g;
	$text =~ s/\n\n\n/\n\n/g;
	$text =~ s/(\n\n{3,}|(\s)*\n(\s)*\n)/\n\n/g;
	$text =~ s/(\n\n{3,}|(\s)*\n(\s)*\n)/\n\n/g;
	$text =~ s/""\},//g;
	$text =~ s/\[\]"//g;
	$text =~ s/\\"//g;
	$text =~ s/\\t//g;
	$text =~ s/\\x92/'/g;
	$text =~ s/\\x91/'/g;
	$text =~ s/\\xC9/&#xc9;/g;
	$text =~ s/\\xEA/&#xea;/g;
	$text =~ s/\\x93|\\x94/"/g;
	$text =~ s/\\x85/.../g;
	$text =~ s/(\\xE9|\\x\{e9\})/&#233;/g;
	$text =~ s/\\xB8/&cedil;/g;
	$text =~ s/\\xEF/&#239;/g;
	$text =~ s/\\x97/&mdash;/g;
	$text =~ s/\\x96//g;
	
	return $text;
}

sub dragon_age{
	### Part 1 - Open File ###
	open(my $fh, '<:encoding(UTF-8)', $filename) or die "Could not open";	
	### Part 2 - Read file and put into hash
	while(my $row = <$fh>)
	{
		chomp $row;
		my @words = split('","', $row);
		#title
		$words[2] =~ s/Note: //g;
		$codexHash{$tempNum}{Title} = $words[2];
		

		if(scalar @words == 6) {
			if(length($words[3]) > length($words[5])) {
				$words[3] =~ s/\\xA0//g;
				$words[3] =~ s/^\s+|\s+$//g;
				text_sanitize($words[3]);
			}	
			else {
				$words[5] =~ s/\\xA0//g;
				$words[5] =~ s/^\s+|\s+$//g;
				text_sanitize($words[5]);
			}			
		}
		else
		{
				#text
				$words[3] =~ s/\\xA0//g;
				$words[3] =~ s/^\s+|\s+$//g;
				text_sanitize($words[3]);	
		}


		$codexHash{$tempNum}{Author} = "temp";

		$tempNum++;
	}
	
	### Part 3 - Check Empty (before enabling this run ascii to make sure all replaces are accounted for)
	check_for_null();
	### Part 4 - Check ASCII #####
	replace_ascii();	
	### Part 4 - Check if Author exists in MYSQL, if author exists replace 
	authors_call(11);
	### Part 5 - Add Codexes to DB
	insert_codex(11);
	print_hash();
	#print "# added $tempNum";
}



