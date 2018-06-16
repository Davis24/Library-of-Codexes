#!/usr/bin/perl -w

############################################################
#	database_entry_manipulation.pl
#	04/03/2017
# 	Author: Davis24 (https://github.com/Davis24)
#	Purpose: Used to edit database entries for Library of Codexes
#	
#	SubFunctions:
#
#	delete_codexes -- Deletes the Codex_IDs passed in through a file 
#	delete_extra_codexes -- Finds and deletes the codexes that have the same Codex_Title and the same Codex_Text length. Both of these imply they're equivalent thefore 'extras'
#	delete_authors -- Deletes authors that have the same name and are from the same game -- during this the codexes assigned to the soon to be deleted duplicate will be reassigned to non-deleted author
#	delete_empty_authors -- Deletes authors that don't have any works
#	duplicate_author_name_mismatch -- Functions very simliarly to delete_authors, however in a CSV file must be passed in with the format #Correct Author_ID, #Incorrect Author_ID
#	update_codex_text -- Updates the Codex_Text for the Codex_ID given
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


my $myConnection = DBI->connect("DBI:mysql:library:localhost", "root", "");

#menu();

check_if_author_is_in_codexes_authors();
check_if_codex_is_in_codexes_authors();

sub insert_author_to_existing_codex{
	print "Author Name: ";
	my $authorName = <STDIN>;
	chomp $authorName;
	$authorName =~ s/('|")//g;
	
	print "Series ID: ";
	my $seriesID = <STDIN>;
	chomp $seriesID;
	
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
	
	##Find Codex ID, exit if no codex is found
	#my $codexQuery = $myConnection-> prepare("SELECT CODEX_ID FROM CODEXES WHERE CODEX_TITLE LIKE '$codexTitle' AND FK_SERIES_ID = $seriesID");
	#$codexQuery->execute();
	#if($codexQuery->rows > 0)
	#{
	#	while (@data = $codexQuery->fetchrow_array()) {
     #       $codexID = $data[0];
      #  }	
		#print "Codex Found - $codexID\n";
	#}
	#else
	#{
	#	print "Error: No Codex Found!\n";
	#	exit();
	#}
	#$codexQuery->finish();

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



##haven't tested since augmenting code
sub delete_codexes{
	print "File: ";
	my $file = <STDIN>;
	#open(my $file, '<:encoding(UTF-8)', $filename) or die "Could not open";
	while(my $row = <$fh>){
		chomp $row;		
		my $query = $myConnection->prepare("DELETE FROM codexes WHERE CODEX_ID = ?");
		$query->execute($row) or die $DBI::errstr;
		$query->finish();
	}
}

sub delete_extra_codexes{
	my $query = $myConnection->prepare("SELECT GROUP_CONCAT(CODEX_ID) as ids, COUNT(*) c, CODEX_TITLE as name FROM codexes WHERE FK_GAME_ID = 32 GROUP BY name HAVING c = 2");
	$query->execute();
	while(@return = $query->fetchrow_array())
	{	
		my @IDS = split(',', $return[0]); #id[0] is the smallest ID it's probably the most accurate, 
		my ($codex1) = $myConnection->selectrow_array("SELECT LENGTH(CODEX_TEXT) FROM CODEXES WHERE CODEX_ID = $IDS[0]");
		my ($codex2) = $myConnection->selectrow_array("SELECT LENGTH(CODEX_TEXT) FROM CODEXES WHERE CODEX_ID = $IDS[1]");

		if(($codex1 == $codex2))
		{
			print "$IDS[0] : $IDS[1] EQUAL \n";

			my $delete = $myConnection->prepare("DELETE FROM CODEXES WHERE CODEX_ID = $IDS[1]");
			$delete->execute();
			$delete->finish();
		}
	}

	print "DELETE EXTRA CODEXES FINISHED \n";
}

##haven't tested since augmenting code
sub delete_authors{
	print "Series ID: ";
	my $gID = <STDIN>;
	chomp $gID;

	my $query = $myConnection->prepare("SELECT GROUP_CONCAT(AUTHOR_ID) as ids, COUNT(*) c, NAME FROM authors WHERE FK_SERIES_ID = ? GROUP BY name HAVING c > 1");
	$query->execute($gID);
	while(@return = $query->fetchrow_array()){	
		my @IDS = split(',', $return[0]); #id[0] smallest ID so probably the most accurate, 

		my $statement = $myConnection->prepare("SELECT CODEX_ID FROM codexes WHERE FK_AUTHOR_ID = ?");
		$statement->execute($IDS[1]) or die $DBI::errstr;	
		while(@codex_ids = $statement->fetchrow_array()){
			print "\n CODEX ID = ".$codex_ids[0];

			my $statement2 = $myConnection->prepare("UPDATE CODEXES SET FK_AUTHOR_ID = ? WHERE CODEX_ID = ?");
			$statement2->execute($IDS[0],$codex_ids[0]) or die $DBI::errstr;
			$statement2->finish();			
		}
		$statement->finish();

		$statement = $myConnection->prepare("DELETE FROM authors WHERE AUTHOR_ID = ?");
		$statement->execute($IDS[1]) or die $DBI::errstr;
		$statement->finish();
	}
	$query->finish();	
}

sub delete_empty_authors{
	my @idArray;
	my $counter = 0; 

	$query = $myConnection->prepare("SELECT AUTHOR_ID FROM authors");
	$query->execute() or die $DBI::errstr;
	while(@return = $query->fetchrow_array()){	
		$idArray[$counter] = $return[0];
		$counter++;
	}
	$query->finish();

	for(my $i = 0; $i < scalar @idArray; $i++){
		$query = $myConnection->prepare("SELECT CODEX_ID FROM codexes WHERE FK_AUTHOR_ID = ?");
		$query->execute($idArray[$i]) or die $DBI::errstr;

		if($query->rows < 1){
			print "\nNo CODEXES: ".$idArray[$i]; 
			$query = $myConnection->prepare("DELETE FROM authors WHERE AUTHOR_ID = ?");
			$query->execute($idArray[$i]) or die $DBI::errstr;
		}
	}
	$query->finish();
}

##haven't tested since augmenting code
sub duplicate_author_name_mismatch{
	print "File: ";
	my $file = <STDIN>;
	#open(my $file, '<:encoding(UTF-8)', $filename) or die "Could not open";
	while(my $row = <$fh>){
		chomp $row;
		my @IDS = split(',',$row);

		my $query = $myConnection->prepare("SELECT CODEX_ID FROM codexes WHERE FK_AUTHOR_ID = ?");
		$query->execute($IDS[1]) or die $DBI::errstr;	
		while(@return = $query->fetchrow_array()){
			print "\n CODEX ID = ".$return[0];

			my $statement = $myConnection->prepare("UPDATE CODEXES SET FK_AUTHOR_ID = ? WHERE CODEX_ID = ?");
			$statement->execute($IDS[0],$return[0]) or die $DBI::errstr;
			$statement->finish();			
		}
		$query->finish();

		$statement = $myConnection->prepare("DELETE FROM authors WHERE AUTHOR_ID = ?");
		$statement->execute($IDS[1]) or die $DBI::errstr;
		$statement->finish();
	}
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

sub replace_non_utf_8_characters{
	return encode_entities($_[0]);
}


##No idea what this was used for originally -- keeping just in case it comes back
sub remove_extras_from_author{
	my $game_id = 1;
	my $seperatedValue = "\"";

	$query = $myConnection->prepare("SELECT CONCAT(FIRST_NAME,' ', LAST_NAME) as name, AUTHOR_ID FROM authors WHERE FK_GAME_ID = ?");
	$query->execute($game_id) or die $DBI::errstr;
	while(@return = $query ->fetchrow_array()){
		my @author = split ($seperatedValue, $return[0]);

		if(scalar @author > 1){
			print $return[1].": ".$author[0];
			print "\n";

			$statement = $myConnection->prepare("UPDATE AUTHORS SET FIRST_NAME = ? WHERE AUTHOR_ID = ?");
			$statement->execute($author[0], $return[1]) or die $DBI::errstr;
			$statement->finish();
		}
	}
	$query->finish();
}

