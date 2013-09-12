=pod
=head PCRduplication

used to generate PCR duplication sequences
amplification efficiency in poisson distribution

input
	\@Fragment
	mean amplification times
output
	@Library

example
	&PCRduplication(\@Fragment,\@Library,$AmpMean)
=cut

package PCRduplication;
use Exporter;
use warnings;
use strict;
#use Math::Random qw(random_poisson);
use normal;

our @ISA=qw(Exporter);
our @EXPORT=qw(PCRduplication);
our $VERSION=1.0;

sub PCRduplication
{
	my ($Fragment,$Library,$name,$libraryname,$AmpMean,$AmpSD)=@_;
	my $NumFragment=scalar(@$Fragment);
#	my @AmpNum=random_poisson($NumFragment,$AmpMean);
	my @AmpNum=normal($NumFragment,$AmpMean,$AmpSD);
	for my $i(0..($NumFragment-1))
	{
		for(1..$AmpNum[$i])
		{
			push @$Library,$$Fragment[$i];
			push @$libraryname,$$name[$i];
		}
	}
}
1;
		
