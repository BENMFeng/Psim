=pod

=head1 PowerLaw
Used to generate random number(s) under power law distribution

parameter:
	number of digit
	parameter a
	power b
	high limit
default:
	a=0.35
	b=-2

example:
	&PowerLaw(10000,0.35,-2,72)

=cut

package PowerLaw;
use Exporter;
use warnings;
use strict;

our @ISA=qw(Exporter);
our @EXPORT=qw(PowerLaw);
our $VERSION=1.0;

sub PowerLaw
{
	my ($num,$a,$b,$lim)=@_;
	die "wrong parameter b\n" if($b  && ($b>0));
	die "wrong parameter a\n" if($a  && $a>1);
	$a||=0.35;
	$b||=-2;
	$lim||=int(sqrt($a*10000));
	my @train;
	for(my $n=$lim;$n>0;$n--)
	{
		my $freq=int(10000*$a*$n**$b+0.5);
		$freq=1 if($freq < 1);
		for(1..$freq)
		{
			push @train,$n;
		}
	}
	my $tra=scalar(@train);
	my @return;
	if($num=~/r/)
	{
		$num=~s/[^0-9.]//g;
		my $cal=0;
		while($cal<$num)
		{
			my $i=int(rand($tra));
			my $this=$train[$i];
			push @return,$this;
			$cal+=$this;
		}
		my $over=pop @return;
		$cal-=$over;
		push @return,($num-$cal);
	}
	else
	{
		$num=~s/[^0-9.]//g;
		for(1..$num)
		{
			my $i=int(rand($tra));
			my $this=$train[$i];
			push @return,$this;
		}
	}
	return @return;
}
