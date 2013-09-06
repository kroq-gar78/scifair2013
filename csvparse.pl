use 5.010;
use strict;
use warnings;

use Text::CSV; # in Debian package "libtext-csv-perl"

my $csv = Text::CSV->new({sep_char => ','});
my $file = $ARGV[0] or die "Need an input file\n";

my @out;

open(my $data, "<:encoding(utf8)", "test.csv");
while (my $line = <$data>)
{
	chomp $line;
	 
	if ($csv->parse($line))
	{		 
		my @fields = $csv->fields();
		#$sum += $fields[2];
		print "@fields\n";
		push @out,@fields;
		 
	} else
	{
		warn "Line could not be parsed: $line\n";
	}
}

print "@out\n";

close $data;
