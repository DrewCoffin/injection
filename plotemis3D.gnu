set terminal pngcairo
set output 'plotemisOp.png'
set pm3d map interpolate 1,1
set style data pm3d
set style function pm3d
set ylabel 'Temperature (eV)'
set xlabel 'Density (cm^-3)'
set title "Oxygen + Rate map"             
set key off
set xr [1:500]
set yr [0.1:500]
set log x
set log y
set palette
set cbrange [10**-33:10**-14]
set logscale cb
set format cb '10^%L' 
show pm3d
splot 'plotemisOp.dat' using 1:2:3
