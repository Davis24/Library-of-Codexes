
#!/usr/bin/perl -w
# Megan Davis
# 12/31/2016
# Library of Codexes - Assistant Script

######################### Program Statement #########################	 
# The ebook_page_creator program is designed easily convert mysql entries into
# properly formated ebook html pages.

##################### How To Use ##################################
# The program has been compiled and tested on Windows 10 using Strawberry Perl. 
#	
#	Steps: 
#   1. Open command prompt 
#	2. Change directory to where ebook_page_creator.pl is located
#	3. Enter perl ebook_page_creator.pl into command prompt
#	4. When prompted enter the start ID for the codex
#	5. When prompted enter the end ID for the codex 
#	6. Files will now be created and located in the ebook_page_creator.pl folder
#

####################### Algorithm Design #######################

# The algorithm below works through an for loop structure. The user will input the start and stop codex ID. 
# Within the loop the proper query will be created and executed pulling the proper information and outputing it to
# the file.
# The exact step by step implementation is below.

# 1. The program is executed.
# 2. User will be prompted to enter start ID.
# 3. User will be prompted to enter end ID.
# 4. For loop is executed.
#	4.1) Query is prepared and executed
#	4.2) The file name (aka codex title) will be stripped of any possible invalid characters,
#		 that would prevent the file from being created
#   4.3) Codex Text is stripped of newline characters and replaced the <p></p> 
#	4.4) File is opened/created
#	4.5) Text is written to file
#	4.6) File is closed
# 5. Step 4 repeats until end ID is reached.

use warnings;
use DBI;


$myConnection = DBI->connect("DBI:mysql:library:localhost", "root", "hMdCxTP7bpMAu3Bh");

#User information request
print "-- Library of Codexes -- \n";
print "START ID #: ";
$start_ID = <>;
print "END ID #: ";
$end_ID = <>;


#Create a file for each ID that contains the proper HTML
for( $i = $start_ID; $i <= $end_ID; $i++)
{

	$query = $myConnection->prepare("SELECT CODEX_TITLE, CONCAT(authors.FIRST_NAME, ' ', authors.LAST_NAME) as name, FK_AUTHOR_ID, CODEX_TEXT FROM codexes INNER JOIN authors ON FK_AUTHOR_ID = authors.AUTHOR_ID WHERE CODEX_ID = $i");
	$query->execute();

	while(@test = $query->fetchrow_array())
	{	
		#stripping file information
		$filename_stripped = $test[0];
		$filename_stripped =~ s/(:|"|\?)//g;
		$filename = $filename_stripped.".html";
		$var = "<p></p>";
		$test[3] =~ s/\n/$var/g;

		#opening filing 
		open(my $fh, '>', $filename) or die "Failed on ID $i";
		print $fh "<html><head><title> $test[0] </title></head><body> \n"; 
		print $fh "<h2><b> $test[0] </b></h2> \n";
		print $fh "<h3><b> $test[1] </b></h3> \n";
		print $fh "<p> $test[3] </p> \n";	
		print $fh "</body> \n </html>";
		close $fh;
	}	
}




