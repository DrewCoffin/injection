import os
import numpy as np
import matplotlib.pyplot as plt

def getdata(datafile):
    pdata = []
    with open(datafile, 'r') as f:
        plines = [line.rstrip() for line in f]
    for i in np.arange(0,((lat+2)*rad), lat+2):
	splitline = plines[i].split(' ')
	splitline = [x for x in splitline if x != '']
	#print splitline
        pdata.append(float(splitline[1]))
    return pdata

def getiondata(spec):
	specdata = getdata("plots/data/" + spec + "/DENS/DENS" + spec + "0001_3D.dat")
	return specdata

def getionterm(n, mS, mO):
	ionlist = ['sp', 's2p', 's3p', 'op', 'o2p']
	ionterm = np.zeros(n)
	for i in range(len(ionlist)):
		specdata = getiondata(ionlist[i])
		if i < 3:
			specdata = [mS*amukg*specdata[j] for j in range(len(specdata))]
		else:
			specdata = [mO*amukg*specdata[j] for j in range(len(specdata))]
		ionterm = [a+b for a,b in zip(ionterm, specdata)]
	#print ionterm
	return ionterm

[rad, lat] = [12, 12] #Radial and latitudinal bins
[mO, mS] = [16, 32] #Mass of species in amu
amukg = 1.660539*10**-27
eVtoJ = 1.602177*10**-19

radarr = np.arange(6,10.25,4.25/(rad-1))
radarr = np.append(radarr, 10.25)
#print radarr

#Tdata = getdata("plots/data/elec/TEMP/TEMPelec0001_3D.dat")
Tdata = [42.0*(radarr[i]/6.0)**5.5*eVtoJ for i in range(len(radarr))] #Hot electron temperature and power law
fdata = getdata("plots/data/elec/FEH_/FEH_elec0001_3D.dat")
ndata = getdata("plots/data/elec/DENS/DENSelec0001_3D.dat")

#print(Tdata, fdata, ndata)

electerm = [a*b*c for a,b,c in zip(fdata,ndata,Tdata)]
#print electerm

ionterm = getionterm(len(electerm), mS, mO)
#print(ionterm)

vterm = np.zeros(len(electerm))
vterm = [(a/b)**(1./2)/1000. for a,b in zip(electerm, ionterm)]

#Note factor of 1000 to turn m/s into km/s

#print vterm

plt.plot(radarr, vterm)
plt.xlabel('radial distance (Rj)')
plt.ylabel('Velocity (km/s)')
plt.show()
