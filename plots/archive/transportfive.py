import os 
import sys
import math

#def calcTrans(path):
#  infile = open(path, "r")
#  outfile
#
#for file in os.listdir("./"):
#  if file.endswith("rad.dat") and file.startswith("NL2_elec"):
#    path=os.getcwd() +"/"+file
#    calcTrans(path)

def Transport(path, dll0, s):
  #dayint=int(sys.argv[1])
  for i in range(1,100):
    dayint = i
    zeroes=int(3 - math.floor(math.log10(dayint)))

  for i in range(0, zeroes):
    day="0"+str(dayint)

  target=path+"/elec/NL2_/NL2_elec"+str(day)+"rad.dat"
#  if( not os.path.isfile(target)): return 0
  while( not os.path.isfile(target)):
    dayint=dayint-1
    for i in range(0, zeroes):
      day="0"+str(dayint)
    target=path+"/elec/NL2_/NL2_elec"+str(day)+"rad.dat"
    if( dayint == 0 ): return 0

  infile = open(target, "r")

  inputs=open(path+"/inputs.dat", "r")

  for i in range(1, 10):
    line=inputs.readline()
  #print path+"/inputs.dat", line

  dll0=float(line)

#print dll0

  line=inputs.readline()
  [dlla, junk]=line.split(" ", 1)
  dlla=float(dlla)
#print dlla

  rarray=[]
  narray=[]
  for line in infile:
    [rdist, nl2]=line.split()
    rarray.append(float(rdist))
    narray.append(float(nl2))

  infile.close()

  dll=[]
  for r in rarray:
    dll.append(dll0*(r/6.0)**dlla)

  dr=rarray[2]-rarray[1]
#print rarray
#print narray
#print dll

  stuff=[1.0e30]
  for i in range(1,len(rarray)):
    stuff.append(dll[i]*((narray[i]-narray[i-1])/dr)/(rarray[i]**2))

  stuff[0]=stuff[1]

#print stuff

  transport=[]

  ntot=[]
  for i in range(0, len(narray)):
    tot=0.0
    for j in range(i):
      tot=tot+(narray[j]/rarray[j]**2)*dr
    ntot.append(tot)

#print narray
#print ntot

  for i in range(0,len(rarray)):
    transport.append(-1.0*narray[i]/(rarray[i]**2)/86400.0/stuff[i])
  
  ttot=[0.0]
  for i in range(1, len(narray)):
    tot=0.0
    for j in range(i):
      tot=tot+transport[j]*(rarray[j+1]-rarray[j])
    ttot.append(tot)
  
  outputs=open("transport.dat", "a")
  #for i in range(len(rarray)):
  outputs.write(str(dll0)+" " + str(s) + "e28 " + str(ttot[15]) + '\n')
  outputs.close()

#print '\n',transport
#print '\n',rarray
#print '\n',ttot
open("transport.dat", "w").close
s=[5.0,6.0] #,7.0,8.0,10.0]
#dll=[0.5, 1.0, 2.0, 3.0, 4.5, 6.0, 7.5, 9.0, 10.5, 12.0, 15.0, 18.0]
salph=[-12.0,-14.5]
dll=[6.5,8.0] #,9.5,11.0,15.0]
dllalph=[3.5] #,4.5,5.5]
fhe=[0.002,0.003]
fhealph=[3.5] #,5.0,7.0]
#for s in {1.0, 2.0, 3.0, 4.0, 4.5, 5.0, 5.5, 6.0, 7.0}: #take from gatherData.py that generated the data
for i in range(0, len(s)) :
 # for dll in {3.0, 4.5, 6.0, 7.5, 9.0, 10.5, 12.0, 15.0, 18.0}:
  for j in range(0, len(salph)) : #take from gatherData.py that generated the data
    for k in range(0,len(dll)):
      for l in range(0,len(dllalph)):
        for m in range(0,len(fhe)):
          for n in range(0,len(fhealph)):
            run='run-('+str(i)+', '+str(j)+', '+str(k)+', '+str(l)+', '+str(m)+', '+str(n)+')'
            if(os.path.exists(run)):
              Transport(run, dll[i], s[j])
            out=open("transport.dat", "a")
            out.write('\n')  
            out.close()

os.popen("gnuplot plotTransport.gnu")
