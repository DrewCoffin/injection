FUNCTION CIRCLE, xcenter, ycenter, radius
   points = (2 * !PI / 99.0) * FINDGEN(100)
   x = xcenter + radius * COS(points )
   y = ycenter + radius * SIN(points )
   RETURN, TRANSPOSE([[x],[y]])
END

;-----------------------------------------------------------
pro read_output,filetype,spec,nt,nlng,nr,lng,val,rad
;-----------------------------------------------------------

lng = 0.0
val = 0.0
close,1
fil = '/home/dcoffin/2D_Model-master/plots/data/'+spec+'/'+filetype+'/'+filetype+spec+nt+'_3D.dat'
print,fil
openr,1,fil
;readf,1,lng,val,rad
lng = 0.
val = 0.
rad = 0.
for j = 0,nr-1 do begin
;while not(eof(1)) do begin
   nval = 0.
   for i = 0,nlng-1 do begin
      readf,1,l,v,r
      ;print,l,r
      lng = [lng,l]
      nval = [nval,v]
      ;val = [val,v]
      rad = [rad,r]
   endfor
   nval = nval(1:*)
;   minnv = min(nval)
;   maxnv = max(nval)
;   nval = -1 + 2.0*(nval-minnv)/(maxnv-minnv)
   val = [val,nval]
   if not(eof(1)) then readf,1,junk
;   if not(eof(1)) then readf,1,junk
;endwhile
 
endfor

end
;-----------------------------------------------------------


;-----------------------------------------------------------
pro read_data,nfil,img,pfl,pflr,filetype,spec
;-----------------------------------------------------------

;nlng = 18
;nr = 18


nlng = 24
nr = 36


;sp-------
;filetype='PUV_'
;spec = '.'

i=nfil
if (i lt 10) then tm = '000'+strtrim(string(i),2)
if ((i ge 10) and (i lt 100)) then tm = '00'+strtrim(string(i),2)
if (i ge 100) then tm = '0'+strtrim(string(i),2)
read_output,filetype,spec,tm,nlng,nr,lng,val,rad

pc = transpose([[lng],[rad]])
xy = cv_coord(FROM_POLAR=pc,/TO_RECT,/DEGREES)
;val = val(1:*)
x = reform(xy(0,*))
y = reform(xy(1,*))
triangulate,x,y,tr,b
arrsp = trigrid(x,y,val,tr,nx=401,ny=401)

;extract long profile
wh = where(pc(1,*) eq pc(1,20*1.))
;wh = where(pc(1,*) eq 6.0)
print,pc(1,24*1.)
print,pc(0,wh),val(wh)
;plot,pc(0,wh),val(wh),yrange=[0.03,0.07]
pflr = [reform(pc(0,wh))]
pfl = [val(wh)]


end
;-----------------------------------------------------------


;main program
;@clr_win
xsz = round(1000/1.0)
ysz = round(1000/1.0)
nframe=41
nfrm0 = 0
pfl = 0.0
pflr = 0.0

;XINTERANIMATE, SET=[xsz,ysz, nframe-nfrm0], /SHOWLOAD 

;video_file = 'torus.mp4'
;video = idlffvideowrite(video_file)
;framerate = 7.5
;wdims = w.window.dimensions
;stream = video.addvideostream(xsz, ysz, framerate)

dy = 0.18
dys = 0.02
ypos1 = [0.98-dy,0.98-2*dy,0.98-3*dy,0.98-4*dy,0.98-5*dy]
ypos2 = [0.98-dys,ypos1(0)-dys,ypos1(1)-dys,ypos1(2)-dys,ypos1(3)-dys]


mararr =[0.15,0.21,0.05,0.05] 
w1 = window(window_title='PUV',dimensions=[600,1000],margin=0.5)
loadct,39
tvlct,red,green,blue,/get
w1.setCurrent
p=plot([0,360],[0.035,0.06],/xsty,/nodata,/current,layout=[1,5,1],$
       margin=mararr, xtickname = [' ',' ',' ',' ',' ',' '],$
       xtickv=[0,90,180,270,360],xminor=1,$
       position=[0.15,ypos1(0),0.95,ypos2(0)])

i1 = 30 
i2 = 100
di = i2-i1

for i = i1,i2,1 do begin
   ind = floor((i-i1)*(255./di))
   print,'ind...',ind
   nfrm = i
   read_data,nfrm,img,puv,long,'PUV_','sp'
;   read_data,nfrm,img,dens,long,'NL2_','sp'

   w1.setCurrent
   long=[long,360]
   puv = [puv,puv(0)]
   p = plot(long,puv,'-2',color=[red(ind),green(ind),blue(ind)],$
            /overplot,layout=[1,5,1],font_size=12,$
          xtickname = [' ',' ',' ',' ',' ',' '],$
          xtickv=[0,90,180,270,360],xminor=1,$
            position=[0.15,ypos1(0),0.95,ypos2(0)])
;   p.xtitle='System III Longitude'
   p.ytitle='$P_{UV}$ (eV cm$^{-3}$ s$^{-1}$)' 
;   yaxis = axis('y',location='left',title='$P_{UV}$ (eV cm$^{-3}$ s$^{-1}$)' )
;   p.ytitle='Electron Density (cm$^{-3}$)' 

endfor

p=plot([0,360],[0.035,0.06],/xsty,/nodata,/current,margin=mararr,layout=[1,5,2])
for i = i1,i2,1 do begin
   ind = floor((i-i1)*(255./di))
   print,'ind...',ind
   nfrm = i
;   read_data,nfrm,img,puv,long,'PUV_','sp'
   read_data,nfrm,img,dens,long,'DENS','sp'

   w1.setCurrent
   long=[long,360]
   dens = [dens,dens(0)]
   p = plot(long,dens,'-2',color=[red(ind),green(ind),blue(ind)],$
            /overplot,layout=[1,5,2],margin=0.5,font_size=12, $
            xtickname = [' ',' ',' ',' ',' ',' '],$
            xtickv=[0,90,180,270,360],xminor=1,$
            position=[0.15,ypos1(1),0.95,ypos2(1)])
;   p.xtitle='System III Longitude'
   p.ytitle='S$^+$ Density (cm$^{-3}$)' 
;   yaxis = axis('y',location='left',title='S$^+$ Density (cm$^{-3}$)'  )

endfor

p=plot([0,360],[0.035,0.06],/xsty,/nodata,/current,margin=mararr,layout=[1,5,3])
for i = i1,i2,1 do begin
   ind = floor((i-i1)*(255./di))
   print,'ind...',ind
   nfrm = i
;   read_data,nfrm,img,puv,long,'PUV_','sp'
   read_data,nfrm,img,dens,long,'TEMP','sp'

   w1.setCurrent
   long=[long,360]
   dens = [dens,dens(0)]
   p = plot(long,dens,'-2',color=[red(ind),green(ind),blue(ind)],$
            /overplot,layout=[1,5,3],margin=0.5,font_size=12,$
            xtickname = [' ',' ',' ',' ',' ',' '],$
            xtickv=[0,90,180,270,360],xminor=1,$
            position=[0.15,ypos1(2),0.95,ypos2(2)])
;   p.xtitle='System III Longitude'
   p.ytitle='$S^+ Temperature$ (eV)' 

endfor

p=plot([0,360],[0.035,0.06],/xsty,/nodata,/current,margin=mararr,layout=[1,5,4])
for i = i1,i2,1 do begin
   ind = floor((i-i1)*(255./di))
   print,'ind...',ind
   nfrm = i
   read_data,nfrm,img,nsp,long,'DENS','sp'
   read_data,nfrm,img,nel,long,'DENS','elec'
   read_data,nfrm,img,tsp,long,'TEMP','sp'
   read_data,nfrm,img,telec,long,'TEMP','elec'

   arr = nel

   w1.setCurrent
   long=[long,360]
   arr = [arr,arr(0)]
   p = plot(long,arr,'-2',color=[red(ind),green(ind),blue(ind)],$
            /overplot,layout=[1,5,4],margin=0.5,font_size=12,$
            xtickname = [' ',' ',' ',' ',' ',' '],$
            xtickv=[0,90,180,270,360],xminor=1,$
            position=[0.15,ypos1(3),0.95,ypos2(3)])
   ;p.xtitle='System III Longitude'
   p.ytitle='$Electron Density$ (cm$^{-3}$)' 

  

endfor


p=plot([0,360],[0.035,0.06],/xsty,/nodata,/current,margin=mararr,layout=[1,5,5])
for i = i1,i2,1 do begin
   ind = floor((i-i1)*(255./di))
   print,'ind...',ind
   nfrm = i
   read_data,nfrm,img,nsp,long,'DENS','sp'
   read_data,nfrm,img,tel,long,'TEMP','elec'
   read_data,nfrm,img,tsp,long,'TEMP','sp'
   read_data,nfrm,img,telec,long,'TEMP','elec'

   arr = tel

   w1.setCurrent
   long=[long,360]
   arr = [arr,arr(0)]
   p = plot(long,arr,'-2',color=[red(ind),green(ind),blue(ind)],$
            /overplot,layout=[1,5,5],margin=0.5,font_size=12,$
            xtickv=[0,90,180,270,360],xminor=1,$
            position=[0.15,ypos1(4),0.95,ypos2(4)])
   p.xtitle='System III Longitude'
   p.ytitle='$Electron Temp$ (eV)' 

  

endfor



 cb = colorbar(target=p,range=[-180,180],title="$\lambda_{III}, \lambda_{IV}$ relative phases",font_size=14,rgb_table=39)


end
