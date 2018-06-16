#!/usr/bin/perl -w

############################################################
#	database_entry_manipulation.pl
#	04/03/2017
# 	Author: Davis24 (https://github.com/Davis24)
#	Purpose: Used to edit database entries for Library of Codexes
#	
#
#	To Do -- at somepoint
#   -	Create help menu
#   -   Redisplay menu options
#	-   Some refactoring and code clean up
########################################################
use warnings;
use Data::Dumper qw(Dumper);
$Data::Dumper::Sortkeys = 1;
use DBI;
use Encode;
use HTML::Entities;

my $seriesID = $ARGV[1];
if(!defined($seriesID)){
	$seriesID = 0;
}

my $myConnection = DBI->connect("DBI:mysql:library:localhost", "root", "");



sub menu{
	print "--------------------------\n";
	print "  Database Manipulation Menu \n";
	print "   1 - Delete Codexes \n";
	print "   2 - Delete Extra Codexes \n";
	print "   3 - Delete (Duplicate) Authors \n";
	print "   4 - Delete Empty Authors \n";
	print "   5 - Delete Duplicate Authors with Misspelled Names \n";
	print "   6 - Update Codex Text \n";
	print "   7 - Fix Text \n";
	print "  -1 - Exit \n";

	menu_response();
}

sub menu_response{
	while (1) {
		print "Choice: ";
		my $response = <STDIN>;
		chomp $response;

		if($response == 1){
			delete_codexes();
		}	
		elsif($response == 2){
			delete_extra_codexes();
		}
		elsif($response == 3){
			delete_authors();
		}
		elsif($response == 4){
			delete_empty_authors();
		}
		elsif($response == 5){
			remove_extras_from_author();
		}
		elsif($response == 6){
			#takes in input
			update_codex_text();
		}
		elsif($response == 7){
			#takes in input
			fix_text();
		}
		elsif($response == -1)
		{
			last;
		}
	}
}

###################################################################
# Below subroutines insert authors for already existing codexes #
###################################################################

sub insert_author_into_existing_codex{
	print "Author Name: ";
	my $authorName = <STDIN>;
	chomp $authorName;
	$authorName =~ s/('|")//g;
	
	print "Game ID: ";
	my $gameID = <STDIN>;
	chomp $gameID;

	print "Codex ID: ";
	my $codexTitle = <STDIN>;
	chomp $codexTitle;
	#$codexTitle =~ s/('|")//g;

	my $authorID;
	my $codexID = $codexTitle;

	#Check if the author current exists, if so grab the ID and assign it. Otherwise insert_author to db.
	my $queryAuthorCheck = $myConnection-> prepare("SELECT AUTHOR_ID FROM AUTHORS WHERE NAME LIKE '$authorName' AND FK_SERIES_ID = $seriesID");
	$queryAuthorCheck->execute();
	if($queryAuthorCheck->rows > 0)
	{
		while (@data = $queryAuthorCheck->fetchrow_array()) {
            $authorID = $data[0];
        }
		print "Author Found - $authorID\n";	
	}
	else ## insert author into db
	{
		$authorID = insert_author($authorName, $gameID, $seriesID);
		print "Inserted Author - $authorID\n";
	}
	$queryAuthorCheck->finish();
	
	##Add author to codexes_authors
	print "Adding entry to codexes_authors\n";
	insert_entry_into_codexes_authors($authorID, $codexID);
}

sub insert_entry_into_codexes_authors{
	my $authorQuery = $myConnection->prepare("INSERT INTO CODEXES_AUTHORS (FK_AUTHOR_ID, FK_CODEX_ID) values (?,?)");
	$authorQuery->execute($_[0], $_[1]) or die $DBI::errstr;
	$authorQuery->finish();
}

sub insert_author{
	my $query = $myConnection->prepare("INSERT INTO AUTHORS (AUTHOR_ID, NAME, FK_GAME_ID, FK_SERIES_ID) values (?,?,?,?)");
	$query->execute(null,$_[0],$_[1],$_[2]) or die $DBI::errstr;
	my $ID = $query->{mysql_insertid};
	$query->finish();
	return $ID;
}

###################################################################
# Below subroutines do validation on codexes_authors and printing #
###################################################################

#This runs a query over all records in codexes_authors and checks to see if the author or codex is missing, if so it deletes the entry
sub check_codexes_authors_for_IDS_that_dont_exist{
	my $query = $myConnection->prepare("SELECT * FROM codexes_authors");
	$query->execute();
	while (@data = $query->fetchrow_array()) {
        $authorID = $data[0];
		$codexID = $data[1];

		my $authorQuery = $myConnection->prepare("SELECT COUNT(*) FROM authors WHERE AUTHOR_ID = ?");
		$authorQuery->execute($authorID);
		@return = $authorQuery->fetchrow_array();
		my $count = $return[0];

		my $temp = 0;

		if($count == 0){
			print "There is no author($authorID) that matches this\n";

			my $deleteQuery = $myConnection->prepare("DELETE FROM codexes_authors WHERE FK_AUTHOR_ID =?");
			$deleteQuery->execute($authorID);
			$deleteQuery->finish();

			$temp = 1;
		}
		$authorQuery->finish();

		my $codexQuery = $myConnection->prepare("SELECT COUNT(*) FROM codexes WHERE CODEX_ID = ?");
		$codexQuery->execute($codexID);
		@return = $codexQuery->fetchrow_array();
		$count = $return[0];

		if($count == 0 && $temp == 0){
			print "There is no codex:($codexID) that matches this\n";

			my $deleteQuery = $myConnection->prepare("DELETE FROM codexes_authors WHERE FK_CODEX_ID = ?");
			$deleteQuery->execute($codexID);
			$deleteQuery->finish();
		}
		$codexQuery->finish();
    }
	$query->finish();
}

sub check_if_author_is_in_codexes_authors{
	my $query = $myConnection->prepare("SELECT AUTHOR_ID FROM AUTHORS");
	$query->execute();
	while (@data = $query->fetchrow_array()) {
		$authorID = $data[0];

		my $authorQuery = $myConnection->prepare("SELECT COUNT(*) FROM codexes_authors WHERE FK_AUTHOR_ID = ?");
		$authorQuery->execute($authorID);
		@return = $authorQuery->fetchrow_array();
		my $count = $return[0];

		if($count == 0)
		{
			print "This author($authorID) has no codex\n";
			my $deleteQuery = $myConnection->prepare("DELETE FROM AUTHORS WHERE AUTHOR_ID = ?");
			$deleteQuery->execute($authorID);
			$deleteQuery->finish();
		}

	}
	$query->finish();
}

sub check_if_codex_is_in_codexes_authors{
	my $query = $myConnection->prepare("SELECT CODEX_ID, FK_AUTHOR_ID FROM CODEXES");
	$query->execute();
	while (@data = $query->fetchrow_array()) {
		$codexID = $data[0];
		$authorID = $data[1];

		###Make this into a subroutine
		my $codexQuery = $myConnection->prepare("SELECT COUNT(*) FROM codexes_authors WHERE FK_CODEX_ID = ?");
		$codexQuery->execute($codexID);
		@return = $codexQuery->fetchrow_array();
		my $count = $return[0];
		$codexQuery->finish();

		if($count == 0)
		{
			#If the codexes' author exists create the link in codexes_authors
			my $authorQuery = $myConnection->prepare("SELECT COUNT(*) FROM AUTHORS WHERE AUTHOR_ID = ?");
			$authorQuery->execute($authorID);
			@return = $authorQuery->fetchrow_array();
			my $authorCheck = $return[0];

			print "This codex($codexID)-($authorID) has no codex\n";

			if($authorCheck > 0){
				my $recordInsert = $myConnection->prepare("INSERT INTO codexes_authors (FK_AUTHOR_ID, FK_CODEX_ID) values (?,?)");
				$recordInsert->execute($authorID, $codexID);
				$recordInsert->finish();
			}
		}

	}
	$query->finish();
}

##############################################
# Below subroutines handle text and printing #
##############################################
sub fix_text{
	my $query = $myConnection->prepare("SELECT CODEX_ID, CODEX_TEXT FROM CODEXES WHERE FK_SERIES_ID = 17");
	$query->execute();
	while(@return = $query->fetchrow_array()){
		my $id = $return[0];
		my $text = $return[1];
		
		#$text = replace_non_utf_8_characters($text);
		#$text =~ s/If (.*?)(:|\.\.\.)/\<i\>If $1$2\<\/i\>/g;
		$text =~ s/(\<i\>){2,}/\<i\>/g;
		$text =~ s/(\<\/i\>){2,}/\<\/i\>/g;

		my $statement = $myConnection->prepare("UPDATE CODEXES SET CODEX_TEXT =? WHERE CODEX_ID = ?");
		$statement->execute($text, $id) or die $DBI::errstr;
		$statement->finish();			
	}
	$query->finish();

}

sub update_codex_text{
	print "Codex ID: ";
	my $codexID = <STDIN>;

	print "New Text:";
	print "---CTRL-Z to break----\n";
	###### Allow user to input text that is missing ######
	my @a;
	while (<STDIN>) {
		push @a, $_;
	}
	my $text = "";	
	foreach my $i (@a){
		$text .= $i;
	}
	$text =~ s/\[\{""text[0-9]?"":""//g;
	$text =~ s/""\}\]"//g;
	$text =~ s/""\}\]//g;
	$text =~ s/\h+/ /g;
	$text =~ s/(\\n\\n)*""\},\{""text[0-9]?"":""/\n\n/g;
	$text =~ s/\\n\\n/\n\n/g;
	$text =~ s/\\n/\n/g;
	$text =~ s/\n\n\n/\n\n/g;
	$text =~ s/(\n\n{3,}|(\s)*\n(\s)*\n)/\n\n/g;
	$text =~ s/(\n\n{3,}|(\s)*\n(\s)*\n)/\n\n/g;
	$text =~ s/\[\]"//g;
	$text =~ s/\\"//g;
	$text =~ s/\\t//g;
	$text =~ s/\\x92/'/g;
	$text =~ s/\\x93|\\x94/"/g;
	$text =~ s/\\x85/.../g;
	$text =~ s/\\xE9/&#233;/g;
	$text =~ s/\\xB8/&cedil;/g;
	$text =~ s/\\xEF/&#239;/g;
	$text =~ s/\\x97/&mdash;/g;
	$text =~ s/\\x96//g;

	$text = replace_non_utf_8_characters($text);

	$query = $myConnection->prepare("UPDATE CODEXES SET CODEX_TEXT = ? WHERE CODEX_ID = ?");
	$query->execute($text, $codexID) or die $DBI::errstr;
	$query->finish();
}

sub replace_non_utf_8_characters{
	return encode_entities($_[0]);
}