#!/bin/bash

cd ./data/

rm -r sp/
rm -r s2p/
rm -r s3p/
rm -r op/
rm -r o2p/
rm -r elec/
rm -r ex/
rm -r LOAD/
rm -r MOUT/
rm -r VSUB/
#rm -r OXGN/
#rm -r SLFR/

#mkdir OXGN
#mkdir SLFR
mkdir LOAD
mkdir MOUT
mkdir VSUB

good=$?
if [ $good -ne 0 ]
  then
  echo "LOAD folder already exists. Please remove or change name to procede." 
fi

mv LOAD*.dat LOAD/.
mv MOUT*.dat MOUT/.
mv VSUB*.dat VSUB/.
#mv OXGN*.dat OXGN/.
#mv SLFR*.dat SLFR/.

cd ../
./organizeSpecies.sh sp
./organizeSpecies.sh s2p
./organizeSpecies.sh s3p
./organizeSpecies.sh op
./organizeSpecies.sh o2p
./organizeSpecies.sh elec
./organizeSpecies.sh ex  

