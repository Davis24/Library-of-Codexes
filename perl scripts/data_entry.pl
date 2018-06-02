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


my $filename = $ARGV[0];
my $choice = $ARGV[1];

if(!defined($choice)){
	$choice = 0;
}

my $myConnection = DBI->connect("DBI:mysql:library:localhost", "root", "");

my $string; #used to keep track of text from file
my $temp = 0; #temp is used to count off lines in instances where the CSV information for a single entry spans multiple lines
my $tempnum = 0; #used to assign codex information to the right spots
my $tempstring; #hold the text being read in from the text file
my %codexhash;
my $author_count = 10000;   #faster than quering the highest author ID everytime
my $series_id = 16;
my $game_id = 42;
my $codex_id;


open(my $fh, '<:encoding(UTF-8)', $filename) or die "Could not open";
while(my $row = <$fh>)
{
	print encode_entities($row);
}

sub insert_game{
	open(my $fh, '<:encoding(UTF-8)', $filename) or die "Could not open";
	while(my $row = <$fh>)
	{
		chomp $row;
		$row =~ s/\\xA0/ /g;

		my @words = split('","', $row);

		## Title fixes
		$words[4] =~ s/"//g;
		$words[4] =~ s/([\w']+)/$1/g;
			
		text_sanitize($words[5]);

		$codexhash{$tempnum}{Title} = $words[4];
		$codexhash{$tempnum}{Author} = 10000;
			
		$tempnum++;
		
		$string .= $row;
	}	
}

sub witcher{
	### Part 1 - Open File ###
	
	### Part 2 - Read file and put into hash
	while(my $row = <$fh>)
	{
		chomp $row;
		$row =~ s/\\xA0/ /g;

		my @words = split('","', $row);

		## Title fixes
		$words[4] =~ s/"//g;
		$words[4] =~ s/([\w']+)/$1/g;
			
		text_sanitize($words[5]);

		$codexhash{$tempnum}{Title} = $words[4];
		$codexhash{$tempnum}{Author} = 10000;
			
		$tempnum++;
		
		$string .= $row;
	}

	### Part 3 - Check Empty (before enabling this run ascii to make sure all replaces are accounted for)
	alert_null();
	### Part 4 - Check ASCII #####
	replace_ascii();
	### Run the second time
	### Part 4 - Check if Author exists in MYSQL, if author exists replace 
	#authors_call();
	### Part 5 - Add Codexes to DB
	if($choice == 1)
	{
		insert_codex();
	}
	
	print_hash();
}

########################### Non-Specific Game Subroutines ################################

sub authors_call{
	for my $item (keys %codexhash)
	{
		check_author_exists($item, $_[0]);
	}
}

sub check_author_exists{
	my $id = $_[0];
	my $g = $_[1];
	my $authorName = $codexhash{$id}{Author};

	$authorName =~ s/\'/\\'/g;
	$authorName =~ s/ //g;

	my $query = $myConnection-> prepare("SELECT AUTHOR_ID FROM AUTHORS WHERE REPLACE(CONCAT(FIRST_NAME,'',LAST_NAME),' ','') LIKE '$authorName'");
	$query->execute();

	if($query->rows > 0)
	{
		while (@data = $query->fetchrow_array()) {
            my $aID = $data[0];
            $codexhash{$id}{Author} = $aID;
          }
	}
	else
	{
		insert_author($id,$g);
	}

	$query->finish();
}


## REMOVE THIS ###
sub check_for_null{
	for my $item (keys %codexhash){
		for my $subitem(keys %{$codexhash{$item}}){
	 		if(!$codexhash{$item}{$subitem}){
				print $codexhash{$item}{Title}."\n";
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
				$codexhash{$item}{Text} = $arrayString;
			}
		}
	}
}

### REMOVE ABOVE ###

sub alert_null{
	for my $item (keys %codexhash){
		for my $subitem(keys %{$codexhash{$item}}){
	 		if(!$codexhash{$item}{$subitem}){
				print $codexhash{$item}{Title}.":".$subitem." is not defined.\n";
			}
		}
	}
}


sub insert_author{
	my $query = $myConnection->prepare("INSERT INTO AUTHORS (AUTHOR_ID, TITLE, FIRST_NAME, LAST_NAME, BIOGRAPHY, FK_GAME_ID) values (?,?,?,?,?,?)");
	my $authorName = $codexhash{$_[0]}{Author};
	my @author = split(' ',$authorName);

	if(scalar @author == 1){
		#First Name
		$query->execute($author_count, "", $author[0], "", "[To be added]", $_[1]) or die $DBI::errstr;	
		$query->finish();
	}
	elsif(scalar @author == 2){
		# First Name, Last Name
		$query->execute($author_count, "", $author[0], $author[1], "[To be added]", $_[1]) or die $DBI::errstr;	
		$query->finish();
	}
	else{
		#print "\nWork: ".$codexhash{$_[0]}{Title}."--- ";
		foreach $r (@author){
			print "$r ";
		}
		$query->execute($author_count, "", $authorName, "", "[To be added]", $_[1]) or die $DBI::errstr;	
		$query->finish();
	}

	$codexhash{$_[0]}{Author} = $author_count;
	$author_count++;	
}



sub insert_codex{
	my $query = $myConnection->prepare("INSERT INTO CODEXES (CODEX_ID, CODEX_TITLE, CODEX_TEXT, FK_AUTHOR_ID, FK_GAME_ID, FK_SERIES_ID) values (?,?,?,?,?,?)");

	for my $item (keys %codexhash){
		$query->execute(null, $codexhash{$item}{Title}, $codexhash{$item}{Text}, $codexhash{$item}{Author}, $game_id, $series_id) or die $DBI::errstr;	
		$codex_id = $query->{mysql_insertid};
		$query->finish();
		
		
		#insert_codex_authors($codexhash{$item}{Author}, $codex_id);
	}
}

## Ignore till properly fixed
sub insert_codex_authors{
	my $query2 = $myConnection->prepare("INSERT INTO CODEXES_AUTHORS (FK_AUTHOR_ID, FK_CODEX_ID, FK_GAME_ID) values (?,?,?)");
	$query2->execute($_[0], $_[1], $game_id) or die $DBI::errstr;
	$query2->finish();
}
###

sub print_hash{
	#my %tempHash = $_[0];
	print "########################################\n";
	print Dumper \%codexhash;
	print "########################################\n";
}

#Go over each character in the hash to determine if it's part of UTF-8
sub replace_ascii{
	for my $item (keys %codexhash){
		for my $subitem (keys %{$codexhash{$item}}) {
			my @array = split(//, $codexhash{$item}{$subitem});	
			my $replaceString;
			foreach my $r (@array){
				if(ord($r) > 128)
				{
					print "$r is higher than 128 - ".ord($r)."\n";
					$replaceString .= "&#".ord($r).";";
				}	
				else
				{
					$replaceString .= $r;
				}
			}
			$codexhash{$item}{$subitem} = $replaceString;
			$replaceString = "";
		}
	}
}

sub text_sanitize{
	my $text = $_[0];
	$text =~ s/In-Game Description//g;
	$text =~ s/\[\{""text[0-9]?"":""//g;
	$text =~ s/\[\{""descriptiong[0-9]?"":""//g;
	$text =~ s/""\}\]"//g;
	$text =~ s/""\}\]//g;
	$text =~ s/\h+/ /g;
	$text =~ s/(\\n\\n)*""\},\{""text[0-9]?"":""/\n\n/g;
	$text =~ s/(\\n\\n)*""\},\{""descriptiong[0-9]?"":""/\n\n/g;
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
	$text =~ s/Memory Audio/<b>Memory Audio<\/b>/g; #only for Shadows of Mordor
	$text =~ s/Codex entry.*//s; #only for dragon age
	$text =~ s/\[[0-9]+\]"//s; #only for metroid prime


	$codexhash{$tempnum}{Text} = $text;	
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
		$codexhash{$tempnum}{Title} = $words[2];
		

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


		$codexhash{$tempnum}{Author} = "temp";

		$tempnum++;
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
	#print "# added $tempnum";
}



