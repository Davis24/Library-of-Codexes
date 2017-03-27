#!/usr/bin/perl -w

use Data::Dumper qw(Dumper);
$Data::Dumper::Sortkeys = 1;
use Encode;
#use strict;
use warnings;

my %codexhash;
my $filename;
my $count = 0;

my $filename2;
my $f;

my $string;

my %cardHash;

addNewCard();


sub allFilesInDirectory{
	my @files = <*.txt>;
	for $file (@files){

		$filename = $file;
		#collection();
		individualCard();
		#dataDump();
		printToCSV();	
	
		%cardHash = ();
		undef %cardHash;
	}	
}



sub addNewCard{
	$filename = $ARGV[0];
	print "Title: ";
	my $title = <STDIN>;
	chomp $title;

	print "Text: \n";
	print "---CTRL-Z to break----\n";
	my @a;
	while (<STDIN>) {
    	push @a, $_;
	}
	#print @a;
	my $arrayString = "";	
	foreach my $i (@a){
		$arrayString .= $i;
	}

	$arrayString =~ s/\n([A-Z])/\\n\\n$1/g;
	$arrayString =~ s/\n([a-z])/ $1/g; 

	open (my $f, '>>', $filename) or die "Couldn't open";
	print $f $title." '','' ".$arrayString;
	close $filename;
}



sub individualCard{
	open(my $fh, '<:encoding(UTF-8)', $filename) or die "Could not open";
	while(my $row = <$fh>)
	{
		if($row =~ /Card: (.)*/)
		{

			$row =~ s/Card://g;
			$row =~ s/, Points: (.)*//g;
			$row =~ s/^\s+|\s+$//g; 
			#print "$row \n";


			if($count > 0)
			{	
				$string =~ s/\n([A-Z])/\\n\\n$1/g;
				$string =~ s/\n([a-z])/ $1/g;
				$cardHash{$count-1}{Text} = $string;
			}
			$cardHash{$count}{Title} = $row;
			
			
			#open ($f, '>', $filename2) or die "Couldn't open";
			#print $f $row;
			$count++;
			$string = "";
		}
		else
		{
			$string .= "$row";	
		}
		
	}
	$string =~ s/\n([A-Z])/\\n\\n$1/g;
	$string =~ s/\n([a-z])/ $1/g;
	$cardHash{$count-1}{Text} = $string;

}

sub printToCSV{
	$filename .= ".txt";
	open (my $f, '>', $filename) or die "Couldn't open";
	for my $item (keys %cardHash)
	{
		print $f $cardHash{$item}{Title}." '','' ".$cardHash{$item}{Text};

	}
	close $filename;

}

sub collection{

open(my $fh, '<:encoding(UTF-8)', $filename) or die "Could not open";
while(my $row = <$fh>)
{
	if($row =~ /Collection: (.)*/)
	{

		$row =~ s/Collection://g;
		$row =~ s/\s+//g;

		if($count > 0)
		{
			print $f $string;
			close $filename2;
		}
		$filename2 = $row.".txt"; 
		open ($f, '>', $filename2) or die "Couldn't open";
		print $f $row;
		$count++;
		$string = "";
	}
	else
	{
		$string .= "$row";	
	}

	

}


print $f $string;
}


sub dataDump{
	print "########################################\n";
	print Dumper \%cardHash;
	print "########################################\n";
}
