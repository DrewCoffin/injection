set terminal png 
set output 'subcovel.png'  
set key off
set title 'Subcorotation velocity'
set ylabel 'Velocity (km/s)'                 
set xlabel 'Radial Distance (RJ)'
set grid ytics
set xrange [6:9]
set grid xtics
plot 'subcovel.dat' using 3:2 with lines, #\
     'subcovel2.dat' using 3:2 with lines lc rgb 'blue'
