$dens1_dir="density/full_dens_1d/";
$dens2_dir="density/full_dens_2d/";
$mom_dir="mom/full_dist/";
 
&momentum_dist_stuff;
&dens_dist_stuff_1body;
&dens_dist_stuff_2body;

&make_file;
$count=0;

sub momentum_dist_stuff
{
    ###  DO MOMENTUM DISTRIBUTION STUFF HERE 
    #  $cmd2="awk \'\$1\=\=$targ \&\& \$2\=\=18 {print \$3,\$4}\' ${file} |";

    $cmd="ls ".$mom_dir."\*\.momentum | ";
    print "$cmd is $cmd\n";
    open(PP,$cmd);
    @files=<PP>;
    print @files;
    close(PP);
    
    #let's do this with awk first, might be easiest
    foreach $file (@files)
    {
#	if ($count > 5){die;}
	print "File is $file\n";
	my($junk,$nucleus)=split(/full\_dist\//, $file, 2);
	$nucleus=~s/\.momentum//g;
	chomp($nucleus);
	print "Nucleus is $nucleus\n";

	if ($nucleus=~/h2/)
	{
	    print "This is deuterium, $nucleus\n";
	}
	else
	{
	    $cmd="awk \'NR\=\=45\{print NF}\' ".$dens1_dir."commented\/${nucleus}\.density\.com |";
	    open(PP,$cmd);
	    $thing=<PP>;
	    close(PP);
	    chomp($thing);
	    print "For momentum for $nucleus, there are $thing columns\n";
	    $ncols=$thing;
	    if ($ncols<5)
	    {
		#########  PROTON NORMALIZATION
		############ protons only
		
		$cmd="awk \'BEGIN\{pi\=3.141592458\} \$0\!\~\/\^\\\#\/\{sum\+\=4\*pi\*\$1\*\*2\*\(\$2\)\*0.1\/\(2\*pi\)\*\*3\}END\{print sum\}\' ".$mom_dir."commented\/${nucleus}\.momentum\.com |";
		print "cmd is $cmd\n";
		open(PP,$cmd);
		$thing=<PP>;
		close(PP);
		chomp($thing);
		$DATA{$nucleus}{"mom_norm_p"}=$thing;  #save it
		$DATA{$nucleus}{"mom_norm_n"}=$thing;  #save it
		print "For $nucleus, normalization is $thing\n";
		
		
		############### HIGH MOMENTUM PROTONS
		########### Number at high momentum, >=2 fm (normalize to above)
		#awk 'BEGIN{pi=3.141592458} $0!~/^\#/ && $1>=2{sum+=4*pi*$1**2*($3+$2)*0.1/(2*pi)**3}END{print "Number at >2 fm", sum}' h2.momentum.com.txt
		
		$cmd="awk \'BEGIN\{pi\=3.141592458\} \$0\!\~\/\^\\\#\/\&\& \$1\>\=2 \{sum\+\=4\*pi\*\$1\*\*2\*\(\$2\)\*0.1\/\(2\*pi\)\*\*3\}END\{print sum\}\' ".$mom_dir."commented\/${nucleus}\.momentum\.com |";
		print "cmd is $cmd\n";
		open(PP,$cmd);
		$thing=<PP>;
		close(PP);
		chomp($thing);
		$DATA{$nucleus}{"highmom2_p"}=$thing;  #save it
		$DATA{$nucleus}{"highmom2_n"}=$thing;  #save it
		$temp=$thing/$DATA{$nucleus}{"mom_norm_p"};
		print "For $nucleus, fraction at high mom is $thing, $temp\n";
		
	    ########### Number at high momentum, >=1.5 fm (normalize to above)
		$cmd="awk \'BEGIN\{pi\=3.141592458\} \$0\!\~\/\^\\\#\/\&\& \$1\>\=1.5 \{sum\+\=4\*pi\*\$1\*\*2\*\(\$2\)\*0.1\/\(2\*pi\)\*\*3\}END\{print sum\}\' ".$mom_dir."commented\/${nucleus}\.momentum\.com |";
		print "cmd is $cmd\n";
		open(PP,$cmd);
		$thing=<PP>;
		close(PP);
		chomp($thing);
		$DATA{$nucleus}{"highmom1_p"}=$thing;  #save it
		$DATA{$nucleus}{"highmom1_n"}=$thing;  #save it
		$temp=$thing/$DATA{$nucleus}{"mom_norm_p"};
		print "For $nucleus, fraction at high mom is $thing, $temp\n";
		
		
		################### KINETIC ENERGY -total
		$cmd="awk \'BEGIN\{pi\=3.141592458\} \$0\!\~\/\^\\\#\/{sum\+\=4\*pi\*\$1\*\*4\*\(\$2\)\*0.1\/\(2\*pi\)\*\*3\}END\{fact\=\(0.197\*1.6e\-10\/3e8\)\*\*2\/2\/1.67e\-27;  print sum\*fact\/1.6e\-10\*1000\}\' ".$mom_dir."commented\/${nucleus}\.momentum\.com |";
	    
		print "KE cmd is $cmd\n";
		open(PP,$cmd);
		$thing=<PP>;
		close(PP);
		chomp($thing);
		$DATA{$nucleus}{"KE_p"}=$thing;  #save it
		$DATA{$nucleus}{"KE_n"}=$thing;  #save it
		$temp=$thing/$DATA{$nucleus}{"mom_norm_p"};
		print "For $nucleus, KE $thing, $temp\n";
		
		################### KINETIC ENERGY at >2fm
		$cmd="awk \'BEGIN\{pi\=3.141592458\} \$0\!\~\/\^\\\#\/ \&\& \$1\>\=2 \{sum\+\=4\*pi\*\$1\*\*4\*\(\$2\)\*0.1\/\(2\*pi\)\*\*3\}END\{fact\=\(0.197\*1.6e\-10\/3e8\)\*\*2\/2\/1.67e\-27;  print sum\*fact\/1.6e\-10\*1000\}\' ".$mom_dir."commented\/${nucleus}\.momentum\.com |";
		
		print "cmd is $cmd\n";
		open(PP,$cmd);
		$thing=<PP>;
		close(PP);
		chomp($thing);
		$DATA{$nucleus}{"KE_highmom2_p"}=$thing;  #save it
		$DATA{$nucleus}{"KE_highmom2_n"}=$thing;  #save it
		$temp=$thing/$DATA{$nucleus}{"mom_norm_p"};
		print "For $nucleus, KE above 2 fm $thing, $temp\n";
		
		################### KINETIC ENERGY at > 1.5 fm
		$cmd="awk \'BEGIN\{pi\=3.141592458\} \$0\!\~\/\^\\\#\/ \&\& \$1\>\=1.5 \{sum\+\=4\*pi\*\$1\*\*4\*\(\$2\)\*0.1\/\(2\*pi\)\*\*3\}END\{fact\=\(0.197\*1.6e\-10\/3e8\)\*\*2\/2\/1.67e\-27;  print sum\*fact\/1.6e\-10\*1000\}\' ".$mom_dir."commented\/${nucleus}\.momentum\.com |";
		
		print "cmd is $cmd\n";
		open(PP,$cmd);
		$thing=<PP>;
		close(PP);
		chomp($thing);
		$DATA{$nucleus}{"KE_highmom1_p"}=$thing;  #save it
		$DATA{$nucleus}{"KE_highmom1_n"}=$thing;  #save it
		$temp=$thing/$DATA{$nucleus}{"mom_norm_p"};
		print "For $nucleus, KE above 1.5 fm $thing, $temp\n";
	    }
	    else
	    {
		##### do proton sAND neutrons 
		#########  
		
		$cmd="awk \'BEGIN\{pi\=3.141592458\} \$0\!\~\/\^\\\#\/\{sum\+\=4\*pi\*\$1\*\*2\*\(\$2\)\*0.1\/\(2\*pi\)\*\*3\}END\{print sum\}\' ".$mom_dir."commented\/${nucleus}\.momentum\.com |";
		print "cmd is $cmd\n";
		open(PP,$cmd);
		$thing=<PP>;
		close(PP);
		chomp($thing);
		$DATA{$nucleus}{"mom_norm_n"}=$thing;  #save it
		
		
		$cmd="awk \'BEGIN\{pi\=3.141592458\} \$0\!\~\/\^\\\#\/\{sum\+\=4\*pi\*\$1\*\*2\*\(\$4\)\*0.1\/\(2\*pi\)\*\*3\}END\{print sum\}\' ".$mom_dir."commented\/${nucleus}\.momentum\.com |";
		print "cmd is $cmd\n";
		open(PP,$cmd);
		$thing=<PP>;
		close(PP);
		chomp($thing);
		$DATA{$nucleus}{"mom_norm_p"}=$thing;  #save it
		print "For $nucleus, normalization is $thing\n";
	    
	
		############### HIGH MOMENTUM PROTONS AND NEUTRONS
		########### Number at high momentum, >=2 fm (normalize to above)
		#awk 'BEGIN{pi=3.141592458} $0!~/^\#/ && $1>=2{sum+=4*pi*$1**2*($3+$2)*0.1/(2*pi)**3}END{print "Number at >2 fm", sum}' h2.momentum.com.txt
		
		$cmd="awk \'BEGIN\{pi\=3.141592458\} \$0\!\~\/\^\\\#\/\&\& \$1\>\=2 \{sum\+\=4\*pi\*\$1\*\*2\*\(\$2\)\*0.1\/\(2\*pi\)\*\*3\}END\{print sum\}\' ".$mom_dir."commented\/${nucleus}\.momentum\.com |";
		print "cmd is $cmd\n";
		open(PP,$cmd);
		$thing=<PP>;
		close(PP);
		chomp($thing);
		$DATA{$nucleus}{"highmom2_n"}=$thing;  #save it
		
		
		
		
		$cmd="awk \'BEGIN\{pi\=3.141592458\} \$0\!\~\/\^\\\#\/\&\& \$1\>\=2 \{sum\+\=4\*pi\*\$1\*\*2\*\(\$4\)\*0.1\/\(2\*pi\)\*\*3\}END\{print sum\}\' ".$mom_dir."commented\/${nucleus}\.momentum\.com |";
		print "cmd is $cmd\n";
		open(PP,$cmd);
		$thing=<PP>;
		close(PP);
		chomp($thing);
		$DATA{$nucleus}{"highmom2_p"}=$thing;  #save it
		$temp=$thing/$DATA{$nucleus}{"mom_norm_p"};
		print "For $nucleus, fraction at high mom is $thing, $temp\n";
		
		########### Number at high momentum, >=1.5 fm (normalize to above)
		$cmd="awk \'BEGIN\{pi\=3.141592458\} \$0\!\~\/\^\\\#\/\&\& \$1\>\=1.5 \{sum\+\=4\*pi\*\$1\*\*2\*\(\$2\)\*0.1\/\(2\*pi\)\*\*3\}END\{print sum\}\' ".$mom_dir."commented\/${nucleus}\.momentum\.com |";
		print "cmd is $cmd\n";
		open(PP,$cmd);
		$thing=<PP>;
		close(PP);
		chomp($thing);
		$DATA{$nucleus}{"highmom1_n"}=$thing;  #save it
		
		
		
		
		$cmd="awk \'BEGIN\{pi\=3.141592458\} \$0\!\~\/\^\\\#\/\&\& \$1\>\=1.5 \{sum\+\=4\*pi\*\$1\*\*2\*\(\$4\)\*0.1\/\(2\*pi\)\*\*3\}END\{print sum\}\' ".$mom_dir."commented\/${nucleus}\.momentum\.com |";
		print "cmd is $cmd\n";
		open(PP,$cmd);
		$thing=<PP>;
		close(PP);
		chomp($thing);
		$DATA{$nucleus}{"highmom1_p"}=$thing;  #save it
		$temp=$thing/$DATA{$nucleus}{"mom_norm_p"};
		print "For $nucleus, fraction at high mom is $thing, $temp\n";
		
		
	    ################### KINETIC ENERGY -total
		$cmd="awk \'BEGIN\{pi\=3.141592458\} \$0\!\~\/\^\\\#\/{sum\+\=4\*pi\*\$1\*\*4\*\(\$2\)\*0.1\/\(2\*pi\)\*\*3\}END\{fact\=\(0.197\*1.6e\-10\/3e8\)\*\*2\/2\/1.67e\-27;  print sum\*fact\/1.6e\-10\*1000\}\' ".$mom_dir."commented\/${nucleus}\.momentum\.com |";
		
		print "cmd is $cmd\n";
		open(PP,$cmd);
		$thing=<PP>;
		close(PP);
		chomp($thing);
		$DATA{$nucleus}{"KE_n"}=$thing;  #save it

		
		
		$cmd="awk \'BEGIN\{pi\=3.141592458\} \$0\!\~\/\^\\\#\/{sum\+\=4\*pi\*\$1\*\*4\*\(\$4\)\*0.1\/\(2\*pi\)\*\*3\}END\{fact\=\(0.197\*1.6e\-10\/3e8\)\*\*2\/2\/1.67e\-27;  print sum\*fact\/1.6e\-10\*1000\}\' ".$mom_dir."commented\/${nucleus}\.momentum\.com |";
		
		print "cmd is $cmd\n";
		open(PP,$cmd);
		$thing=<PP>;
		close(PP);
		chomp($thing);
		$DATA{$nucleus}{"KE_p"}=$thing;  #save it
		$temp=$thing/$DATA{$nucleus}{"mom_norm_p"};
		print "For $nucleus, KE $thing, $temp\n";
		
		################### KINETIC ENERGY at >2fm
		$cmd="awk \'BEGIN\{pi\=3.141592458\} \$0\!\~\/\^\\\#\/ \&\& \$1\>\=2 \{sum\+\=4\*pi\*\$1\*\*4\*\(\$2\)\*0.1\/\(2\*pi\)\*\*3\}END\{fact\=\(0.197\*1.6e\-10\/3e8\)\*\*2\/2\/1.67e\-27;  print sum\*fact\/1.6e\-10\*1000\}\' ".$mom_dir."commented\/${nucleus}\.momentum\.com |";
		
		print "cmd is $cmd\n";
		open(PP,$cmd);
		$thing=<PP>;
		close(PP);
		chomp($thing);
		$DATA{$nucleus}{"KE_highmom2_n"}=$thing;  #save it
		
		
		$cmd="awk \'BEGIN\{pi\=3.141592458\} \$0\!\~\/\^\\\#\/ \&\& \$1\>\=2 \{sum\+\=4\*pi\*\$1\*\*4\*\(\$4\)\*0.1\/\(2\*pi\)\*\*3\}END\{fact\=\(0.197\*1.6e\-10\/3e8\)\*\*2\/2\/1.67e\-27;  print sum\*fact\/1.6e\-10\*1000\}\' ".$mom_dir."commented\/${nucleus}\.momentum\.com |";
		
		print "cmd is $cmd\n";
		open(PP,$cmd);
		$thing=<PP>;
		close(PP);
		chomp($thing);
		$DATA{$nucleus}{"KE_highmom2_p"}=$thing;  #save it
		$temp=$thing/$DATA{$nucleus}{"mom_norm_p"};
		print "For $nucleus, KE above 2 fm $thing, $temp\n";
		
		################### KINETIC ENERGY at > 1.5 fm
		$cmd="awk \'BEGIN\{pi\=3.141592458\} \$0\!\~\/\^\\\#\/ \&\& \$1\>\=1.5 \{sum\+\=4\*pi\*\$1\*\*4\*\(\$2\)\*0.1\/\(2\*pi\)\*\*3\}END\{fact\=\(0.197\*1.6e\-10\/3e8\)\*\*2\/2\/1.67e\-27;  print sum\*fact\/1.6e\-10\*1000\}\' ".$mom_dir."commented\/${nucleus}\.momentum\.com |";
	    
		print "cmd is $cmd\n";
		open(PP,$cmd);
		$thing=<PP>;
		close(PP);
		chomp($thing);
		$DATA{$nucleus}{"KE_highmom1_n"}=$thing;  #save it
		
		
		
		
		$cmd="awk \'BEGIN\{pi\=3.141592458\} \$0\!\~\/\^\\\#\/ \&\& \$1\>\=1.5 \{sum\+\=4\*pi\*\$1\*\*4\*\(\$4\)\*0.1\/\(2\*pi\)\*\*3\}END\{fact\=\(0.197\*1.6e\-10\/3e8\)\*\*2\/2\/1.67e\-27;  print sum\*fact\/1.6e\-10\*1000\}\' ".$mom_dir."commented\/${nucleus}\.momentum\.com |";
	    
		print "cmd is $cmd\n";
		open(PP,$cmd);
		$thing=<PP>;
		close(PP);
		chomp($thing);
		$DATA{$nucleus}{"KE_highmom1_p"}=$thing;  #save it
		$temp=$thing/$DATA{$nucleus}{"mom_norm_p"};
		print "For $nucleus, KE above 1.5 fm $thing, $temp\n";
	    }
	    
	}
	$count++;
    }
}


###############  DO 1-BODY DENSITY STUFF HERE

sub dens_dist_stuff_1body
{
    $cmd="ls ".$dens1_dir."\*\.density | ";
    print "$cmd is $cmd\n";
    open(PP,$cmd);
    @files=<PP>;
    print @files;
    close(PP);
    
    #let's do this with awk first, might be easiest
    foreach $file (@files)
    {
	print "File is $file\n";
	my($junk,$nucleus)=split(/full\_dens\_1d\//, $file, 2);
	$nucleus=~s/\.density//g;
	chomp($nucleus);
	print "Nucleus is $nucleus\n";

	#figure out if file has rho(n) or only rho(p)

	$cmd="awk \'NR\=\=25\{print NF}\' ".$dens1_dir."commented\/${nucleus}\.density\.com |";
	open(PP,$cmd);
	$thing=<PP>;
	close(PP);
	chomp($thing);
	
	$ncols=$thing;

	if($ncols==3 || $ncols==4)
	{	
	    #
	    #####################   Normalization. 
	    #
	    $cmd="awk \'BEGIN\{pi\=3.141592458\} \$0\!\~\/\^\\\#\/ \{sum\+\=4\*pi\*\$1\*\*2\*\(\$2\*2\)*0.1\}END\{print  sum}\' ".$dens1_dir."commented\/${nucleus}\.density\.com |";
	    
	    print "cmd is $cmd\n";
	    open(PP,$cmd);
	    $thing=<PP>;
	    close(PP);
	    chomp($thing);
	    $DATA{$nucleus}{"dens_norm"}=$thing;  #save it
	    
	    print "For $nucleus, density normalization is $thing\n";
	    
	    #He4 1body density norm 1.99765
	    
	    #####################  Average Density. 
	    #
	    $cmd="awk \'BEGIN\{pi\=3.141592458\} \$0\!\~\/\^\\\#\/ \{sum\+\=4\*pi\*\$1\*\*2\*\(\$2\*2\)\*\*2\*0.1\}END\{print  sum}\' ".$dens1_dir."commented\/${nucleus}\.density\.com |";
	    
	    print "cmd is $cmd\n";
	    open(PP,$cmd);
	    $thing=<PP>;
	    close(PP);
	    chomp($thing);
	    $DATA{$nucleus}{"dens"}=$thing;  #save it
	    $temp=$thing/$DATA{$nucleus}{"dens_norm"};
	    print "For $nucleus, average density is $thing\n";
	    
	    #####################  Average radius. 
	    #
	    $cmd="awk \'BEGIN\{pi\=3.141592458\} \$0\!\~\/\^\\\#\/ \{sum\+\=4\*pi\*\$1\*\*4\*\(\$2\*2\)\*0.1\}END\{print  sum}\' ".$dens1_dir."commented\/${nucleus}\.density\.com |";
	    
	    print "cmd is $cmd\n";
	    open(PP,$cmd);
	    $thing=<PP>;
	    close(PP);
	    chomp($thing);
#	    $DATA{$nucleus}{"radius"}=$thing;  #save it
	    $temp=sqrt($thing/$DATA{$nucleus}{"dens_norm"});
	    $DATA{$nucleus}{"radius"}=$temp;  #save it
	    print "For $nucleus, average radius is $thing\n";


	}
	elsif ($ncols==5)
	{
	    #
	    #####################   Normalization. 
	    #
	    $cmd="awk \'BEGIN\{pi\=3.141592458\} \$0\!\~\/\^\\\#\/ \{sum\+\=4\*pi\*\$1\*\*2\*\(\$2\+\$4\)*0.1\}END\{print  sum}\' ".$dens1_dir."commented\/${nucleus}\.density\.com |";
	    
	    print "cmd is $cmd\n";
	    open(PP,$cmd);
	    $thing=<PP>;
	    close(PP);
	    chomp($thing);
	    $DATA{$nucleus}{"dens_norm"}=$thing;  #save it
	    
	    print "For $nucleus, density normalization is $thing\n";
	    
	    #He4 1body density norm 1.99765
	    
	    #####################  Average Density. 
	    #
	    $cmd="awk \'BEGIN\{pi\=3.141592458\} \$0\!\~\/\^\\\#\/ \{sum\+\=4\*pi\*\$1\*\*2\*\(\$2\+\$4\)\*\*2\*0.1\}END\{print  sum}\' ".$dens1_dir."commented\/${nucleus}\.density\.com |";
	    
	    print "cmd is $cmd\n";
	    open(PP,$cmd);
	    $thing=<PP>;
	    close(PP);
	    chomp($thing);
	    $DATA{$nucleus}{"dens"}=$thing;  #save it
	    $temp=$thing/$DATA{$nucleus}{"dens_norm"};
	    print "For $nucleus, average density is $thing\n";
	    #
	    #
	    #####################  Average radius. 
	    #
	    $cmd="awk \'BEGIN\{pi\=3.141592458\} \$0\!\~\/\^\\\#\/ \{sum\+\=4\*pi\*\$1\*\*4\*\(\$2\+\$4\)\*0.1\}END\{print  sum}\' ".$dens1_dir."commented\/${nucleus}\.density\.com |";
	    
	    print "cmd is $cmd\n";
	    open(PP,$cmd);
	    $thing=<PP>;
	    close(PP);
	    chomp($thing);
	    $temp=sqrt($thing/$DATA{$nucleus}{"dens_norm"});
	    $DATA{$nucleus}{"radius"}=$temp;  #save it
	    print "For $nucleus, average radius is $thing\n";

	}
	else
	{
	    print "WTF, awkward number of columns $ncols\n";
	}
	
    }


}



###############  DO 2-BODY DENSITY STUFF HERE

sub dens_dist_stuff_2body
{
    print "DOING 2D density\n";
    $cmd="ls ".$dens2_dir."\*\.density2 | ";
    print "$cmd is $cmd\n";
    open(PP,$cmd);
    @files=<PP>;
  #  print @files;
    close(PP);
    
    #let's do this with awk first, might be easiest
    foreach $file (@files)
    {
	print "File is $file\n";
	my($junk,$nucleus)=split(/full\_dens\_2d\//, $file, 2);
	$nucleus=~s/\.density2//g;
	chomp($nucleus);
	$cmd="awk \'NR\=\=30\{print NF}\' ".$dens2_dir."commented\/${nucleus}\.density2\.com |";
	print "Nucleus is $nucleus, looking at columns $cmd\n";
	open(PP,$cmd);
	$thing=<PP>;
	close(PP);
	chomp($thing);
	
	$ncols=$thing;
	print "There are $ncols columns in file\n";
	if ($ncols<6)
	{
	    
	    #
	    #####################   Normalization for pp
	    #
	    $cmd="awk \'BEGIN\{pi\=3.141592458\} \$0\!\~\/\^\\\#\/ \{sum\+\=4\*pi\*\$1\*\*2\*\(\$2\)*0.1\}END\{print  sum}\' ".$dens2_dir."commented\/${nucleus}\.density2\.com |";
	    
	    print "cmd is $cmd\n";
	    open(PP,$cmd);
	    $thing=<PP>;
	    close(PP);
	    chomp($thing);
	    $DATA{$nucleus}{"dens2_norm_pp"}=$thing;  #save it
	    $DATA{$nucleus}{"dens2_norm_nn"}=$thing;  #save it
	    
	    print "For $nucleus, pp density normalization is $thing\n";
	    
	    #
	    #####################   Normalization for np
	    #
	    $cmd="awk \'BEGIN\{pi\=3.141592458\} \$0\!\~\/\^\\\#\/ \{sum\+\=4\*pi\*\$1\*\*2\*\(\$4\)*0.1\}END\{print  sum}\' ".$dens2_dir."commented\/${nucleus}\.density2\.com |";
	    
	    print "cmd is $cmd\n";
	    open(PP,$cmd);
	    $thing=<PP>;
	    close(PP);
	    chomp($thing);
	    $DATA{$nucleus}{"dens2_norm_np"}=$thing;  #save it
	    
	    print "For $nucleus, np density normalization is $thing\n";
	    
	    
	    
	    #####################  near pp 
	    #
	    $cmd="awk \'BEGIN\{pi\=3.141592458\} \$0\!\~\/\^\\\#\/ \&\& \$1\<1\{sum\+\=4\*pi\*\$1\*\*2\*\(\$2)*0.1\}END\{print  sum}\' ".$dens2_dir."commented\/${nucleus}\.density2\.com |";
	    
	    print "cmd is $cmd\n";
	    open(PP,$cmd);
	    $thing=<PP>;
	    close(PP);
	    chomp($thing);
	    $DATA{$nucleus}{"dens2_pp_near"}=$thing;  #save it
	    $DATA{$nucleus}{"dens2_nn_near"}=$thing;  #save it
	    $temp=$thing/$DATA{$nucleus}{"dens2_norm_pp"};
	    print "For $nucleus, pp near fraction is $temp, from $thing\n";
	    
	    #####################  near np 
	    #
	    $cmd="awk \'BEGIN\{pi\=3.141592458\} \$0\!\~\/\^\\\#\/ \&\& \$1\<1\{sum\+\=4\*pi\*\$1\*\*2\*\(\$4)*0.1\}END\{print  sum}\' ".$dens2_dir."commented\/${nucleus}\.density2\.com |";
	    
	    print "cmd is $cmd\n";
	    open(PP,$cmd);
	    $thing=<PP>;
	    close(PP);
	    chomp($thing);
	    $DATA{$nucleus}{"dens2_np_near"}=$thing;  #save it
	    $temp=$thing/$DATA{$nucleus}{"dens2_norm_np"};
	    print "For $nucleus, NP near fraction is $temp, from $thing\n";
	    
	    
	    ####add thing for NN
	}
	else
	{
	    #this is nn stuff.
	    print "Doing stuff for non-isoscalar nucleus $nucleus\n";
	    	    
	    #
	    #####################   Normalization for pp
	    #
	    $cmd="awk \'BEGIN\{pi\=3.141592458\} \$0\!\~\/\^\\\#\/ \{sum\+\=4\*pi\*\$1\*\*2\*\(\$2\)*0.1\}END\{print  sum}\' ".$dens2_dir."commented\/${nucleus}\.density2\.com |";
	    
	    print "cmd is $cmd\n";
	    open(PP,$cmd);
	    $thing=<PP>;
	    close(PP);
	    chomp($thing);
	    $DATA{$nucleus}{"dens2_norm_pp"}=$thing;  #save it
	    
	    print "For $nucleus, pp density normalization is $thing\n";
	    
	    #
	    #####################   Normalization for nn
	    #
	    $cmd="awk \'BEGIN\{pi\=3.141592458\} \$0\!\~\/\^\\\#\/ \{sum\+\=4\*pi\*\$1\*\*2\*\(\$6\)*0.1\}END\{print  sum}\' ".$dens2_dir."commented\/${nucleus}\.density2\.com |";
	    
	    print "cmd is $cmd\n";
	    open(PP,$cmd);
	    $thing=<PP>;
	    close(PP);
	    chomp($thing);
	    $DATA{$nucleus}{"dens2_norm_nn"}=$thing;  #save it
	    
	    print "For $nucleus, nn density normalization is $thing\n";
	    
	    #
	    #####################   Normalization for np
	    #
	    $cmd="awk \'BEGIN\{pi\=3.141592458\} \$0\!\~\/\^\\\#\/ \{sum\+\=4\*pi\*\$1\*\*2\*\(\$4\)*0.1\}END\{print  sum}\' ".$dens2_dir."commented\/${nucleus}\.density2\.com |";
	    
	    print "cmd is $cmd\n";
	    open(PP,$cmd);
	    $thing=<PP>;
	    close(PP);
	    chomp($thing);
	    $DATA{$nucleus}{"dens2_norm_np"}=$thing;  #save it
	    
	    print "For $nucleus, np density normalization is $thing\n";
	    
	    
	    
	    #####################  near pp 
	    #
	    $cmd="awk \'BEGIN\{pi\=3.141592458\} \$0\!\~\/\^\\\#\/ \&\& \$1\<1\{sum\+\=4\*pi\*\$1\*\*2\*\(\$2)*0.1\}END\{print  sum}\' ".$dens2_dir."commented\/${nucleus}\.density2\.com |";
	    
	    print "cmd is $cmd\n";
	    open(PP,$cmd);
	    $thing=<PP>;
	    close(PP);
	    chomp($thing);
	    $DATA{$nucleus}{"dens2_pp_near"}=$thing;  #save it
	    $temp=$thing/$DATA{$nucleus}{"dens2_norm_pp"};
	    print "For $nucleus, pp near fraction is $temp, from $thing\n";
	    
	    
	    #####################  near nn 
	    #
	    $cmd="awk \'BEGIN\{pi\=3.141592458\} \$0\!\~\/\^\\\#\/ \&\& \$1\<1\{sum\+\=4\*pi\*\$1\*\*2\*\(\$6)*0.1\}END\{print  sum}\' ".$dens2_dir."commented\/${nucleus}\.density2\.com |";
	    
	    print "cmd is $cmd\n";
	    open(PP,$cmd);
	    $thing=<PP>;
	    close(PP);
	    chomp($thing);
	    $DATA{$nucleus}{"dens2_nn_near"}=$thing;  #save it
	    $temp=$thing/$DATA{$nucleus}{"dens2_norm_nn"};
	    print "For $nucleus, nn near fraction is $temp, from $thing\n";
	    
	    #####################  near np 
	    #
	    $cmd="awk \'BEGIN\{pi\=3.141592458\} \$0\!\~\/\^\\\#\/ \&\& \$1\<1\{sum\+\=4\*pi\*\$1\*\*2\*\(\$4)*0.1\}END\{print  sum}\' ".$dens2_dir."commented\/${nucleus}\.density2\.com |";
	    
	    print "cmd is $cmd\n";
	    open(PP,$cmd);
	    $thing=<PP>;
	    close(PP);
	    chomp($thing);
	    $DATA{$nucleus}{"dens2_np_near"}=$thing;  #save it
	    $temp=$thing/$DATA{$nucleus}{"dens2_norm_np"};
	    print "For $nucleus, NP near fraction is $temp, from $thing\n";
	    
	    
	    ####add thing for NN
	}
    }

}


sub make_file
{
   open (NUC,"nuclei_info_annotated.dat");
   while(<NUC>)
   {
       $line=$_;
       chomp($line);
       $line=~s/\t/  /g;
       ($nn, $label, $z, $n)=split(/ +/, $line, 4);
       print "Got nuclear info for $nn, $label, $z, $n\n";
       $nuc_info{$nn}[0]=$label;
       $nuc_info{$nn}[1]=$z;
       $nuc_info{$nn}[2]=$n;
   }
   close(NUC);

    open (OUT, ">summary_file.dat") or die "I just couldn't open this file\n";
#    open (NUC,">nuclei_info.dat");
#    open (NUC,"nuclei_info_annotated.dat");
    print OUT "\# nucleus-1 mom_norm_p-2 mom_norm_n-3 highmom1-p-4 highmom2-p-5 highmom1-n-6 highmom2-n-7 KE_p-8 KE_n-9 KE_hm1_p-10  KE_hm2_p-11 KE_hm1_n-12 KE-hm2_n-13 dens_norm-14 dens-15 radius-16 dens2_pp_norm-17 dens2_np_norm-18 dens2_ppnear-19 dens2_npnear-20 label-21 z-22 n-23, dens2_nn_norm-24, dens_nnnear_25\n";
    foreach $nucleus (sort keys %DATA)
    {
	print "Nucleus is $nucleus\n";
	$normal_order=1;
#	print NUC "$nucleus\n";
#	foreach $param (sort keys %{$DATA{$nucleus}})
#	{
#	    print "param is $param\n";
#	    
#	    
	#	}

	#columns 1,2,3,4,6,7

	$real_z=$nuc_info{$nucleus}[1];
	$int_z=$DATA{$nucleus}{"mom_norm_p"};
	$int_n=$DATA{$nucleus}{"mom_norm_n"};
	if ($int_z=~/[0-9]+/)
	{
	    print "Mom dist exists for $nucleus, $int_z\n";
	    $diff=($real_z/$int_z-1.0);
	    if (abs($diff) <0.01)
	    {
		print "Matched the zzzz, $real_z, $int_z, $int_n, $nucleus, diff $diff\n";
		$normal_order=1;
	    }
	    else
	    {
		$diff=($real_z/$int_n -1.0);
		if (abs($diff)<0.01)
		{
		    print "Mismatched zzz, $real_z, $int_z, $int_n, $nucleus, diff $diff\n";
		    $normal_order=0;
		}
		else
		{
		    print "zzz some other bullshit, $real_z, $int_z, $int_n, $nucleus\n";
		}
	    }

	}
	else
	{
	    print "No mom dist for $nucleus\n";
	}
	printf OUT ("%8s  ",$nucleus);
	if ($normal_order==1)
	{
	    printf OUT ("%8.3f  ", $DATA{$nucleus}{"mom_norm_p"});
	    printf OUT ("%8.3f  ", $DATA{$nucleus}{"mom_norm_n"});
	    printf OUT ("%8.3f  ", $DATA{$nucleus}{"highmom1_p"});
	    printf OUT ("%8.3f  ", $DATA{$nucleus}{"highmom2_p"});
	    printf OUT ("%8.3f  ", $DATA{$nucleus}{"highmom1_n"});
	    printf OUT ("%8.3f  ", $DATA{$nucleus}{"highmom2_n"});
	}
	else
	{
	    printf OUT ("%8.3f  ", $DATA{$nucleus}{"mom_norm_n"});
	    printf OUT ("%8.3f  ", $DATA{$nucleus}{"mom_norm_p"});
	    printf OUT ("%8.3f  ", $DATA{$nucleus}{"highmom1_n"});
	    printf OUT ("%8.3f  ", $DATA{$nucleus}{"highmom2_n"});
	    printf OUT ("%8.3f  ", $DATA{$nucleus}{"highmom1_p"});
	    printf OUT ("%8.3f  ", $DATA{$nucleus}{"highmom2_p"});
	    
	}
	printf OUT ("%8.3f  ", $DATA{$nucleus}{"KE_p"});
	printf OUT ("%8.3f  ", $DATA{$nucleus}{"KE_n"});
	printf OUT ("%8.3f  ", $DATA{$nucleus}{"KE_highmom1_p"});
	printf OUT ("%8.3f  ", $DATA{$nucleus}{"KE_highmom2_p"});
	printf OUT ("%8.3f  ", $DATA{$nucleus}{"KE_highmom1_n"});
	printf OUT ("%8.3f  ", $DATA{$nucleus}{"KE_highmom2_n"});

	printf OUT ("%8.3f  ", $DATA{$nucleus}{"dens_norm"});
	printf OUT ("%8.3f  ", $DATA{$nucleus}{"dens"});
	printf OUT ("%8.3f  ", $DATA{$nucleus}{"radius"});

	printf OUT ("%8.3f  ", $DATA{$nucleus}{"dens2_norm_pp"});
	printf OUT ("%8.3f  ", $DATA{$nucleus}{"dens2_norm_np"});
	printf OUT ("%8.3f  ", $DATA{$nucleus}{"dens2_pp_near"});
	printf OUT ("%8.3f  ", $DATA{$nucleus}{"dens2_np_near"});


	printf OUT ("%4i  ", $nuc_info{$nucleus}[0]);
	printf OUT ("%4i  ", $nuc_info{$nucleus}[1]);
	printf OUT ("%4i  ", $nuc_info{$nucleus}[2]);

	printf OUT ("%8.3f  ", $DATA{$nucleus}{"dens2_norm_nn"});
	printf OUT ("%8.3f  ", $DATA{$nucleus}{"dens2_nn_near"});
	printf OUT "\n";
    }

#    close(NUC);
    close(OUT);
    
}



#rad_corr_p=sqrt(rms_p**2+0.85**2)/rms_p
#rho_p=rawrho_p/rad_corr_p**3

#add another label 0,1,2
