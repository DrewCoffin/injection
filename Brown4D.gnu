set terminal jpeg
set output 'Brown4D.jpeg'
set title "Brown subcorotation profile effect on System IV frequency"
#set autoscale cbfix
set xlabel "Amplitude"
set ylabel "L-shell"
set zlabel "FWHM"
set cblabel "Frequency"
splot 'Brown.dat' u 1:2:3:4 lc palette
