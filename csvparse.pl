#use 5.010;
use strict;
use warnings;

use Text::CSV; # in Debian package "libtext-csv-perl"
use File::Basename;

my $csv = Text::CSV->new({sep_char => ','});
#my $out = Text::CSV->new({sep_char => ','});
my $file = $ARGV[0] or die "Need an input file\n";
#print $file;

my @cols = (3,4,21);

my @out;

open(my $of, ">", "asdf.csv");

my $linenum = 0;
my $data;
if(((fileparse("$file",qr/\.[^.]*/))[2]) eq ".gz")
{
	open($data, "gunzip -c $file |") or die "Can't open pipe to $file: $!";
}
else
{
	open($data, "<:encoding(utf8)", "$file") or die "Can't open $file: $!";
}
while (defined(my $line = <$data>))
{
	$linenum+=1;
	chomp $line;
	 
	if ($csv->parse($line))
	{
		my @fields = $csv->fields();
		
		if(scalar @fields<2)
		{
			next;
		}
		
		my @tmp;
		
		my %colsmap = map { $_ => 1 } @cols;
		
		for(my $i = 0; $i < scalar @fields; $i++)
		{
			$fields[$i] =~ s/^\s*(.*?)\s*$/$1/;
			if(exists($colsmap{$i}))
			{
				#$tmp=$tmp."$fields[$i],";
				push @tmp,"$fields[$i]";
				#print "$fields[$i],";
			}
		}
		
		#print "$fields[3],$fields[4],$fields[21]\n";
		#push @out,"$fields[3],$fields[4],$fields[21]\n";
		#push @out,"$tmp";
		#print "\n";
		#print "@tmp\n";
		my $status = $csv->combine(@tmp);
		if(defined($status))
		{
			push @out,$csv->string();
			#$csv->print($of,@tmp);
			print $of $csv->string()."\n";
		}
		 
	} else
	{
		warn "Line could not be parsed: $line\n";
	}
}

#$csv->eof or $csv->error_diag();
close $data;

#print "@out\n";
#$csv->print ($of,$_) for @out;
#$csv->print($of,$out);
close $of or die "asdf.csv: $!";
