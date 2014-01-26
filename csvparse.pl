#use 5.010;
use strict;
use warnings;
use Switch;

use Text::CSV; # in Debian package "libtext-csv-perl"
use File::Basename;

my $csv = Text::CSV->new({sep_char => ','});
#my $out = Text::CSV->new({sep_char => ','});
my $infile = $ARGV[0] or die "Error: need an input file. Use \"-\" for stdin\n";

# hard-coded columns for now, but I need to find a robust arguments system to take care of this and other parameters
my @cols = (3,4,21);
#my @out;
my $linenum = 0;

my $if; # in file handle
my $ext=((fileparse("$infile",qr/\.[^.]*/))[2]);
switch($ext)
{
	case ".gz" { open($if, "gunzip -c $infile |") or die "Can't open pipe to $infile: $!"; }
	case ".bz2" { open($if, "bunzip2 -c $infile |") or die "Can't open pipe to $infile: $!"; }
	else
	{
		if(defined($infile)&&($infile ne "-")) { open($if, "<:encoding(utf8)", "$infile") or die "Can't open $infile: $!"; }
		else
		{
			$if = *STDIN;
		}
	}
}

my $outfile = $ARGV[1] or undef; # what is the keyword for "null" in perl?
my $of; # out filehandle
$ext=((fileparse("$outfile",qr/\.[^.]*/))[2]) if defined($outfile) or undef;
switch($ext)
{
	case ".gz" { open($of, "|gzip -c > $outfile") or die "Can't open pipe to $outfile: $!"; }
	case ".bz2" { open($of, "|bzip2 -c > $outfile") or die "Can't open pipe to $outfile: $!"; }
	else
	{
		if(defined($outfile)&&($outfile ne "-")) { open($of, ">","$outfile") or die "Can't open $outfile: $!"; }
		else
		{
			$of = *STDOUT;
		}
	}
}

while (defined(my $line = <$if>))
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
			#push @out,$csv->string();
			#$csv->print($of,@tmp);
			print $of $csv->string()."\n";
		}
		 
	} else
	{
		warn "Line could not be parsed: $line\n";
	}
}

#$csv->eof or $csv->error_diag();
close $if;

#print "@out\n";
#$csv->print ($of,$_) for @out;
#$csv->print($of,$out);
if(defined($outfile)) { close $of or die "$outfile: $!"; }
