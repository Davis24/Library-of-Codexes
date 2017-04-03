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
use Data::Dumper qw(Dumper);a
$Data::Dumper::Sortkeys = 1;
use DBI;
use Encode;

my $filename = $ARGV[0];
my $myConnection = DBI->connect("DBI:mysql:library:localhost", "root", "hMdCxTP7bpMAu3Bh");

menu();

sub menu{
	print "--------------------------\n";
	print "  Database Manipulation Menu \n";
	print "   1 - Delete Codexes \n";
	print "   2 - Delete Extra Codexes \n";
	print "   3 - Delete (Duplicate) Authors \n";
	print "   4 - Delete Empty Authors \n";
	print "   5 - Delete Duplicate Authors with Misspelled Names \n";
	print "   6 - Update Codex Text \n";
	print "  -1 - Exit \n";

	menu_response();
}

sub menu_response{
	while (1) {
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
			print_hash();
		}
		elsif($response == -1)
		{
			last;
		}
	}
}


##haven't tested since augmenting code
sub delete_codexes{
	print "File: ";
	my $file = <STDIN>;
	open(my $file, '<:encoding(UTF-8)', $filename) or die "Could not open";
	while(my $row = <$fh>){
		chomp $row;		
		my $query = $myConnection->prepare("DELETE FROM codexes WHERE CODEX_ID = ?");
		$query->execute($row) or die $DBI::errstr;
		$query->finish();
	}
}

sub delete_extra_codexes{
	my $query = $myConnection->prepare("SELECT GROUP_CONCAT(CODEX_ID) as ids, COUNT(*) c, CODEX_TITLE as name FROM codexes WHERE FK_GAME_ID = 11 GROUP BY name HAVING c = 2");
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
	print "Game ID: ";
	my $gID = <STDIN>;
	chomp $gID;

	my $query = $myConnection->prepare("SELECT GROUP_CONCAT(AUTHOR_ID) as ids, COUNT(*) c, REPLACE(CONCAT(FIRST_NAME,LAST_NAME),' ','') as name FROM authors WHERE FK_GAME_ID = ? GROUP BY name HAVING c > 1");
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
	open(my $file, '<:encoding(UTF-8)', $filename) or die "Could not open";
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

	$query = $myConnection->prepare("UPDATE CODEXES SET CODEX_TEXT = ? WHERE CODEX_ID = ?");
	$query->execute($text, $codexID) or die $DBI::errstr;
	$query->finish();
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

##No idea what this was used for originally -- keeping just in case it comes back
sub fix_text{
	my $query = $myConnection-> prepare("SELECT CODEX_ID, CODEX_TEXT, CODEX_TITLE FROM codexes WHERE FK_GAME_ID = 11");
	$query->execute();

	while(@data = $query->fetchrow_array()){
		if($data[1] =~ m/""/)
		{
			$data[1] =~ s/""/"/g;
		}	
		
		my $statement = $myConnection->prepare("UPDATE CODEXES SET CODEX_TEXT = ? WHERE CODEX_ID = ?");
		$statement->execute($data[1], $data[0]) or die $DBI::errstr;
		$statement->finish();
	}
	$query->finish();

}

