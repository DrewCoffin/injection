set terminal png
set output 'entropy.png'
set ylabel 'Entropy [(nT)^gamma]'         
set xlabel 'Radial distance (Rj)'
set logscale y
set yrange [300:50000]
#set autoscale
set title "Radial flux tube entropy profiles"        
set key outside
plot 'sp.dat' using 1:2 title 'S+', \
     's2p.dat' using 1:2 title 'S2+', \
     's3p.dat' using 1:2 title 'S3+', \
     'op.dat' using 1:2 title 'O+', \
     'o2p.dat' using 1:2 title 'O2+', \
     'elec.dat' using 1:2 title 'e-' #, \
     #'tot.dat' using 1:2 title 'Total'
