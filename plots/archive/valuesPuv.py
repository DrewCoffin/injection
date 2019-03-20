import os
import numpy as np

def getdata(puvfile):
    pdata = []
    with open(puvfile, 'r') as f:
        plines = [line.rstrip() for line in f]
    for i in range(len(plines)):
        if plines[i] != '' :
            splitline = plines[i].split(' ')
            for j in range(len(splitline)):
                splitline[j] = float(splitline[j])
            pdata.append(splitline)
    return pdata

def dllread():
    with open("../../gatherData.py", 'r') as runfile:
        content = runfile.readlines()
    dll1=content[40].strip('dllArray=[').rstrip(']\n')
    dll=dll1.split(', ')
    for i in range(len(dll)):
        dll[i] = float(dll[i])*1e-7
    return dll

def arrangedata(input,nrows):
    puvarr = np.zeros((len(nrows),3), dtype=object)
    for j in range(len(nrows)):
        puvarr[j][0] = dll[j]
        puvarr[j][1] = []
        puvarr[j][2] = []
        for k in range(len(input)):
            if pdata[k][0] == dll[j]:
                puvarr[j][1].append(pdata[k][1])
                puvarr[j][2].append(pdata[k][2])
    return puvarr

def puvtable(Tw, puvarr, dll):
    puvtable = np.zeros((len(puvarr),3))
    for i in range(len(puvtable)):
        puvtable[i][0] = dll[i]
        for j in range(len(puvarr[i][2])):
            if puvarr[i][2][len(puvarr[i][2])-1] < Tw:
                puvtable[i][1] = 'nan' 
                puvtable[i][2] = 'nan'
            else:
                if puvarr[i][2][j] < Tw:
                    x1 = puvarr[i][1][j]
                    x2 = puvarr[i][1][j+1]
                    y1 = puvarr[i][2][j]
                    y2 = puvarr[i][2][j+1]
                    puvtable[i][1] = x1 + (Tw-y1)*(x2-x1)/(y2-y1)
                    puvtable[i][2] = Tw
    return puvtable

def writetable(source,destfile):
    points = open(destfile + '.dat', 'w')
    for i in range(len(source)):
        points.write(str(source[i][0]) + ' ' + str(source[i][1]) + ' ' + str(source[i][2]) + '\n')
    points.close()

pdata = getdata('Puv.dat')
dll = dllread()
puvarr = arrangedata(pdata,dll)
puvunity = puvtable(1, puvarr, dll)
unitytable = writetable(puvunity, 'Puvunity')
puvtwo = puvtable(2, puvarr, dll)
dualitytable = writetable(puvtwo, 'Puvtwo')
