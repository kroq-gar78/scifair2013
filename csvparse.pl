use 5.010;
use strict;
use warnings;

use Text::CSV; # in Debian package "libtext-csv-perl"

my $csv = Text::CSV->new({sep_char => ','});
my $file = $ARGV[0] or die "Need an input file\n";
print $file;

my @out;

my $linenum = 0;
open(my $data, "<:encoding(utf8)", "$file");
while (my $line = <$data> or die "Failed to read $file: $!")
{
	$linenum+=1;
	chomp $line;
	 
	if ($csv->parse($line))
	{		 
		my @fields = $csv->fields();

		for(my $i = 0; $i < scalar @fields; $i++)
		{
			$fields[$i] =~ s/^\s*(.*?)\s*$/$1/;
		}

		print "$fields[3],$fields[4],$fields[21]\n";
		push @out,@fields;
		 
	} else
	{
		warn "Line could not be parsed: $line\n";
	}
}

print "@out\n";

close $data;
