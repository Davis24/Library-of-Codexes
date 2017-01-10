#!/usr/bin/perl -w

use Data::Dumper qw(Dumper);
use Encode;
#use strict;
use warnings;


my $filename = 'es_shadowkey.txt';
my $string;
my $temp = 0;
my $tempnum = 1;
my $tempstring;
my %titlehash;
my %authorhash;
my %texthash;
    

open(my $fh, '<:encoding(UTF-8)', $filename) or die "Could not open";

while(my $row = <$fh>){
	chomp $row;
	$row =~ s/\xA0/ /g;
	#print "ROW : $row \n\n";
	if($temp < 2)
	{
		$tempstring .= $row;
		$temp++;
		#print "Value : $temp  , row = $row \n";
	}
	else
	{
		#$tempstring .= $row;
		#print "FINAL STRING: $tempstring \n\n";
		print "########################################\n";
		
		my @words = split('","', $tempstring);
		$words[2] =~ s/A(.)*://g;
		$words[2] =~ s/^\s+|\s+$//g;

		$titlehash{$tempnum} = $words[0]; 
		
		$authorhash{$tempnum} = $words[2];

		$words[3] =~ s/\[\{""text"":""//g;
		$words[3] =~ s/""\}\]"//g;
		$words[3] =~ s/""\},\{""text"":""/\n\n/g;
		$texthash{$tempnum} = $words[3];
		foreach my $w (@words)
		{
			print "SPLIT: $w \n";
		}
		print "########################################\n";

		$temp = 1;
		$tempstring = "";
		$tempstring .= $row;
		$tempnum++;
	}
	
	$string .= $row;
	my @array = split(//, $row);

	foreach my $r (@array)
	{
		if(ord($r) > 128)
		{
			if(ord($r) == 8221)
			{
			#	print "\n equal to 8221";
			#	$replaceString .= "**";
			}
			#print "FAILED $r - ".ord($r)."\n";
		}
		else
		{
			#$replaceString .= $r;
		}
	}

}
for my $item (keys %titlehash) {
        print "The color of '$item' is $titlehash{$item}\n";
}

print Dumper \%titlehash;
print "########################################\n";

print Dumper \%authorhash;

print "########################################\n";
print Dumper \%texthash;

