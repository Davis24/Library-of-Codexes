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

my $seriesID = $ARGV[0];
if(!defined($seriesID)){
	$seriesID = 0;
}

my $myConnection = DBI->connect("DBI:mysql:library:localhost", "root", "");


#delete_entries_in_codexes_authors();
#insert_author_into_existing_codex();
combine_authors_with_same_name();
check_codexes_authors_for_IDS_that_dont_exist();
remove_authors_that_dont_exists_in_codexes_authors();
remove_codexes_that_dont_exist_in_codexes_authors();
fix_text();

sub menu{
	print "--------------------------\n";
	print "  Database Manipulation Menu \n";
	print "   1 - Insert Author into Existing Codex \n";
	print "   2 - Check Codexes_Authors Table for IDS that don't exist \n";
	print "  -1 - Exit \n";

	menu_response();
}

sub menu_response{
	while (1) {
		print "Choice: ";
		my $response = <STDIN>;
		chomp $response;

		if($response == 1){
			insert_author_into_existing_codex();
		}	
		elsif($response == 2){
			check_codexes_authors_for_IDS_that_dont_exist();
		}
		elsif($response == -1)
		{
			last;
		}
	}
}

sub assign_series_id_to_author{
	print "Game ID: ";
	my $response = <STDIN>;
	chomp $response;
	print "Series ID: ";
	my $seriesID = <STDIN>;
	chomp $seriesID;

	my $author_select = $myConnection->prepare("SELECT AUTHOR_ID FROM AUTHORS WHERE FK_GAME_ID = ?");
	$author_select->execute($response) or die $DBI::errstr;
	while (@data = $author_select->fetchrow_array()) {
        $authorID = $data[0];

		my $update_statement = $myConnection->prepare("UPDATE AUTHORS SET FK_SERIES_ID = ? WHERE AUTHOR_ID = ?");
		$update_statement->execute($seriesID, $authorID) or die $DBI::errstr;
		$update_statement->finish();			
    }
	$author_select->finish();
	
}

sub remove_authors_that_dont_exists_in_codexes_authors{
	my $author_select = $myConnection->prepare("SELECT AUTHOR_ID, NAME FROM AUTHORS");
	$author_select->execute() or die $DBI::errstr;
	print "Removing Authors That Don't Exist!\n";
	while(@data = $author_select->fetchrow_array()){
		$authorID = $data[0];

		my $check_statement = $myConnection->prepare("SELECT * FROM CODEXES_AUTHORS WHERE FK_AUTHOR_ID = ?");
		$check_statement->execute($authorID) or die $DBI::errstr;
		if($check_statement->rows > 0){

		}
		else
		{
			my $delete_statement = $myConnection->prepare("DELETE FROM AUTHORS WHERE AUTHOR_ID = ?");
			$delete_statement->execute($data[0]);
			$delete_statement->finish();
			print($data[1]);
			print("\n");
		}
		
		$check_statement->finish();
	}
	$author_select->finish();
}

sub remove_codexes_that_dont_exist_in_codexes_authors{
	my $codex_select = $myConnection->prepare("SELECT CODEX_ID, CODEX_TITLE FROM CODEXES");
	$codex_select->execute() or die $DBI::errstr;
	print "Removing Codexes That Don't Exist!\n";
	while(@data = $codex_select->fetchrow_array()){
		$codexID = $data[0];

		my $check_statement = $myConnection->prepare("SELECT * FROM CODEXES_AUTHORS WHERE FK_CODEX_ID = ?");
		$check_statement->execute($codexID) or die $DBI::errstr;
		if($check_statement->rows > 0){

		}
		else
		{
			my $delete_statement = $myConnection->prepare("DELETE FROM CODEXES WHERE CODEX_ID = ?");
			$delete_statement->execute($data[0]);
			$delete_statement->finish();
			
			print($data[1]);
			print("\n");
		}
		
		$check_statement->finish();
	}
	$codex_select->finish();
}

#Series and Game ID
sub combine_authors_with_same_name{
	#SELECT GROUP_CONCAT(AUTHOR_ID), NAME, COUNT(*) c FROM authors GROUP BY NAME HAVING c > 1 
	print "Game ID: ";
	my $gameID = <STDIN>;
	chomp $gameID;

	my $queryAuthorCheck = $myConnection->prepare("SELECT GROUP_CONCAT(AUTHOR_ID), NAME, COUNT(*) c FROM authors WHERE FK_GAME_ID = ? GROUP BY NAME HAVING c > 1 ");
	$queryAuthorCheck->execute($gameID) or die $DBI::errstr;
	print "Found Matching Authors!\n";
	while(@data = $queryAuthorCheck->fetchrow_array()){
		print "Data: ";
		print $data[1];
		print "\n";
		my $groupIDs = $data[0];
		my @ids = split(',', $data[0]);
		my $default_id;

		for($i = 0; $i < scalar(@ids); $i++){
			if($i == 0){
				$default_id = $ids[$i];
			}
			else
			{
				my $queryCodexesAuthors = $myConnection->prepare("SELECT * FROM CODEXES_AUTHORS WHERE FK_AUTHOR_ID = ?");
				$queryCodexesAuthors->execute($ids[$i]) or die $DBI::errstr;
				my $updateCodexesAuthors = $myConnection->prepare("UPDATE CODEXES_AUTHORS SET FK_AUTHOR_ID = ? WHERE FK_AUTHOR_ID = ?");
				while(@data = $queryCodexesAuthors->fetchrow_array()){
					$updateCodexesAuthors->execute($default_id, $ids[$i]);
				}
				$updateCodexesAuthors->finish();
				$queryCodexesAuthors->finish();
			}
		}
	}
	$queryAuthorCheck->finish();

}

sub delete_entries_in_codexes_authors{
	print "List of Codex IDs: ";
	my $codexIDS = <STDIN>;
	chomp $codexIDS;

	print "Author ID: ";
	my $authorID = <STDIN>;
	chomp $authorID;

	my @data = split(',' , $codexIDS);
	foreach $cID (@data){
		my $deleteQuery = $myConnection->prepare("DELETE FROM CODEXES_AUTHORS WHERE FK_CODEX_ID = ? AND FK_AUTHOR_ID = ?");
		$deleteQuery->execute($cID, $authorID)
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
	my $query = $myConnection->prepare("SELECT CODEX_ID, CODEX_TEXT FROM CODEXES WHERE FK_GAME_ID = 64");
	$query->execute();
	while(@return = $query->fetchrow_array()){
		my $id = $return[0];
		my $text = $return[1];
		
		#$text = replace_non_utf_8_characters($text);
		#$text =~ s/If (.*?)(:|\.\.\.)/\<i\>If $1$2\<\/i\>/g;
		#$text =~ s/(\<i\>){2,}/\<i\>/g;
		#$text =~ s/(\<\/i\>){2,}/\<\/i\>/g;
		$text =~ s/\<br\>\<\/div\>\<div class\="ql-clipboard" tabindex="-1" contenteditable="true"\>\<\/div>\<div class="ql-tooltip ql-hidden" style="margin-top: -*[0-9]*px;"\>\<a class="ql-preview" target="_blank" href="about:blank"\>\<\/a\>\<input type="text" data-formula="e=mc\^2" data-link="https:\/\/quilljs.com" data-video="Embed URL"\>\<a class="ql-action"\>\<\/a\>\<a class="ql-remove"\>\<\/a\>\<\/div\>//g;

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