set terminal jpeg size 1440, 1080
set output 'Brown.jpeg'
set multiplot layout 2,2 rowsfirst 
set key off
#set title "Brown profile effect on frequency"
# Graph 1
set xlabel "Amplitude"
set ylabel "L-shell"
set cblabel "Frequency (rad/day)"
set title "Amplitude against L-shell"
plot 'Brown.dat' u 1:2:4 lc palette
# Graph 2
set xlabel "Amplitude"
set ylabel "FWHM"   
set cblabel "Frequency (rad/day)"
set title "Amplitude against FWHM"
plot 'Brown.dat' u 1:3:4 lc palette
# Graph 3
set xlabel "L-shell"  
set ylabel "FWHM"   
set cblabel "Frequency (rad/day)"
set title "L-shell against FWHM"
plot 'Brown.dat' u 2:3:4 lc palette
unset multiplot
