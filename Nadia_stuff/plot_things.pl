set style line 1 lc rgb "red" lw 2 pt 5 ps 1.7
set style line 2 lc rgb "navy" lw 2 pt 7 ps 1.4

set style line 3 lc rgb "forest-green" lw 2 pt 9 ps 1.4
set style line 4 lc rgb "cyan" lw 2 pt 11 ps 1.4
set style line 5 lc rgb "brown" lw 2 pt 13 ps 1.4

set style line 6 lc rgb "black" lw 2 pt 15 ps 1.4

set style line 11 lc rgb "red" lw 2 pt 4 ps 1.7
set style line 12 lc rgb "navy" lw 2 pt 6 ps 1.4

set style line 13 lc rgb "forest-green" lw 2 pt 8 ps 1.4
set style line 14 lc rgb "cyan" lw 2 pt 10 ps 1.4
set style line 15 lc rgb "brown" lw 2 pt 12 ps 1.4

set style line 16 lc rgb "black" lw 2 pt 14 ps 1.4

set mxtics 5
set mytics 5
set size ratio 0.9

set key box
set key samplen 0.7 spacing 0.9
set xlabel "A"
set ylabel "in fm-type units"
set term post enhanced color "Helvetica, 22"
set output "flavaflav_dens_p.eps"

#add nadia's file with 'dumb' density
 plot[1:17] "/home/fomin/xgt1/flavaflav2020/dists/summary_file_simple.dat" using ($9*0.9+$10*1.1):($8==1? ($4/$2*2):1/0) ti "simple proton density" ls 3 ,\
 "ryan_summary_file.dat" using ($33*0.9+$34*1.1):($32==1 ? ($15):1/0) ti "average density of nucleons sampled by protons" ls 1,\
 ""  using ($33*0.9+$34*1.1):($32==1 ? ($16):1/0)  ti "same excluding scattered proton" ls 2

set output "flavaflav_dens_n.eps"

plot[1:17]  "/home/fomin/xgt1/flavaflav2020/dists/summary_file_simple.dat" using ($9*0.9+$10*1.1):($8==1? ($5/$3):1/0) ti "simple neutron density" ls 3,\
"ryan_summary_file.dat" using ($33*0.9+$34*1.1):($32==1 ? ($19):1/0) ti "average density of nucleons sampled by neutrons" ls 1 , ""  using ($33*0.9+$34*1.1):($32==1 ? ($20):1/0) ti "same excluding scattered neutron" ls 2


##############kinetic energy stuff
set key top left
set output "flavaflav_ke_p.eps"
set ylabel "Unknown Units"
 plot[1:17]  "ryan_summary_file.dat" using ($33*0.9+$34*1.1):($32==1 ? ($8/$2):1/0) ti "Total KE for protons" ls 1,\
 ""  using ($33*0.9+$34*1.1):($32==1 ? ($10/$2):1/0)  ti "proton KE for p>1fm" ls 2,\
 ""  using ($33*0.9+$34*1.1):($32==1 ? ($11/$2):1/0)  ti "proton KE for p>2fm" ls 3
 set output "flavaflav_ke_n.eps"
plot[1:17]  "ryan_summary_file.dat" using ($33*0.9+$34*1.1):($32==1 ? ($9/$3):1/0) ti "Total KE for neutrons" ls 1,\
 ""  using ($33*0.9+$34*1.1):($32==1 ? ($12/$3):1/0)  ti "neutron KE for p>1fm" ls 2,\
 ""  using ($33*0.9+$34*1.1):($32==1 ? ($13/$3):1/0)  ti "neutron KE for p>2fm" ls 3
set output "flavaflav_ke_np_2fm.eps"
plot[1:17]  "ryan_summary_file.dat" using ($33*0.9+$34*1.1):($32==1 ? ($11/$2):1/0) ti "proton KE for p>2 fm" ls 1,\
"" using ($33*0.9+$34*1.1):($32==1 ? ($13/$3):1/0)  ti "neutron KE for p>2fm" ls 2

######fraction above min momentum
set key reverse
set output "flavaflav_frac_high_pn.eps"
set ylabel "Fraction of total"
plot[1:17] "/home/fomin/xgt1/flavaflav2020/dists/summary_file.dat" using ($22*0.9+$23*1.1):($21==1 ? ($4/$2):1/0) ti "P for k>1fm" ls 1, \
"" using ($22*0.9+$23*1.1):($21==1 ? ($5/$2):1/0) ti "P for  k>2fm" ls 2, \
"" using ($22*0.9+$23*1.1):($21==1 ? ($6/$3):1/0) ti "N for  k>1fm" ls 11, \
"" using ($22*0.9+$23*1.1):($21==1 ? ($7/$3):1/0) ti "N for  k>2fm" ls 12



########fraction within 1fm, from density
set output "flavaflav_frac_close.eps"
set ylabel "Percent"
plot[1:17] "/home/fomin/xgt1/flavaflav2020/dists/summary_file.dat" using ($22*0.9+$23*1.1):($21==1 ? ($19/$17*100):1/0) ti "pp within 1fm" ls 1,\
"" using ($22*0.9+$23*1.1):($21==1 ? ($20/$18*100):1/0) ti "pn within 1fm" ls 2

###some inbetween things

set ylabel "EMC effect"
set xlabel "x"


set output "fake_emc_fast_k2fm_He3.eps"
plot "fakeEMC_A3_Z2_he3.dat" using 1:4 ti "mom frac", "" using 1:(1-$1*$6)


set key bottom left
set output "fake_emc_H3_lines.eps"
set title "A=3, Z=1"
plot [][0.95:1.01]"fakeEMC_A3_Z1_h3.dat" using 1:4 ti "mom frac" ls 1,\
"" using 1:5 ti " closeness" ls 2, \
"" using 1:(1-$1*$6) ti "1-pfrac*x" with lines ls 3, \
"" using 1:(1-$1*$7) ti "1-nfrac*x" with lines ls 4, \
"" using 1:(1-$1*$8) ti "1-pfrac_{close}*x" with lines ls 5, \
"" using 1:(1-$1*$9) ti "1-nfrac_{close}*x" with lines ls 6


set output "fake_emc_He3_lines.eps"
set title "A=3, Z=2"
plot [][0.95:1.01]"fakeEMC_A3_Z2_he3.dat" using 1:4 ti "mom frac" ls 1,\
"" using 1:5 ti " closeness" ls 2, \
"" using 1:(1-$1*$6) ti "1-pfrac*x" with lines ls 3, \
"" using 1:(1-$1*$7) ti "1-nfrac*x" with lines ls 4, \
"" using 1:(1-$1*$8) ti "1-pfrac_{close}*x" with lines ls 5, \
"" using 1:(1-$1*$9) ti "1-nfrac_{close}*x" with lines ls 6

set output "fake_emc_Be9_lines.eps"
set title "A=9, Z=4"
plot [][0.9:1.01]"fakeEMC_A9_Z4_be9.dat" using 1:4 ti "mom frac" ls 1,\
"" using 1:5 ti " closeness" ls 2, \
"" using 1:(1-$1*$6) ti "1-pfrac*x" with lines ls 3, \
"" using 1:(1-$1*$7) ti "1-nfrac*x" with lines ls 4, \
"" using 1:(1-$1*$8) ti "1-pfrac_{close}*x" with lines ls 5, \
"" using 1:(1-$1*$9) ti "1-nfrac_{close}*x" with lines ls 6


set output "fake_emc_C12_lines.eps"
set title "A=12, Z=6"
plot [][0.9:1.01]"fakeEMC_A12_Z6_c12.dat" using 1:4 ti "mom frac" ls 1,\
"" using 1:5 ti " closeness" ls 2, \
"" using 1:(1-$1*$6) ti "1-pfrac*x" with lines ls 3, \
"" using 1:(1-$1*$7) ti "1-nfrac*x" with lines ls 4, \
"" using 1:(1-$1*$8) ti "1-pfrac_{close}*x" with lines ls 5, \
"" using 1:(1-$1*$9) ti "1-nfrac_{close}*x" with lines ls 6

set output "fake_emc_C12.eps"
set title "A=12, Z=6"
plot [][0.9:1.01]"fakeEMC_A12_Z6_c12.dat" using 1:4 ti "mom frac" ls 1,\
"" using 1:5 ti " closeness" ls 2, \
"" using 1:12 ti " density" ls 3, \
"" using 1:15 ti " KE" ls 4, \

set output "fake_emc_Be9.eps"
set title "A=9, Z=4"
plot [][0.9:1.01]"fakeEMC_A9_Z4_be9.dat" using 1:4 ti "mom frac" ls 1,\
"" using 1:5 ti " closeness" ls 2, \
"" using 1:12 ti " density" ls 3, \
"" using 1:15 ti " KE" ls 4, \

set output "fake_emc_He3.eps"
set title "A=3, Z=2"
plot [][0.9:1.01]"fakeEMC_A3_Z2_he3.dat" using 1:4 ti "mom frac" ls 1,\
"" using 1:5 ti " closeness" ls 2, \
"" using 1:12 ti " density" ls 3, \
"" using 1:15 ti " KE" ls 4, \

set output "fake_emc_H3.eps"
set title "A=3, Z=1"
plot [][0.9:1.01]"fakeEMC_A3_Z1_h3.dat" using 1:4 ti "mom frac" ls 1,\
"" using 1:5 ti " closeness" ls 2, \
"" using 1:12 ti " density" ls 3, \
"" using 1:15 ti " KE" ls 4, \

set output "final_answer.eps"
unset title
set xlabel "A"
set ylabel "ABS(EMC slope)"
set key top right
plot [1:13]"consolidated_slopes_sorted.dat" using (($2+$3)<13 ? ($2+$3):1/0):(abs($4)) ti "Mom Frac" with linespoints ls 1,\
"" using (($2+$3)<13 ? ($2+$3):1/0):(abs($6)) ti "Closeness" with linespoints ls 2, \
"" using (($2+$3)<13 ? ($2+$3):1/0):(abs($8)) ti "Density" with linespoints  ls 3, \
"" using (($2+$3)<13 ? ($2+$3):1/0):(abs($10)) ti "Kinetic Energy" with linespoints  ls 4

set output "final_answer_deutsub.eps"
plot [1:13]"consolidated_slopes_sorted.dat" using (($2+$3)<13 ? ($2+$3):1/0):(abs($4-$12)) ti "Mom Frac" with linespoints ls 1,\
"" using (($2+$3)<13 ? ($2+$3):1/0):(abs($6-$13)) ti "Closeness" with linespoints ls 2, \
"" using (($2+$3)<13 ? ($2+$3):1/0):(abs($8-$14)) ti "Density" with linespoints ls 3, \
"" using (($2+$3)<13 ? ($2+$3):1/0):(abs($10-$15)) ti "Kinetic Energy" with linespoints  ls 4


set output "final_answer_deutsub_c12norm.eps"
plot [1:13]"consolidated_slopes_sorted_kefixed.dat" using (($2+$3)<13 ? ($2+$3):1/0):(abs($4-$12)/0.0799663) ti "Mom Frac" with linespoints ls 1,\
"" using (($2+$3)<13 ? ($2+$3):1/0):(abs($6-$13)/0.026467) ti "Closeness" with linespoints ls 2, \
"" using (($2+$3)<13 ? ($2+$3):1/0):(abs($8-$14)/0.048667) ti "Density" with linespoints ls 3, \
"" using (($2+$3)<13 ? ($2+$3):1/0):(abs($10-$15)/0.0023) ti "Kinetic Energy" with linespoints  ls 4

set term X
set output