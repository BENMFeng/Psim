=pod
=head READGFF
read gff file and get exon/cdna region and gene info for Tag-Seq and RNA-Seq

Example
	&READGFF($GFF,\%DigestRegion)

=cut

package ReadGff;
require Exporter;
use warnings;
use strict;

our @ISA=qw(Exporter);
our @EXPORT=qw(ReadGff);
our $VERSION=1.0;

sub ReadGff
{
	my ($File,$Hash)=@_;
	open (IN,"<$File") || die "Can't open $File!\n";
	my $Exon="";
	my ($Chr,$Symbol,$Start,$End,$Strand,$Id);
	while(<IN>)
	{
		next if(/^\#/);
		chomp;
		my @t=split /\t/;
		if($t[2]=~/transcript/)
		{
			if($Exon ne "")
			{
				$$Hash{$Chr}{$Id}=$Exon;
			}
			($Chr,$Symbol,$Start,$End,$Strand)=@t[0,2,3,4,6];
			$Exon="$Strand\:$Start\,$End";
#transcript_id "ENST00000456328.2"
			$Id=$1 if($t[8]=~/transcript\ \"(.*)\"/);
#			print "TEST\tid is $Id\n";
		}
		elsif($t[2]=~/exon/)
		{
			$Exon.="\;$t[3]\,$t[4]";
		}
	}
	$$Hash{$Chr}{$Id}=$Exon;
}
1;
