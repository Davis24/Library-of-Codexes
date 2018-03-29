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
$Data::Dumper::Sortkeys = 1;
use DBI;
use Encode;


my $filename = $ARGV[0];

#my $myConnection = DBI->connect("DBI:mysql:library:localhost", "root", "hMdCxTP7bpMAu3Bh");

my $string; #used to keep track of text from file
my $temp = 0; #temp is used to count off lines in instances where the CSV information for a single entry spans multiple lines
my $tempnum = 0; #used to assign codex information to the right spots
my $tempstring; #hold the text being read in from the text file
my %codexhash;
my $author_count = 4000;   #faster than quering the highest author ID everytime


shadow_of_mordor_check();

sub shadow_of_mordor_check{
	### Part 1 - Open File ###
	open(my $fh, '<:encoding(UTF-8)', $filename) or die "Could not open";	
	### Part 2 - Read file and put into hash
	while(my $row = <$fh>)
	{
		chomp $row;
		$row =~ s/\\xA0/ /g;

		my @text = split('","', $row);

			## Title fixes
			$text[5] =~ s/"//g;
			$text[5] =~ s/([\w']+)/\u\L$1/g;
			
			text_sanitize($text[6]);

			$codexhash{$tempnum}{Title} = $text[5];
			$codexhash{$tempnum}{Author} = '0'; #temp 
			
			$tempnum++;
		print "running";		
		#$string .= $row;
	}

	### Part 3 - Check Empty (before enabling this run ascii to make sure all replaces are accounted for)
	#check_for_null();
	### Part 4 - Check ASCII #####
	replace_ascii();
	### Part 5 - Add Codexes to DB
	#insert_codex(11);
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
	my $query = $myConnection->prepare("INSERT INTO CODEXES (CODEX_ID, CODEX_TITLE, CODEX_TEXT, FK_AUTHOR_ID, FK_GAME_ID) values (?,?,?,?,?)");

	for my $item (keys %codexhash){
		$query->execute(undef, $codexhash{$item}{Title}, $codexhash{$item}{Text}, $codexhash{$item}{Author}, $_[0]) or die $DBI::errstr;	
		$query->finish();
	}
}

sub print_hash{
	#my %tempHash = $_[0];
	print "########################################\n";
	print Dumper \%codexhash;
	print "########################################\n";
}

sub replace_ascii{
	print "Start of Text ASCII Replacing \n";
	for my $item (keys %codexhash){
		for my $subitem (keys %{$codexhash{$item}}) {
			my @array = split(//, $codexhash{$item}{$subitem});	
			my $replaceString;
			foreach my $r (@array){
				if(ord($r) > 128)
				{
					print "$r is higher than 128 - ".ord($r)."\n";
				}
				if(ord($r) == 8211)
				{
					$replaceString .= "&ndash;";
				}
				elsif(ord($r) == 8203)
				{
					$replaceString .= "";	
				}
				elsif(ord($r) == 8212)
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
				elsif(ord($r) == 8230) # 8230 = …
				{
					$replaceString .= "&#8230;";
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
				elsif(ord($r) == 176)    #176 =  ° 
				{
					$replaceString .="&#176;";
				}
				elsif(ord($r) ==  235) #235 = ë
				{
					$replaceString .="&#235;";
				}
				elsif(ord($r) ==  243) #243 = ó
				{
					$replaceString .="&#243;";
				}
				elsif(ord($r) ==  250) #250 = ú 
				{
					$replaceString .="&#250;";
				}
				elsif(ord($r) ==  251) #251 = û 
				{
					$replaceString .="&#251;";
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
	$text =~ s/\\xE9/&#233;/g;
	$text =~ s/\\xB8/&cedil;/g;
	$text =~ s/\\xEF/&#239;/g;
	$text =~ s/\\x97/&mdash;/g;
	$text =~ s/\\x96//g;
	$text =~ s/Memory Audio/<b>Memory Audio<\/b>/g; #only for Shadows of Mordor
	$text =~ s/Codex entry.*//s; #only for dragon age
	$text =~ s/\[[0-9]+\]"//s; #only for metroid prime


	$codexhash{$tempnum}{Text} = $text;	
}

######################### Elder Scrolls Subroutines #############################
sub elder_scrolls_check{
	### Part 1 - Open File ###
	open(my $fh, '<:encoding(UTF-8)', $filename) or die "Could not open";	
	### Part 2 - Read file and put into hash
	while(my $row = <$fh>)
	{
		chomp $row;
		$row =~ s/\\xA0/ /g;
		$row =~ s/\\x92/'/g;

		if($temp < 2)
		{
			$tempstring .= $row;
			$temp++;
		}
		else{
			my @words = split('","', $tempstring);

			## Title fixes
			$words[0] =~ s/"//g;
			$words[0] =~ s/([\w']+)/\u\L$1/g;
			## Author Fixes
			$words[2] =~ s/A(.)*://g;   
			$words[2] =~ s/\\xA0//g;
			$words[2] =~ s/^\s+|\s+$//g;

			#In some instances the web scrapper had two text columns
			#Whichever is larger is used as the text (not sure on accuracy)
			if(scalar @words == 5) {
				if(length($words[3]) > length($words[4])) {
					text_sanitize($words[3]);
				}	
				else {
					text_sanitize($words[4]);
				}			
			}
			elsif(scalar @words == 6)
			{
				if(length($words[3]) > length($words[4]) && length($words[3]) > length($words[5])) {
					text_sanitize($words[3]);
				}
				elsif(length($words[4]) > length($words[3]) && length($words[4]) > length($words[5])){
					text_sanitize($words[4])
				}	
				else {
					text_sanitize($words[5]);
				}		
			}
			else{	
				text_sanitize($words[3]);
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
	check_for_null();
	### Part 4 - Check ASCII #####
	replace_ascii();
}

sub elder_scrolls_insert{
	### Part 1 - Open File ###
	open(my $fh, '<:encoding(UTF-8)', $filename) or die "Could not open";	
	### Part 2 - Read file and put into hash
	while(my $row = <$fh>)
	{
		chomp $row;
		$row =~ s/\\xA0/ /g;

		if($temp < 2)
		{
			$tempstring .= $row;
			$temp++;
		}
		else{
			my @words = split('","', $tempstring);

			## Title fixes
			$words[0] =~ s/"//g;
			$words[0] =~ s/([\w']+)/\u\L$1/g;
			## Author Fixes
			$words[2] =~ s/A(.)*://g;   
			$words[2] =~ s/\\xA0//g;
			$words[2] =~ s/^\s+|\s+$//g;

			#In some instances the web scrapper had two text columns
			#Whichever is larger is used as the text (not sure on accuracy)
			if(scalar @words == 5) {
				if(length($words[3]) > length($words[4])) {
					text_sanitize($words[3]);
				}	
				else {
					text_sanitize($words[4]);
				}			
			}
			elsif(scalar @words == 6)
			{
				if(length($words[3]) > length($words[4]) && length($words[3]) > length($words[5])) {
					text_sanitize($words[3]);
				}
				elsif(length($words[4]) > length($words[3]) && length($words[4]) > length($words[5]))
				{
					text_sanitize($words[4])
				}	
				else {
					text_sanitize($words[5]);
				}		
			}
			else{	
				text_sanitize($words[3]);
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
	check_for_null();
	### Part 4 - Check ASCII #####
	replace_ascii();
	### Run the second time
	### Part 4 - Check if Author exists in MYSQL, if author exists replace 
	authors_call();
	### Part 5 - Add Codexes to DB
	insert_codex();
}

######################### Dishonored Subroutines ##################################
sub dishonored2_audiodiographs{
	### Part 1 - Open File ###
	open(my $fh, '<:encoding(UTF-8)', $filename) or die "Could not open";	
	### Part 2 - Read file and put into hash
	while(my $row = <$fh>)
	{
		chomp $row;
		my @words = split('","', $row);
		
		$words[3] =~ s/\\xA0//g;
		$words[3] =~ s/\},\{/\},~\{/g;
		$words[3] =~ s/^\s+|\s+$//g;

		$codexhash{$tempnum}{Title} = $words[2];
		$codexhash{$tempnum}{Author} = $words[4];

				
		#print "-------Text Split--------\n";
		#print Dumper @text;
		if($words[4] =~ m/ recorded (by|By) /)
		{
			@author = split(/recorded (by|By)/, $words[4]);
			$author[2] =~ s/^\s+|\s+$//g;
			$author[2] =~ s/\.//g;
			$author[2] =~ s/\"//g;
			$codexhash{$tempnum}{Author} = $author[2];
		}	

		my $tempVar = scalar @text;
		my $string1 = $text[$tempVar-1];
		my $thestring;

		my @text = split ('~', $words[3]);
		foreach $a (@text){
			if($a =~ m/ can be found/)
			{
				
			}	
			else{
				$thestring .= $a;
			}
		}		
		text_sanitize($thestring);	

		$tempnum++;
	}
	
	
	### Part 3 - Check Empty (before enabling this run ascii to make sure all replaces are accounted for)
	check_for_null();
	### Part 4 - Check ASCII #####
	replace_ascii();	
	### Part 4 - Check if Author exists in MYSQL, if author exists replace 
	#authors_call();
	### Part 5 - Add Codexes to DB
	#insert_codex();
	print_hash();
}

sub dishonored2_notes{
	### Part 1 - Open File ###
	open(my $fh, '<:encoding(UTF-8)', $filename) or die "Could not open";	
	### Part 2 - Read file and put into hash
	while(my $row = <$fh>)
	{
		chomp $row;
		my @words = split('","', $row);
		
		$words[3] =~ s/\\xA0//g;
		$words[3] =~ s/\},\{/\},~\{/g;
		$words[3] =~ s/^\s+|\s+$//g;

		$codexhash{$tempnum}{Title} = $words[2];
		$codexhash{$tempnum}{Author} = "temp";
		
		if($words[2] =~ m/ (by|By) /)
		{
			@author = split(/(by|By)/, $words[2]);
			$author[2] =~ s/^\s+|\s+$//g;
			$codexhash{$tempnum}{Author} = $author[2];
			$codexhash{$tempnum}{Title} = $author[0];
		}	

		#used to delete the extra text the web scrapper pulls 
		my $tempVar = scalar @text;
		my $string1 = $text[$tempVar-1];
		my $thestring;

		my @text = split ('~', $words[3]);
		foreach $a (@text){
			if($a =~ m/ can be found/) #both of these are sentences from the wiki that aren't codex text
			{
				
			}
			elsif($a =~ m/ can be looted/)
			{

			}	
			else{
				$thestring .= $a;
			}
		}		
		text_sanitize($thestring);	
		$tempnum++;
	}
	
	### Part 3 - Check Empty (before enabling this run ascii to make sure all replaces are accounted for)
	check_for_null();
	### Part 4 - Check ASCII #####
	replace_ascii();	
	### Part 4 - Check if Author exists in MYSQL, if author exists replace 
	authors_call();
	### Part 5 - Add Codexes to DB
	insert_codex();
	print_hash();
}


## Needs more documentation -- was used to tell if last line had the author
sub detect_authors{
	my $query = $myConnection->prepare("SELECT CODEX_ID, CODEX_TEXT FROM CODEXES WHERE FK_GAME_ID = 11");
	$query->execute();
	while(@data = $query->fetchrow_array()){
		my $codex_id = $data[0];
		my @text = split('\n',$data[1]);
		my $tempString = $text[scalar @text-1];
		#print $tempString . ": ";
		my @matched = split('by ',$tempString);
		if(defined($matched[1]))
		{
			my @punc = split (/[,|.|?]/, $matched[1]);
			my $statement = $myConnection->prepare("INSERT INTO AUTHORS (AUTHOR_ID, TITLE, FIRST_NAME, LAST_NAME, BIOGRAPHY, FK_GAME_ID) values (?,?,?,?,?,?)");
			$statement->execute($author_count, "", $punc[0], "", "[To be added]", $_[0]) or die $DBI::errstr;	
			$statement->finish();

			#print $punc[0] . "\n";
			my $update = $myConnection->prepare("UPDATE CODEXES SET FK_AUTHOR_ID = ? WHERE CODEX_ID = ?");
			$update->execute($author_count,$codex_id) or die $DBI::errstr;
			$update->finish();

			$author_count++;
		}
		
		
	}
}


### Dragon age stuff while likely be removed later
sub remove_extras_text_dragon_age{
	my $string_temp;
	my $query = $myConnection->prepare("SELECT CODEX_ID, CODEX_TEXT FROM CODEXES WHERE FK_GAME_ID = 11");
	$query->execute();
	while(@data = $query->fetchrow_array()){
		my @text = split('\n',$data[1]);
		foreach my $r (@text){
			if($r =~ /Dragon Age (2|:)/)
			{

			}
			elsif($r =~ /Dragon Age: /)
			{

			}
			elsif($r =~ /According to Dragon Age (tabletop RPG)/)
			{

			}
			elsif($r =~ /<img/)
			{

			}
			elsif($r =~ /Damage against/)
			{

			}
			elsif($r =~ /this codex/i)
			{

			}
			elsif($r =~/â”€/)
			{
				$r =~ s/(â”€)+/&mdash;/g;
				$string_temp .= $r ."\n";
				#print "found it";
			}
			elsif($r =~ /Ãª/)
			{
				$r =~ s/(Ãª)+/&#234;/g;
			}
			else
			{
				$string_temp .= $r ."\n";
			}
		}
		
		my $statement = $myConnection->prepare("UPDATE CODEXES SET CODEX_TEXT = ? WHERE CODEX_ID = ?");
		$statement->execute($string_temp, $data[0]) or die $DBI::errstr;
		$statement->finish();
		$string_temp = "";
	}
	$query->finish();

}

## know the type for the ebook format
sub dragon_age_seperate_type{
	open(my $fh, '<:encoding(UTF-8)', $filename) or die "Could not open";	


	open my $creatures, '>', "creatures.txt" or die $!;
	open my $places, '>', "places.txt" or die $!;
	open my $characters, '>', "characters.txt" or die $!;
	open my $notes, '>', "notes.txt" or die $!;
	open my $items, '>', "items.txt" or die $!;
	open my $lore, '>', "lore.txt" or die $!;
	open my $letters, '>', "letters.txt" or die $!;
	open my $art, '>', "art.txt" or die $!;
	open my $magic, '>', "magic.txt" or die $!;
	open my $unknown, '>', "unknown.txt" or die $!;
	open my $culture, '>', "culture.txt" or die $!;
	open my $songs, '>', "songs.txt" or die $!;
	open my $controls, '>', "controls.txt" or die $!;
	open my $spellcombo, '>', "spellcombo.txt" or die $!;
	open my $tales, '>', "tales.txt" or die $!;
	open my $crafting, '>', "crafting.txt" or die $!;
	open my $tutorials, '>', "tutorials.txt" or die $!;
	open my $groups, '>', "groups.txt" or die $!;
	open my $maps, '>', "maps.txt" or die $!;
	open my $history, '>', "history.txt" or die $!;

	my $count = 0;
	while(my $row = <$fh>)
	{
		my $unedited_row = $row;
		my @values = split('","', $row);

		
		if($values[4] =~ /places/i)
		{
			print $places $row;
		}
		elsif($values[4] =~ /culture/i)
		{
			print $culture $row;
		}
		elsif($values[4] =~ /songs/i)
		{
			print $songs $row;
		}
		elsif($values[4] =~ /controls/i)
		{
			print $controls $row;
		}
		elsif($values[4] =~ /spell/i)
		{
			print $spellcombo $row;
		}
		elsif($values[4] =~ /quest/i)
		{
			print $quest $row;
		}
		elsif($values[4] =~ /creatures/i)
		{
			print $creatures $row;
		}
		elsif($values[4] =~ /places/i)
		{
			print $places $row;
		}
		elsif($values[4] =~ /characters/i)
		{
			print $characters $row;
		}
		elsif($values[4] =~ /letters and notes/i)
		{
			print $letters $row;
		}
		elsif($values[4] =~ /notes/i)
		{
			print $notes $row;
		}
		elsif($values[4] =~ /lore/i)
		{
			print $lore $row;
		}
		elsif($values[4] =~ /art/i)
		{
			print $art $row;
		}
		elsif($values[4] =~ /items/i)
		{
			print $items $row;
		}
		elsif($values[4] =~ /magic/i)
		{
			print $magic $row;
		}
		elsif($values[4] =~ /tales/i)
		{
			print $tales $row;
		}
		elsif($values[4] =~ /crafting/i)
		{
			print $crafting $row;
		}
		elsif($values[4] =~ /groups/i)
		{
			print $groups $row;
		}
		elsif($values[4] =~ /tutorial/i)
		{
			print $tutorials $row;
		}
		elsif($values[4] =~ /maps/i)
		{
			print $maps $row;
		}
		elsif($values[4] =~ /history/i)
		{
			print $history $row;
		}
		else
		{
			print $values[4] ."\n";
			print $unknown $row;
		}
	}
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


sub metroid_prime_check{
	### Part 1 - Open File ###
	open(my $fh, '<:encoding(UTF-8)', $filename) or die "Could not open";	
	### Part 2 - Read file and put into hash
	while(my $row = <$fh>)
	{
		chomp $row;
		$row =~ s/\\xA0/ /g;

		my @words = split('","', $row);

			## Title fixes
			$words[0] =~ s/"//g;
			$words[0] =~ s/([\w']+)/\u\L$1/g;
			
			text_sanitize($words[2]);

			$codexhash{$tempnum}{Title} = $words[0];
			$codexhash{$tempnum}{Author} = 2201;
			
			$tempnum++;
		
		$string .= $row;
	}

	### Part 3 - Check Empty (before enabling this run ascii to make sure all replaces are accounted for)
	check_for_null();
	### Part 4 - Check ASCII #####
	replace_ascii();
	### Run the second time
	### Part 4 - Check if Author exists in MYSQL, if author exists replace 
	#authors_call();
	### Part 5 - Add Codexes to DB
	insert_codex(11);
	print_hash();
}
