import pandas
import os
import copy
import matplotlib.pyplot as plt
import numpy
import itertools

lineNum=34

def transpose(array):
  return map(list, zip(*array)) 

def getData(E, sig):
  tmp=[]
  tmp=pandas.read_csv('Expected.dat', sep='\t', header=None)
  tmp=tmp.values
  tmp=transpose(tmp)
  E=tmp
  tmp=pandas.read_csv('Sigma.dat', sep='\t', header=None)
  tmp=tmp.values
  tmp=transpose(tmp)
  sig=tmp
#  print E, '\n'
#  print sig
  return [E, sig]

def getOutput(output,run):
  paths=[]
  day=100
  pathParams=[["elec", "DENS"], ["op", "MIXR"], ["o2p","MIXR"], ["sp","MIXR"], ["s2p","MIXR"], ["s3p","MIXR"], ["elec", "NL2_"], ["elec", "TEMP"]]
  for i in range(0,len(pathParams)):
    path="./"+run+"/"+pathParams[i][0]+"/"+pathParams[i][1]+"/"+pathParams[i][1]+pathParams[i][0]+"0"+str(day)+"rad.dat"
#    while(not os.path.isfile(path)):
#      day=day-1
#      path="./"+run+"/"+pathParams[i][0]+"/"+pathParams[i][1]+"/"+pathParams[i][1]+pathParams[i][0]+"0"+str(day)+"rad.dat"
#      if( day == 0 ): return 0
    if( not os.path.isfile(path) ): return 0
    paths.append(path)
#    print os.path.isfile(path)
#  print paths
  output.append([])
  for f in paths:
    data=pandas.read_csv(f, sep=' ', header=None)
    data=data.values
    data=transpose(data) 
    output.append(data[1])
  output[0]=data[0]
  return 1    

def modifyOutput(output, O):
  for i in range(0, len(O)):
    for j in range(0, len(O[i])):
      k=j
      if i==len(O)-1: k=j+1
      O[i][len(O[i])-j-1]=output[i+1][k]    
  return O

def calculateChi(O, E, sig):
  chis=[]
  chi=0
  for i in range(0, len(O)):
    for j in range(0, len(O[i])-1):
      k=len(O[i])-1-j
      if not (i==len(O)-1 and j==0):
        chi=chi+(((O[i][k] - E[i][k])**2)/sig[i][k]**2)
    chis.append(chi)
  return chis

def output(outputLine, chis, filenames):
  for i in range(0, len(filenames)):
    out=open(filenames[i]+"chi.dat", 'a')
    out.write(outputLine)
    out.write(str(chis[i])+'\n')
    out.close()

def outputSpace(filenames):
  for i in range(0, len(filenames)):
    out=open(filenames[i]+".dat", 'a')
    out.write('\n')
    out.close()

def getPuv(folder):
  runlog=open("./"+run+"/runlog", 'r')
  lNum=0
  junk=""
  Puv=''
  for line in runlog:
    lNum=lNum+1
    if(lNum == lineNum):
      s=line.rsplit('\n', 1)
#      print s
      while(Puv==''):
       s=s[0].rsplit(' ', 1)
       Puv=s[1]
#       print s
  if(lNum < lineNum):
#    print "ERROR:", run, " only has ", lNum, " lines."
    return 0
  return float(Puv)

def PuvFit(Puv):
  PuvChi=((1.75-Puv)/0.3)**2
  return PuvChi

E=[]
sig=[]
[E, sig]=getData(E, sig)
outputs=[]
filenames=["elecDens", "op", "o2p", "sp", "s2p", "s3p", "NL2", "elecTemp", "Tot"] 
for name in filenames: open(name+'chi.dat', 'w').close()
out=open("chi.dat", 'w')
#s=[0.1, 0.25, 0.5, 0.75, 1.0, 2.0, 3.0, 4.0, 4.5, 5.0, 5.5, 6.0]
#dll=[0.5, 1.0, 2.0, 3.0, 4.5, 6.0, 7.5, 9.0, 10.5, 12.0, 15.0, 18.0]
#for s in {1.0, 2.0, 3.0, 4.0, 4.5, 5.0, 5.5, 6.0, 7.0}: #take from gatherData.py that generated the data
#for i in range(0, len(dll)) :
# # for dll in {3.0, 4.5, 6.0, 7.5, 9.0, 10.5, 12.0, 15.0, 18.0}:
#  for j in range(0, len(s)) : #take from gatherData.py that generated the data
sourceArray=[5.0, 6.0, 7.0, 8.0, 10.0]
lens=len(sourceArray)
sourceAlphaArray=[-12.0, -14.5]
lensa=len(sourceAlphaArray)
dllArray=[6.5, 8.0, 9.5, 11.0, 15.0]
lend=len(dllArray)
dllAlphaArray=[3.5, 4.5, 5.5]
lenda=len(dllAlphaArray)
fheArray=[0.0020, 0.0030]
lenf=len(fheArray)
fheAlphaArray=[3.5, 5.0, 7.0]
lenfa=len(fheAlphaArray)
runs=lens*lensa*lend*lenda*lenf*lenfa
product=itertools.product(range(0,lens), range(0,lensa), range(0,lend), range(0,lenda), range(0,lenf), range(0,lenfa))
for index in product:
    run="run-"+str(index)
    source=sourceArray[index[0]]
    sourceAlpha=sourceAlphaArray[index[1]]
    dll=dllArray[index[2]]
    dllAlpha=dllAlphaArray[index[3]]
    fhe=fheArray[index[4]]
    fheAlpha=fheAlphaArray[index[5]]
    if(not os.path.exists("./"+run)): print "BAD", run
    O=copy.deepcopy(E)
    outputs=[]
    if(getOutput(outputs, run) and os.path.exists("./"+run)):
      O=modifyOutput(outputs, O)
    #  print outputs
      chis=calculateChi(O, E, sig)
      Puv=getPuv(run)
      PuvChi=PuvFit(Puv)
      chis.append((chis[3] + chis[5] + 12.0*PuvChi )/35.0)
      outputLine = ""
      outputLine = outputLine + str(source) + "e28" + ' , '
      outputLine = outputLine + str(sourceAlpha) + ' , '
      outputLine = outputLine + str(dll) + "e-7" + ' , '
      outputLine = outputLine + str(dllAlpha) + ' , '
      outputLine = outputLine + str(fhe) + ' , '
      outputLine = outputLine + str(fheAlpha) + ' , '
      outputLine = outputLine + str(Puv) + ' , '
#      out.write(outputLine#      print O, '\n', E, '\n', "+++++++++++++++++++++++++++++++++++++++++++++"
      output(outputLine, chis, filenames)
#  outputSpace(filenames)
#  out=open("chi.dat", 'a')
#    out.write('\n')
out.close()

#os.popen("gnuplot plot.gnu")
#print x
#print y
#print z
#makePlot(x, y, z) #<-BROKEN
    #GetData(E, sig)
    #GetOutput(output)
    #ModifyOutput(output, O)
    #calculate chi squared(O, E, sig)
    #output chi squared, s, dll in proper order for plotting
#plot heatmap of chi squared
