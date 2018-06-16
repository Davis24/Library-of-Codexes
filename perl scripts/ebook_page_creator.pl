
#!/usr/bin/perl -w
# Megan Davis
# Updated: 6/07/2018
# Library of Codexes - Assistant Script

######################### Program Statement #########################	 
# The ebook_page_creator program is designed easily convert mysql entries into
# properly formated ebook html pages.
#####################################################################

use warnings;
use DBI;

$myConnection = DBI->connect("DBI:mysql:library:localhost", "root", "");

#User information request
print "-- Library of Codexes -- \n";
print "START ID #: ";
my $start_ID = <>;
print "END ID #: ";
my $end_ID = <>;

my $int = 1;

createFiles();

sub createFiles{

	#Create a file for each ID that contains the proper HTML
	for(my $i = $start_ID; $i <= $end_ID; $i++)
	{
		$query = $myConnection->prepare("SELECT
											CODEX_ID,
											CODEX_TITLE,
											CODEX_TEXT,
											c.FK_SERIES_ID,
											GROUP_CONCAT(a.NAME ORDER BY a.NAME SEPERATOR ', ') AUTHORS
										FROM 
										codexes c
												INNER JOIN
													codexes_authors z ON c.CODEX_ID = z.FK_CODEX_ID
												INNER JOIN
													AUTHORS a ON z.FK_AUTHOR_ID = a.AUTHOR_ID
										GROUP BY
											c.CODEX_ID,
											c.CODEX_TITLE
										HAVING c.CODEX_ID = $i");
		$query->execute() or die $DBI::errstr;
		while(@array = $query->fetchrow_array()){
			#stripping file information
			my $fileName = $array[1];
			$fileName =~ s/(:|"|\?|\.)//g;
			$fileName =~ s/(\\|\/)/ /g;
			$fileName = $fileName.".html";

			#Text
			$array[3] =~ s/\n(.*?)\n/<p>$1<\/p>/g;

			#Author
			$array[4] =~ s/(.*?)(\[(.*?)\])/$1/g;

			if(-f $fileName)
			{
				$fileName = $fileName." (".$int.").html";
				$int++;
			}

			#opening file
			open(my $fh, '>', $fileName) or die "Failed on ID $i";
			print $fh "<html><head><title> $array[1] </title><link rel=\"stylesheet\" href=\"author.css\"/></head><body> \n"; 
			print $fh "<h1>$array[1]</h1> \n";
			print $fh "<p class =\"author\">By</p>\n";
			print $fh "<p class =\"author\"> $array[4] </p><br/> \n";
			print $fh "<p> $array[2] </p> \n";	
			print $fh "</body> \n </html>";
			close $fh;
		}
	}
}
