set terminal jpeg
set pm3d map
set pm3d interpolate 32, 32
set xrange [1.0e-7:18.0e-7]
set yrange [0.1e28:6.0e28]
set format x "%G"
set xlabel 'Diffusion Coefficient'
set ylabel 'Source Rate (particles/cc)'
set zlabel 'Power Radiated (TW)'
set cblabel 'Power Radiated (TW)'
set cbrange [0.5:3.0]
#set log cb
set log x
set log y
set key tmargin left
set title 'Emission Intensity'
set output 'testPuv.jpeg'
splot 'Puv.dat' notitle, 'Puvunity.dat' u 1:2:3 title '1 TW' w lines, 'Puvtwo.dat' u 1:2:3 title '2 TW' w lines
