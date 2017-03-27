#!/usr/bin/perl -w

use Data::Dumper qw(Dumper);
$Data::Dumper::Sortkeys = 1;
use Encode;
#use strict;
use warnings;


use DBI;




my $filename = $ARGV[0];
my $string;
my $temp = 0;
my $tempnum = 1;
my $tempstring;
my %codexhash;
    


################################################
#		Elder Scrolls Algorithm 
#
#

# Read CSV File
# Check for Empty Cells -- specifically Text
# Replace ASCII Issues -- Will need to run script once before inserting to check if new ascii changes need to be added
# Authors -
#  	1) Check if author exists in MYSQL
# 		- if author exists update codexHash Author with ID
#	2) If it does not exist
#		- Insert Author into Table,
#		  split author hash,  if size = 1 last name
#								 size = 2 first name, last name
#								 size = 3 title, first name, last name
#							     size > 3 error
#		 Add Description = TBD
#  3) Sub function to Insert Codexes to Table
#  4) Manually Validate Authors & Add Description	


ElderScrolls();
#prepareHashAuthors();





sub ElderScrolls{
	### Part 1 - Open File ###
	open(my $fh, '<:encoding(UTF-8)', $filename) or die "Could not open";	
	### Part 2 - Read file and put into hash
	while(my $row = <$fh>)
	{
		chomp $row;
		$row =~ s/\xA0/ /g;

		if($temp < 2)
		{
			$tempstring .= $row;
			$temp++;
		}
		else
		{
			my @words = split('","', $tempstring);


			## Title fixes
			$words[0] =~ s/"//g;
			$words[0] =~ s/([\w']+)/\u\L$1/g;
			## Author Fixes
			$words[2] =~ s/A(.)*://g;   
			$words[2] =~ s/^\s+|\s+$//g; 

			#In some instances the web scrapper had two text columns
			#Whichever is larger is used as the text (not sure on accuracy)
			if(scalar @words == 5)
			{
				if(length($words[3]) > length($words[4]))
				{
					## Text Fixes
					textEntryComparison($words[3]);
				}	
				else
				{
					textEntryComparison($words[4]);

				}			
			}
			else
			{	
				textEntryComparison($words[3]);
			}

			$codexhash{$tempnum}{Title} = $words[0];
			$codexhash{$tempnum}{Author} = $words[2];
			

			$temp = 1;
			$tempstring = "";
			$tempstring .= $row;
			$tempnum++;
		}
		$string .= $row;
	}
	### Part 3 - Check Empty (before enabling this run ascii to make sure all replaces are accounted for)
	#checkEmpty();
	### Part 4 - Check ASCII #####
	asciiCheckReplace();
	#dataDump();
	### Run the second time
	### Part 4 - Check if Author exists in MYSQL, if author exists replace 
	for my $item (keys %codexhash)
	{
		prepareHashAuthors($item);
	}

}

## ID, Title, First_Name, Last_Name, Biography, FK_GAME_ID ##
sub insertAuthor{
	my $statement = $myConnection->prepare("INSERT INTO AUTHORS (AUTHOR_ID, TITLE, FIRST_NAME, LAST_NAME, BIOGRAPHY, FK_GAME_ID) values (?,?,?,?,?,?)");
		for my $item (keys %codexhash)
		{	
			$statement->execute(undef, $codexhash{$item}{Title}, $codexhash{$item}{Text}, 203, 10) or die $DBI::errstr;	
			$statement->finish();
		}
}


sub prepareHashAuthors{
	my $id = $_[0];
	print "ID: $id \n";
	my $authorName = $codexhash{$id}{Author}; 
	$authorName =~ s/\'/\\'/g;
	my $myConnection = DBI->connect("DBI:mysql:library:localhost", "root", "hMdCxTP7bpMAu3Bh");
	my $statement = $myConnection-> prepare("SELECT AUTHOR_ID FROM AUTHORS WHERE CONCAT(FIRST_NAME,' ',LAST_NAME) LIKE '$authorName'");
	$statement->execute;
	
	if($statement->rows > 0)
	{
		while (@data = $statement->fetchrow_array()) {
            my $id = $data[0];
            print "\t$id \n";

            #$codex{$item}{Author} = $id;
          }
	}
	else
	{
		#Needs to be passed First_Name, Last_Name, FK_Game_ID
		#insertAuthor();
		#print "It doesn't exist";
		
	}

}


#Takes in text -> performs regex replacements -> sets codexText to the sanatized text
sub textEntryComparison{
	my $text = $_[0];

	## Text Fixes
	$text =~ s/\[\{""text[0-9]?"":""//g;
	$text =~ s/""\}\]"//g;
	$text =~ s/\h+/ /g;
	$text =~ s/(\\n\\n)*""\},\{""text[0-9]?"":""/\n\n/g;
	$text =~ s/\\n\\n/\n\n/g;
	$text =~ s/\\n/\n/g;
	$text =~ s/\n\n\n/\n\n/g;
	$text =~ s/\[\]"//g;
	$text =~ s/\\t//g;
	$codexhash{$tempnum}{Text} = $text;	
}

sub falloutAlgorithm{
	while(my $row = <$fh>){
	chomp $row;
	$row =~ s/\xA0/ /g;
	#print "ROW : $row \n\n";
	if($temp < 1)
	{
		$tempstring .= $row;
		$temp++;
		#print "Value : $temp  , row = $row \n";
	}
	else
	{
		#print "########################################\n";
		

		
		############ Fallout Algorithm #################
		my @words = split('","', $tempstring);
		$words[0] =~ s/"//g;
		$words[0] =~ s/([\w']+)/\u\L$1/g;
		$codexhash{$tempnum}{Title} = $words[0]; 
		
		$words[2] =~ s/\[\{""text"":""//g;
		$words[2] =~ s/""\}\]"//g;
		$words[2] =~ s/\h+/ /g;
		$words[2] =~ s/(\\n\\n)*""\},\{""text"":""/\n\n/g;
		$words[2] =~ s/\\n\\n/\n\n/g;
		$words[2] =~ s/\\n/\n/g;
		$words[2] =~ s/\n\n\n/\n\n/g;
		$words[2] =~ s/\[\]"//g;
		$codexhash{$tempnum}{Text} = $words[2];

		#foreach my $w (@words)
		#{
		#	print "SPLIT: $w \n";
		#}
		#print "########################################\n";

		$temp = 1;
		$tempstring = "";
		$tempstring .= $row;
		$tempnum++;
	}
	
	$string .= $row;

}
}

sub asciiCheckReplace
{
	print "Start of Text ASCII Replacing \n";
	for my $item (keys %codexhash)
	{
		for my $subitem (keys %{$codexhash{$item}}) 
		{
			my @array = split(//, $codexhash{$item}{$subitem});	
			my $replaceString;
			foreach my $r (@array)
			{
				if(ord($r) > 128)
				{
					#print "$r is higher than 128 - ".ord($r)."\n";
				}
				if(ord($r) == 8212)
				{
					$replaceString .= "&mdash;";
				}
				elsif(ord($r) == 8217) # 8217 = ’
				{
					$replaceString .= "\'";
				}
				elsif(ord($r) == 8221) # 8221 = ”
				{
					$replaceString .= "\"";
				}
				elsif(ord($r) == 8220) # 8220 = “
				{
					$replaceString .= "\"";
				}
				elsif(ord($r) == 65279)
				{
					$replaceString .= "";
				}
				elsif(ord($r) == 8226)    # 8226 = •
				{
					$replaceString .="&bull;";
				}
				elsif(ord($r) == 184)    #184 = ¸
				{
					$replaceString .=",";
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

sub checkEmpty
{
	for my $item (keys %codexhash)
	{
		for my $subitem(keys %{$codexhash{$item}})
		{
			if(!$codexhash{$item}{$subitem})
			{
				print $codexhash{$item}{Title}."\n";
				print $item ." - ".$subitem." is not defined.\n";
				print "---CTRL-Z to break----\n";
				###### Allow user to input text that is missing #######

				my @a;
				while (<STDIN>) {
    				push @a, $_;
				}
				print @a;
				my $arrayString = "";	
				foreach my $i (@a){
					$arrayString .= $i;
				}

				$codexhash{$item}{Text} = $arrayString;

			}
		}
	}
}


sub addToDatabase{
	my $myConnection = DBI->connect("DBI:mysql:library:localhost", "root", "hMdCxTP7bpMAu3Bh");
	my $statement = $myConnection->prepare("INSERT INTO CODEXES (CODEX_ID, CODEX_TITLE, CODEX_TEXT, FK_AUTHOR_ID, FK_GAME_ID) values (?,?,?,?,?)");

	for my $item (keys %codexhash)
	{
		$statement->execute(undef, $codexhash{$item}{Title}, $codexhash{$item}{Text}, 203, 10) or die $DBI::errstr;	
		$statement->finish();
	}
	

}

sub dataDump{
	print "########################################\n";
	print Dumper \%codexhash;
	print "########################################\n";
}


#checkEmpty(); 
#asciiCheckReplace();
#addToDatabase();
#dataDump();


########################## Elder Scrolls Functions #####################################






sub addAuthors{
	my $myConnection = DBI->connect("DBI:mysql:library:localhost", "root", "hMdCxTP7bpMAu3Bh");
	my $statement = $myConnection->prepare("INSERT INTO CODEXES (CODEX_ID, CODEX_TITLE, CODEX_TEXT, FK_AUTHOR_ID, FK_GAME_ID) values (?,?,?,?,?)");
}













