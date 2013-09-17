=pod

=head1 PieceGenerate
Used to shear the reference genome randomly
parameter:
	whole genome length
	type of library
		0 for others
		$Insert\:length($Linker) for Roche 454 PE
	data coverage
	lamada of distribution
	sd of distribution
	length limit(optional)
	dupl	duplication percent[necessary] and duplication times limit[optional]
	duplpara	duplication parameter(a-b)

example:
	&PieceGenerate($referencelength,$type,$coverage,$fragmean,$fragsd,$limit)

=cut

package PieceGenerate;
use Exporter;
use warnings;
use strict;
use normal;
use PowerLaw;

our @ISA=qw(Exporter);
our @EXPORT=qw(PieceGenerate);
our $VERSION=1.3;

sub PieceGenerate
{
	my %hash=@_;
#%hash keys: 
#	WL->length($sequence)
#	type->$ltype
#	circle->$circle
#	Coverage->$Coverage
#	readmean->$readmean
#	fragmean->$fragmentmean
#	fragsd->fragmentsd
#	fraglim->fragmentlimit
#	duplp->DuplicationPercent
#	dupll->DuplicationTimesLimit
#	dupla->parametera
#	duplb->parameterb

#	my ($WL,$type,$circle,$Coverage,$readmean,$Lamada,$sd,$limit)=@_;
	my @StartLeng;
	my $lengthlimit=$hash{WL}*$hash{Coverage};
	my $num;
	if($hash{duplp})
	{
		$num=int((1-$hash{duplp})*$hash{WL}*$hash{Coverage}/$hash{readmean}+0.5);
	}
	else
	{
	 	$num=int(($hash{WL}*$hash{Coverage}/$hash{readmean})+0.5);
	}
#	print "TEST num is $num\n";
	my @length=&normal($num,$hash{fragmean},$hash{fragsd},$hash{fraglim});
	if($hash{type} eq 0) #other library types
	{
		$hash{WL}=$hash{WL}-int($hash{fragmean}*1.5) if($hash{circle} eq 0);
		foreach my $l(@length)
		{
			my $StartPoint=int(rand($hash{WL}));
			push @StartLeng,"$StartPoint\_$l";
		}
	}
	else #Roche 454 PE library
	{
		my ($InsertMean,$InsertSD,$LinkerLeng)=split /\:/,$hash{type};
		my @insertleng=&normal($num,$InsertMean,$InsertSD);
		$hash{WL}=$hash{WL}-int($InsertMean*1.5) if($hash{circle} eq 0);
		for my $i(0..$#length)
		{
			#length[$i]=fragment length
			#insertleng[$i]=insert size
			my $InsertSite=int(rand($hash{WL}));
			my $InsertEnd=$insertleng[$i]+$InsertSite-1;
			my $low=$insertleng[$i]+$InsertSite-$length[$i];
			my $StartPoint=int(rand($length[$i]+$LinkerLeng))+$low;
			if($StartPoint<($low+$LinkerLeng))
			{
				#reutrn 3, fragment start site, end site and whole fragment size. gap fill with linker sequence
				push @StartLeng,"3\_$StartPoint\_$InsertEnd\_$length[$i]";
			}
			elsif($StartPoint<=$InsertEnd)
			{
				#return 0,fragment start site, insert end site, insert start site and fragment size
				push @StartLeng,"0\_$StartPoint\_$InsertEnd\_$InsertSite\_$length[$i]";
			}
			else
			{
				#reutrn 5, insert start site, end site and whole fragment size. gap fill with linker sequence
				my $end=$InsertSite+$length[$i]+$StartPoint-$LinkerLeng-$InsertEnd-1;
				push @StartLeng,"5\_$InsertSite\_$end\_$length[$i]";
			}
		}
	}
	if($hash{duplp})
	{
		my $duplfrag=int($hash{duplp}/(1-$hash{duplp})*$num+0.5);
#	print "TEST duplfrag is $duplfrag\n";
		$hash{dupla}||=0.35;
		$hash{duplb}||=-2;
		my @dupltimes=&PowerLaw("r".$duplfrag,$hash{dupla},$hash{duplb},$hash{dupll});
#my $count=0;
#foreach(@dupltimes)
#{
#	$count+=$_;
#}
#print "whole duplication times $count\n";

		foreach my $dt(@dupltimes)
		{
			my $j=int(rand($num));
			for(1..$dt)
			{
				push @StartLeng,$StartLeng[$j];
			}
		}
	}
	return @StartLeng;
}
1;
