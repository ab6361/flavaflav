use List::Util qw[min max];
#R_EMC=Num/Denom
#Num=(1-alpha_p*x)+N/Z*R_np*(1-alpha_n*x)
#Denom=1+N/Z*R_np

#1 - fraction at large k
#2 - fraction at small distance
$file="/home/fomin/xgt1/flavaflav2020/dists/summary_file.dat";

open(IN, $file) or die "couldn't open $file for reading\n";
while(<IN>)
{
    $line=$_;
    chomp($line);
    $line=~s/^ +//;
#    print "Read in $line\n";
    if($line=~/^\#/)
    {
	print "I'm a comment: ${line}\n";
    }
    else
    {
	
	@elements=split(/ +/,$line,25);
	if ($elements[1]>0 && $elements[20])
	{
	    $a=$elements[22]+$elements[21];
	    $z=$elements[21];
	    print "Saving a $a and z $z and name $elements[0]\n";
	    $name=$elements[0];
	    $FRAK{$a}{$z}{$name}{"pfrac"}=$elements[4]/$elements[1];
	    $FRAK{$a}{$z}{$name}{"nfrac"}=$elements[6]/$elements[2];
	    $FRAK{$a}{$z}{$name}{"code"}=$elements[20];

	    if ($elements[16]>0)
	    {
		$FRAK{$a}{$z}{$name}{"pp_close"}=$elements[18]/$elements[16];
		$FRAK{$a}{$z}{$name}{"np_close"}=$elements[19]/$elements[17];
		$FRAK{$a}{$z}{$name}{"nn_close"}=$elements[24]/$elements[23];
	    }
	    else
	    {
		print "WTF is this zero, a is $a, z is $z, label is $elements[0]\n";
		$FRAK{$a}{$z}{$name}{"pp_close"}=-1.0;
		$FRAK{$a}{$z}{$name}{"np_close"}=-1.0;
		$FRAK{$a}{$z}{$name}{"nn_close"}=-1.0;
		
	    }
	}
	else
	{
	    print "I'm not being taken ${line}\n";
	}
    }
       
}
close(IN);


#############################################################
#read ryan's file
#############################################################

$file2="/home/fomin/xgt1/flavaflav2020/plots/ryan_summary_file.dat";

open(IN, $file2) or die "couldn't open $file2 for reading\n";
while(<IN>)
{
    $line=$_;
    chomp($line);
    $line=~s/^ +//;
#    print "Read in $line\n";
    if($line=~/^\#/)
    {
	print "I'm a comment: ${line}\n";
    }
    else
    {
	
	@ryan_elements=split(/ +/,$line,34);
	if ($ryan_elements[1]>0 && $ryan_elements[20])
	{
	    $a=$ryan_elements[32]+$ryan_elements[33];
	    $z=$ryan_elements[32];
	    $name=$ryan_elements[0];
	    print "Saving Private Ryan a $a and z $z and name $name\n";

	    $FRAK{$a}{$z}{$name}{"p_dens"}=$ryan_elements[15];
	    $FRAK{$a}{$z}{$name}{"n_dens"}=$ryan_elements[19];
	    #	    $FRAK{$a}{$z}{$name}{"name"}=$ryan_elements[0];
	    #	    $FRAK{$a}{$z}{$name}{"code"}=$ryan_elements[20];
	    
	    if ($ryan_elements[7]>0)
	    {
		$FRAK{$a}{$z}{$name}{"ke_pfrac"}=$ryan_elements[7]/$z;
		$FRAK{$a}{$z}{$name}{"ke_nfrac"}=$ryan_elements[8]/($a-$z);
	    }
	    else
	    {
		print "WTF KE is this zero, a is $a, z is $z, label is $ryan_elements[0]\n";
		$FRAK{$a}{$z}{$name}{"ke_pfrac"}=-1.0;
		$FRAK{$a}{$z}{$name}{"ke_nfrac"}=-1.0;
		
		
	    }
	}
	else
	{
	    print "I'm not being taken for Ryan ${line}\n";
	}
    }
       
}
close(IN);

##########################################################################################################
for ($ii=0; $ii<20; $ii++)
{
    $xx=0.05+.05*$ii;
    print "doing x of $xx for step $ii\n";
    push @x_list, $xx;
}

open(OUT, ">building_a_mystery.dat");
foreach $anum (sort keys %FRAK)
{
    foreach $znum (sort keys %{$FRAK{$anum}})
    {
	$nnum=$anum-$znum;
	foreach $name (sort keys %{$FRAK{$anum}{$znum}})
	{
	    $pfrac=$FRAK{$anum}{$znum}{$name}{"pfrac"};
	    $nfrac=$FRAK{$anum}{$znum}{$name}{"nfrac"};
	    $code=$FRAK{$anum}{$znum}{$name}{"code"};
	    
	    
	    open(SPEC, ">fakeEMC_A${anum}_Z${znum}_${name}.dat");
	    
	    $pp_close=$FRAK{$anum}{$znum}{$name}{"pp_close"};
	    $nn_close=$FRAK{$anum}{$znum}{$name}{"nn_close"};
	    $np_close=$FRAK{$anum}{$znum}{$name}{"np_close"};
	    
	    $p_dens=$FRAK{$anum}{$znum}{$name}{"p_dens"};
	    $n_dens=$FRAK{$anum}{$znum}{$name}{"n_dens"};
	    
	    $ke_pfrac=$FRAK{$anum}{$znum}{$name}{"ke_pfrac"}/1e4;
	    $ke_nfrac=$FRAK{$anum}{$znum}{$name}{"ke_nfrac"}/1e4;
	    if ($anum==2)
	    {
		print "I'm deuterium!\n";
		$pfrac_close=($np_close)/10.0;
		$nfrac_close=($np_close)/10.0;
	    }
	    elsif($anum==3)
	    {
		print "I'm an A=3 nucleus\n";
		if ($znum==1)
		{
		    $pfrac_close=($np_close*$nnum)/10.0;
		    $nfrac_close=($np_close*$znum+$pp_close*($nnum-1))/10.0;   #nn is stored in pp
		    print "Elements are np $np_close, nn is $pp_close\n";
		}
		elsif ($znum==2)
		{
		    $pfrac_close=($np_close+$pp_close)/10.0;
		    $nfrac_close=($np_close*$znum)/10.0;   #nn is zero, becuase there's only one n
		}
		else
		{
		    print "Should NOT be here, Z of $znum, for A=3\n";
		}
		
	    }
	    else
	    {
		print "I'm an A gt 3 nucleus $anum\n";
		$pfrac_close=($np_close*$nnum+$pp_close*($znum-1))/10.0;
		$nfrac_close=($np_close*$znum+$nn_close*($nnum-1))/10.0;
	    }
	    foreach $xx (sort @x_list)
	    {
		$xi=&get_xi($xx, 12.0);
		$xi=int($xi*1000)/1000;
		$rnp=int(&get_R_np($xi)*1000)/1000;
		$f2pf2d=1.0/((1+$rnp));
		#R_EMC=Num/Denom
		#Num=(1-alpha_p*x)+N/Z*R_np*(1-alpha_n*x)
		#Denom=1+N/Z*R_np
		$num=1.0-$pfrac*$xx+($anum-$znum)/$znum*$rnp*(1-$nfrac*$xx);
		$denom=1.0+($anum-$znum)/$znum*$rnp;
		$emc_high_mom=$num/$denom;
		
		
		#for distance, divide pfrac by 100 
		if ($pp_close>0)
		{
		    print "For distance, pfrac is $pfrac_close, nfrac is $nfrac_close, $pp_close, $np_close\n";
		    
		    $num=1.0-$pfrac_close*$xx+($anum-$znum)/$znum*$rnp*(1-$nfrac_close*$xx);
		    $denom=1.0+($anum-$znum)/$znum*$rnp;
		    $emc_close=$num/$denom;
		}
		else
		{
		    $emc_close=-1.0;
		}
		
		#density bit
		if ($p_dens>0)
		{
		    $num=1.0-$p_dens*$xx+($anum-$znum)/$znum*$rnp*(1-$n_dens*$xx);
		    $denom=1.0+($anum-$znum)/$znum*$rnp;
		    $emc_dens=$num/$denom;
		}
		else
		{
		    $emc_dens=-1.0;
		}
		
		#ke_bit
		if ($ke_pfrac>0)
		{
		    $num=1.0-$ke_pfrac*$xx+($anum-$znum)/$znum*$rnp*(1-$ke_nfrac*$xx);
		    $denom=1.0+($anum-$znum)/$znum*$rnp;
		    $emc_ke=$num/$denom;
		}
		else
		{
		    $emc_ke=-1.0;
		}
		
	    
		#	    print SPEC "$xx $xi $rnp $emc_high_mom $emc_close $pfrac $nfrac\n";
		printf SPEC ("%6.3f ", $xx);
		printf SPEC ("%6.3f ", $xi);
		printf SPEC ("%6.3f ", $rnp);
		printf SPEC ("%6.4f ", $emc_high_mom);
		printf SPEC ("%6.4f ", $emc_close);
		printf SPEC ("%6.3f ", $pfrac);
		printf SPEC ("%6.3f ", $nfrac);
		printf SPEC ("%6.3f ", $pfrac_close);
		printf SPEC ("%6.3f ", $nfrac_close);
		
		printf SPEC ("%6.3f ", $p_dens);
		printf SPEC ("%6.3f ", $n_dens);
		printf SPEC ("%6.3f ", $emc_dens);
		
		printf SPEC ("%6.4f ", $ke_pfrac);
		printf SPEC ("%6.4f ", $ke_nfrac);
		printf SPEC ("%6.4f ", $emc_ke);
		print SPEC "\n";
		
	    
		#
	    }
	
	    close(SPEC);
	}
	printf OUT ("%4i  ", $anum);
	printf OUT ("%4i  ", $znum);
	printf OUT ("%4i  ", $nnum);
	printf OUT ("%8.3f  ", $pfrac);
	printf OUT ("%8.3f  ", $nfrac);
	printf OUT ("%3i ", $code);
	printf OUT ("%8s  ", $name);
	printf OUT "\n";
	
    }
}


close(OUT);


sub get_R_np
{
  my($jj)=@_;

  $p1=0.816;
  $p2=-0.661;
  $p3=0.184;
  $p4=5.509;
  $p5=-0.034;
  $p6=8.714;
  $p7=-0.072;
  $p8=0.450;

  $r_np_here= ($p1+$p2*$jj)+$p3*exp(-$p4*$jj)+$p5*exp(-$p6*(1.0-$jj))+$p7*(max(0,$jj-$p8))**2;
  return $r_np_here;
}

sub get_xi
{
  my($x,$q2)=@_;
  $mm=0.93827;
  $xi=2*$x/(1.+sqrt(1.+4*$mm**2*$x**2/$q2));
  return $xi;
}
