DIR=$1
days=100

python chi.py
python puv.py
python transport.py

mkdir ./FitPlots/$1
./mixRatio.sh $days $1
mv *mix.jpeg ./FitPlots/$1/.
./radialplots.sh $days DENS $1
mv animated.mpeg ./FitPlots/$1/raddens.mpeg
./radialplots.sh $days TEMP $1
mv animated.mpeg ./FitPlots/$1/radtemp.mpeg
./radialplots.sh $days NL2_ $1
mv animated.mpeg ./FitPlots/$1/radnl2.mpeg
