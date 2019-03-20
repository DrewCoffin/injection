import numpy as np
import scipy.interpolate as ip
import matplotlib.pyplot as plt

read = np.genfromtxt('./Brown.dat', delimiter=', ', skiprows = 3)

a,l,w,f = read[:,0], read[:,1], read[:,2], read[:,3]
nca, ncl, ncw = 22, 17, 32

fig, axarr = plt.subplots(3,1, figsize=(10,3))

plt.subplot(131)
plt.title('FWHM of 0.8 Rj')
plt.xlabel('Amplitude (- km/s)')
plt.ylabel('L-shell (Rj)')
aw, lw, fw = a[nca+ncl:nca+ncl+ncw], l[nca+ncl:nca+ncl+ncw], f[nca+ncl:nca+ncl+ncw]
#print(lw)
X1, Y1 = np.mgrid[min(aw):max(aw):100j, min(lw):max(lw):100j]
interp1 = ip.griddata((aw, lw), fw, (X1, Y1), method='cubic')
im1 = plt.imshow(interp1.T, extent=(min(aw),max(aw),min(lw),max(lw)), origin='lower')

plt.subplot(132)
plt.title('L-shell of 7.2 Rj')
plt.xlabel('Amplitude (- km/s)')
plt.ylabel('FWHM (Rj)')   
al, wl, fl = a[nca:nca+ncl], w[nca:nca+ncl], f[nca:nca+ncl]
X2, Y2 = np.mgrid[min(al):max(al):100j, min(wl):max(wl):100j]
interp2 = ip.griddata((al, wl), fl, (X2, Y2), method='cubic')
im2 = plt.imshow(interp2.T, extent=(min(al),max(al),min(wl),max(wl)), origin='lower')

plt.subplot(133)
plt.title('Amplitude of 3.0 km/s')
plt.xlabel('L-shell (Rj)')  
plt.ylabel('FWHM (Rj)')   
la, wa, fa = l[:nca], w[:nca], f[:nca]
#print(la, wa, fa)
X3, Y3 = np.mgrid[min(la):max(la):100j, min(wa):max(wa)*1.1:100j]
interp3 = ip.griddata((la, wa), fa, (X3, Y3), method='cubic')
im3 = plt.imshow(interp3.T, extent=(min(la),max(la),min(wa),max(wa)), origin='lower')

plt.tight_layout()

fig.subplots_adjust(bottom=0.35)
cbar_ax = fig.add_axes([0.25, 0.15, 0.5, 0.05])
cbar = plt.colorbar(cax=cbar_ax, orientation='horizontal')
cbar.set_label('Frequency (rad per day)')

plt.savefig('Brown.png')
plt.show()
