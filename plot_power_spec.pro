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
fil = './plots/data/'+spec+'/'+filetype+'/'+filetype+spec+nt+'_3D.dat'
;fil = './plots/archive/dNL2/'+spec+'/'+filetype+'/'+filetype+spec+nt+'_3D.dat'
;fil = './'+filetype+spec+nt+'_3D.dat'
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
   minnv = min(nval)
   maxnv = max(nval)
   nval = -1 + 2.0*(nval-minnv)/(maxnv-minnv)
   val = [val,nval]
   if not(eof(1)) then readf,1,junk
;   if not(eof(1)) then readf,1,junk
;endwhile
 
endfor

end
;-----------------------------------------------------------


;-----------------------------------------------------------
pro read_data,nfil,img,pfl,pfl2,pflr
;-----------------------------------------------------------

nlng = 14 
nr = 14 

;sp-------
filetype='PUV_'
spec = 'sp'

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

;extract radial profile
wh = where(pc(0,*) eq 0.0)
;plot,pc(1,wh),val(wh)
pflr = [pflr,reform(pc(1,wh))]
pfl = [pfl,val(wh)]


;s3p-------
filetype='PUV_'
spec = 's3p' 

read_output,filetype,spec,tm,nlng,nr,lng,val,rad

pc = transpose([[lng],[rad]])
xy = cv_coord(FROM_POLAR=pc,/TO_RECT,/DEGREES)
x = reform(xy(0,*))
y = reform(xy(1,*))
triangulate,x,y,tr,b
arrs3p = trigrid(x,y,val,tr,nx=401,ny=401)

;extract radial profile
wh = where(pc(0,*) eq 0.0)
;plot,pc(1,wh),val(wh)
pflr = [pflr,reform(pc(1,wh))]
pfl2 = [pfl2,val(wh)]


;arr = rotate(arrs3p*arrsp,7)
arr = rotate(arrsp,7)

sz = size(arr)
xarr = min(x) + findgen(sz(1))*(max(x)-min(x))/(sz(1)-1)
yarr = min(y) + findgen(sz(1))*(max(y)-min(y))/(sz(1)-1)
xar = fltarr(sz(1),sz(2))
yar = fltarr(sz(1),sz(2))
for j = 0,sz(2)-1 do begin
   xar(*,j) = xarr
endfor
for i = 0,sz(1)-1 do begin
   yar(i,*) = yarr
endfor

wh = where(arr eq 0)
arr(wh) = max(arr)

wh = where((sqrt(xar^2 + yar^2) gt 6.0) and (sqrt(xar^2 + yar^2) lt 9.0))
minarr = min(arr(wh))

c = image(arr>minarr,xarr,yarr,/buffer,/current,rgb_table=33,axis_style=3,$
         xrange=[-10.5,10.5],yrange=[-10.5,10.5],/xsty,/ysty,$
         position=[0.1,0.15,0.8,0.85],font_size=16)

cb = colorbar(target=c,range=[min(arr(wh)),max(arr(wh))],orientation=1,$
             position=[0.85,0.15,0.88,0.85],textpos=1,font_size=14)
cb.title=filetype+' '+spec
cb.title='S+ Power Output'

print,max(arr),min(arr)

dr = 0.2
;for i = 0,29 do begin
;   f = circle(0,0,0.1+dr*i)
;   p = plot(f(0,*),f(1,*),'w7',/overplot,/buffer)
;endfor
;f = circle(0,0,5.9)
e = ellipse(0,0,major=5.9,/fill_background,/overplot,/buffer,/data)


;for i = 0,22 do begin
;   f = circle(0,0,10.0+dr*i)
;   p = plot(f(0,*),f(1,*),'w7',/overplot,/buffer)
;endfor

f1 = circle(0,0,10.00)
f2 = circle(0,0,20.0)

fx = [reform(f1(0,*)),reform(f2(0,*))]
fy = [reform(f1(1,*)),reform(f2(1,*))]

p = polygon(fx,fy,/fill_background,/data,linestyle=6, clip=1)

t = text(11,0,'0',/data,font_size=16,alignment=0.5,clip=0)
t = text(0,12,'270',/data,font_size=16,alignment=0.5,clip=0)
t = text(-12,0,'180',/data,font_size=16,alignment=0.5,clip=0)
t = text(0,-12,'90',/data,font_size=16,alignment=0.5,clip=0)

img = t.CopyWindow()

t.save, './gifs/torus_'+strcompress(nfil+100,/remove_all)+'.gif'

end
;-----------------------------------------------------------


;main program
;@clr_win
xsz = round(1000/1.0)
ysz = round(1000/1.0)
nframe=401
nfrm0 = 0
pfl = 0.0
pfl2 = 0.0
pflr = 0.0

XINTERANIMATE, SET=[xsz,ysz, nframe-nfrm0], /SHOWLOAD 

video_file = 'torus.mp4'
video = idlffvideowrite(video_file)
framerate = 7.5
;wdims = w.window.dimensions
stream = video.addvideostream(xsz, ysz, framerate)

cnt = 0
ts = 1
for i =  50,400,ts do begin
   w = window(window_title='torus',dimensions=[xsz,ysz],margin=0,$
              buffer=1)
   
   nfrm = i
   read_data,nfrm,img,pfl,pfl2,pflr
   ;im = image(img)
   xinteranimate, frame = cnt, image = img
   print,'video:', video.put(stream, img)
   w.close
   cnt = cnt+1
endfor

;w = window(dimensions=[600,1200],margin=[20,3,20,20])
w = window(dimensions=[600,1200])

ind=1

;plot time series
for i = 2,10,2   do begin
   t = findgen(cnt)*ts
   L = pflr(i)
   whL = where(pflr eq L) 
;   p=plot(t,pfl(wh),'r')
;   p.xtitle='time (days)'
;   p.ytitle='Normalized $P_{UV}$'
;   p.title='L = '+strtrim(string(L),2)
   v = 1.0 
   r = 6.0*7.14e4
   C = 2*!pi*r
   T = (C/v)/(60.*60.*24.)
   omega = 2*!pi/T
   t = findgen(200)
;   p=plot(t,cos(omega*t-130*!dtor),'--',/overplot)
   
   f = FFT_powerspectrum(pfl(whL),ts,FREQ=freq)
   wh = where(2*!pi*freq gt 0.05)
   ps1=plot(2*!pi*freq(wh),f(wh),/ylog,layout=[1,9,ind],/current,$
           margin=[0.12,0.21,0.05,0.1],$
           xrange=[min(2*!pi*freq(wh)),max(3*!pi*freq(wh))/3],yrange=[1e-5,0.1],$
           font_size=12,/xsty,name='S+')
   ps1.title = 'L = '+strmid(strtrim(string(L),2),0,4)
   ps1.ytitle='Power'

   p1=plot([omega,omega],ps1.yrange,'--',/overplot)
   p1=plot([2*omega,2*omega],ps1.yrange,'--',/overplot)
   p1=plot([3*omega,3*omega],ps1.yrange,'--',/overplot)
   p1=plot([4*omega,4*omega],ps1.yrange,'--',/overplot)
   p1=plot([5*omega,5*omega],ps1.yrange,'--',/overplot)
   p1=plot([6*omega,6*omega],ps1.yrange,'--',/overplot)
   ;for i = 1,5 do begin
   ;        p1=plot([i*omega,i*omega],ps1.yrange,'--',/overplot)
   ;endfor

   omega_Io = 2*!pi/5.8
   p1=plot([omega_Io,omega_Io],p1.yrange,'--',/overplot)

   f = FFT_powerspectrum(pfl2(whL),ts,FREQ=freq)
   wh = where(2*!pi*freq gt 0.05)
   ps3=plot(2*!pi*freq(wh),f(wh),':',/overplot,name='S+++')

   ind = ind+1
endfor   
   l = legend(target=[ps1,ps3])
   ps1.xtitle = 'Frequency (rad/day)'
   t = text(0.2,0.001,'$\lambda_{IV}$',/data,orientation=90,font_size=16)
   t = text(1.08,0.001,'$\lambda_{Io}$',/data,orientation=90,font_size=14)
   t = text(5.8,0.95,'S$^{+}$',/normal,font_size=18)
   t.Save,'fft.pdf'
video.cleanup
xinteranimate,/keep_pixmaps

end

