import os

lineNum=34

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
  return str(float(Puv))

#open("Puv.dat", 'w').close()
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
            if(not os.path.exists("./"+run)): print "BAD", run
            if(os.path.exists("./"+run)):
              Puv=getPuv(run)
              out=open("Puv.dat", 'a')
              if( Puv > 0.0 ): out.write(str(dll[i])+"e-7 " + str(s[j])+"e28 " + Puv+'\n')
              #print dll[i], s[j], Puv
              out.write('\n')
              out.close()

os.popen("gnuplot plotPuv.gnu")
