#!/bin/bash

cd ./data/

species=$1
elec="elec"
mkdir "$species"
good=$?
if [ $good -ne 0 ]
  then
  echo "'$species' folder already exists. Please remove or change name to procede." 
fi

if [ $good -eq 0 ]
  then
  mkdir "$species"/DENS
  mv DENS"$species"*.dat "$species"/DENS/.
#  if [ $species != $elec ]
#  then
  mkdir "$species"/MIXR
  mv MIXR"$species"*.dat "$species"/MIXR/.
#  fi
  mkdir "$species"/TEMP
  mv TEMP"$species"*.dat "$species"/TEMP/.
#  mkdir "$species"/INTS
#  mv INTS"$species"*.dat "$species"/INTS/.
  mkdir "$species"/NL2_
  mv NL2_"$species"*.dat "$species"/NL2_/.
  mkdir "$species"/PUV_
  mv PUV_"$species"*.dat "$species"/PUV_/.
#  mkdir "$species"/ENTR
#  mv ENTR"$species"*.dat "$species"/ENTR/.
  if [ $species = $elec ]
    then
    mkdir elec/FEH_
    mv FEH_elec*.dat elec/FEH_/.
  fi
fi

