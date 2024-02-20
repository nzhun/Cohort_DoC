#!/usr/bin/perl;
use strict;
use warnings;


sub region_gather{
	my $region=$_[0];
	my @files=@{$_[1]};
		#my %map=();
		my $count=0;
		my @percents=(1,10,15,20,25,30,50);
		my %percent_map=();
		foreach  my $file ( @files) {
			#print $file."\t".$region."\n";
			open my $IN," tabix $file $region|" or die "cannot find $file\n";
			while(my $line=<$IN>){
				chomp($line);
				my @sets=split(/\t+/,$line);
				if($sets[3]==0){next;}
				for(my $i=$sets[1];$i<$sets[2];$i++){
#					my @arr=();
#					if(exists($map{$i})){
#						push(@arr,@{$map{$i}});
#						if(@arr<$count) {push(@arr, (0) x ($count-@arr));}
#					}else{
#						if($count >0){	push(@arr,(0) x $count);}
#					}
#					push(@arr,$sets[3]);
#					$map{$i}=\@arr;
					my @brr=(0) x scalar(@percents);
					if(exists($percent_map{$i})){@brr=@{$percent_map{$i}};}
					for(my $k=0;$k<@percents;$k++){
						if($sets[3] >= $percents[$k]){
							$brr[$k]=$brr[$k]+1;
						}
					}
					$percent_map{$i}=\@brr;
				}
			}
			close $IN;
			$count=$count+1;
		#	print $count."\t".join(":",@{$map{"10414790"}})."\t".join(":",@{$map{"5036468"}})."\t".join("-",@{$percent_map{"5036468"}})."\n";
		}
	#	print \%map."\t".\%percent_map."\n";
		return(\%percent_map);
}

sub main{
	my ($myfilelist,$fbed,$outfolder)=@_;
	my @files=();
	my @names=();
	my @percents=(1,10,15,20,25,30,50);
	print $myfilelist."\n";
	open my $IFIL,$myfilelist or die "cannot find $myfilelist\n";
	while(my $fline=<$IFIL>){
		chomp($fline);
		push(@files,$fline);
		my @asets=split(/\//,$fline);
		my @bsets=split(/\./,$asets[@asets-1]);
		push(@names,$bsets[0]);
	}
	close $IFIL;
	my @nsets=split(/\//,$fbed);
	my $prefix=$nsets[@nsets-1];
	print "perbase.$prefix.txt\n";
	print "perbase_percentage.$prefix.txt";
#	open my $OUT, " > perbase.$prefix.txt";
	open my $OUT2, " > $outfolder/perbase_percentage.$prefix.txt";
	print $OUT2 "#Chr\tposition\tTotal\t".join("\t",@percents)."\n";
#	print $OUT "#Chr\tposition\t".join("\t",@names)."\n";
	
	open my $RIN, $fbed or die "cannot find $fbed\n";
	while(my $rline=<$RIN>){
		chomp($rline);
		my @rsets=split(/\t+/,$rline);
		my $start=$rsets[1]-10;
		my $end=$rsets[2]+10;
		my $region=$rsets[0].":".$start."-".$end;
		my ($amap2)=region_gather($region,\@files);
		#my %map=%{$amap1};
		my %percent_map=%{$amap2};
		#print scalar(keys %map)."\n";
		#print scalar(keys %percent_map)."\n";
	#	foreach my $key(keys %map){
	#		if($key <$start || $key > $end){next;}
	#		my @drr=@{$map{$key}};
	#		if(@drr<@files){
	#		 	push(@drr,(0) x (@files-@drr));
	#		}
	#		print $OUT $rsets[0]."\t".$key."\t".join("\t",@drr)."\n";

	#	}

		foreach my $key(keys %percent_map){
			if($key <$start || $key > $end){next;}
			my @crr=@{$percent_map{$key}};
			for(my $c=0;$c<@crr;$c++){
				$crr[$c]=$crr[$c]/@files;
			}
			print $OUT2  $rsets[0]."\t".$key."\t".@files."\t".join("\t",@crr)."\n";

			}

			
	}
		close $RIN;
		close $OUT2;
#		close $OUT;
}
my ($filelist,$fbed,$FDO)=@ARGV;
main($filelist,$fbed,$FDO);

