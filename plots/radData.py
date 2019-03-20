import os
import sys

radsize=int(sys.argv[1])
latsize=int(sys.argv[2])
radspan=4.25

def createData(path):
  infile = open(path, "r")
  outfile = open(path.replace("_1D.dat", "rad.dat"), "w")
  for i in range(1, radsize+1):
    total=0.0
    lat=0.0
    value=0.0
    rad=6.0+((i-1)*radspan/(radsize-1))
   # rad=6.0+((i-1)*radspan/(radsize))
    for j in range(1, latsize+1):
      line=infile.readline()
      [lat,value]=line.split()
      total=total+float(value);
      avg=total/latsize;
    outfile.write(str(rad)+" ");
    outfile.write(str(avg)+"\n");
    line=infile.readline()
    [lat,value]=line.split()
  infile.close()
  outfile.close()

for file in os.listdir("./"):
  if file.endswith("_1D.dat"):
    path=os.getcwd()+"/"+file
    createData(path)


