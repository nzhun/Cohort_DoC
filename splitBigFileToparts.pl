use warnings;
use strict;
my $file=$ARGV[0];
my $fd=$ARGV[1];
my $chunk=$ARGV[2];
my @info=split("\/",$file);
my $suff=$info[@info-1];
print $suff."\n";
my $chr="";
my $cmd="cat";
if($cmd =~ /.gz/){$cmd="z$cmd";}
open IN,"$cmd $file|";
my $j=0;
while(my $l=<IN>){
  
  if($j % $chunk ==0){
  	if($j!=0){
    		close OUT ;
    	  }
	open OUT,">"."$fd/$suff".".".$j.".bed";
  }
	print OUT $l;
    	$j=$j+1;
  
}
close OUT;
close IN;
