#bezier4tic.pyx
DEF MAXPTS = 5
DEF WID=1280
DEF HEI = 720
DEF STEPS=500
import numpy as np
cimport numpy as np
from scipy import misc
from libc.math cimport fabs,round
cdef struct pt:
	float x,y
cdef struct rgb:
	int col[3]
cdef pt P[MAXPTS]
cdef int cimg[WID][HEI][3]
cdef rgb white,green, blue, red, rg, gb
white.col[:]=[255,255,255]
green.col[:]=[0,255,20]
red.col[:]=[255,60,60]
blue.col[:]=[60,60,255]
rg.col[:]=[255,255,0]
gb.col[:]=[0,255,255]
P[0]=[400,620]
P[1]=[50,130]
P[2]=[600,50]
P[3]=[880,670]
P[4]=[1230,120]


cdef void Set(int x,int y, rgb r) nogil:
	cdef int c
	if x<0 or x>WID-1 or y<0 or y>HEI-1:
		return
	for c in xrange(3):
		cimg[x][HEI-1-y][c]=r.col[c] #upside down!! (y=0 is the top)
		
cdef void fSet(pt P, rgb r) nogil: #draw nearest pixel to floating point
	cdef int c, x=rnd(P.x),y=rnd(P.y)
	if x<0 or x>WID-1 or y<0 or y>HEI-1:
		return
	for c in xrange(3):
		cimg[x][HEI-1-y][c]=r.col[c] #upside down!! (y=0 is the top)

cdef void SetMore(int x,int y, rgb r) nogil: #blends with existing colour, makes lighter..
#but how to draw dark!
	cdef int c,lev
	if x<0 or x>WID-1 or y<0 or y>HEI-1:
		return
	for c in xrange(3):
		lev=cimg[x][HEI-1-y][c]+r.col[c]
		if lev>255:
			lev=255
		cimg[x][HEI-1-y][c]=lev #upside down!! (y=0 is the top)

cdef int rnd(float f) nogil:
	return int(round(f))

cdef rgb colourFract(float f,rgb c):
	#where 0<=f<=1
	cdef rgb r
	cdef int i
	cdef float fc
	if f<0 or f>1:
		print "ERROR!"
		return r
	for i in xrange(3):
		fc=f*float(c.col[i])
		r.col[i]=rnd(fc)
	return r
	
cdef void Plot(pt M, pt N, rgb colour):#int a, int b, int c, int d):
	cdef int i, inc, lower, higher
	cdef float a=M.x, b=M.y, c=N.x, d=N.y
	cdef float ratio,finc, ldist, hdist
	if a==c:
		if b==d:
			return
		if d>b:
			inc=1
		else:
			inc=-1
		for i in xrange(rnd(b),rnd(d+1),inc): #uh this might work if b and d are very close!
			SetMore(rnd(a),i,colour)
	if b==d:
		if c>a:
			inc=1
		else:
			inc=-1
		for i in xrange(rnd(a),rnd(c+1),inc): #mut. mut.
			SetMore(i,rnd(b),colour)
	if fabs(d-b)>=fabs(a-c):
		if d>b:
			inc=1
		else:
			inc=-1
		ratio=(c-a)/(d-b)
		for i in xrange(rnd(b),rnd(d+1),inc):
			finc=ratio*(i-b)
			lower=int(a+finc)
			higher=lower+1
			ldist=fabs(a+finc-lower)
			hdist=fabs(a+finc-higher) #are not these always adding to 1?!
			#so the smaller dist gets larger fract : swap
			SetMore(lower,i,colourFract(hdist,colour))
			SetMore(higher,i,colourFract(ldist,colour))
			
	else:
		if c>a:
			inc=1
		else:
			inc=-1
		ratio=(d-b)/(c-a)
		for i in xrange(rnd(a),rnd(c+1),inc):
#			finc=ratio*(i-a)
#			Set(i,rnd(b+finc),colour)
			finc=ratio*(i-a)
			lower=int(b+finc)
			higher=lower+1
			ldist=fabs(b+finc-lower)
			hdist=fabs(b+finc-higher) #are not these always adding to 1?!
			#so the smaller dist gets larger fract : swap
			SetMore(i,lower,colourFract(hdist,colour))
			SetMore(i,higher,colourFract(ldist,colour))

cdef pt deCast(float t,pt A, pt B):
	return [(1-t)*A.x+t*B.x,(1-t)*A.y+t*B.y]	

cpdef OK():
	cdef int i,j,k,col,loops
	cdef float t, paraminc=1/float(STEPS)
	cdef np.ndarray[np.uint8_t, ndim = 3] img
	cdef pt P01[STEPS],P12[STEPS],P23[STEPS], P34[STEPS], pp
	cdef pt P012[STEPS],P123[STEPS], P234[STEPS]
	cdef pt P0123[STEPS],P1234[STEPS],B[STEPS]
	#draw a movie of this... store the prev Bez points in array, draw them all in each frame..
	#in another colour.
	#just do frame somewhere in middle first to test.
	for loops in xrange(STEPS):
		for i in xrange(WID):
			for j in xrange(HEI):
				for col in xrange(3):
					cimg[i][j][col]=0
		img = np.zeros([HEI,WID,3],dtype=np.uint8)
		t=float(loops)/float(STEPS)
		for i in xrange(MAXPTS-1):
			Plot(P[i],P[i+1],white)
		P01[loops]=deCast(t,P[0],P[1])
		P12[loops]=deCast(t,P[1],P[2])
		P23[loops]=deCast(t,P[2],P[3])
		P34[loops]=deCast(t,P[3],P[4])
		
		P012[loops]=deCast(t,P01[loops],P12[loops])
		P123[loops]=deCast(t,P12[loops],P23[loops])
		P234[loops]=deCast(t,P23[loops],P34[loops])

		P0123[loops]=deCast(t,P012[loops],P123[loops])
		P1234[loops]=deCast(t,P123[loops],P234[loops])

		B[loops]=deCast(t,P0123[loops],P1234[loops])
		Plot(P01[loops],P12[loops],red)
		Plot(P12[loops],P23[loops],green)
		Plot(P23[loops],P34[loops],blue)
		Plot(P012[loops],P123[loops],rg)
		Plot(P123[loops],P234[loops],gb)
		Plot(P0123[loops],P1234[loops],white)
		#bottom-level line ends
		for i in xrange(-2,3):
			for j in xrange(-2,3):
				fSet([P01[loops].x+i,P01[loops].y+j],red)
				fSet([P12[loops].x+i,P12[loops].y+j],green)
				fSet([P23[loops].x+i,P23[loops].y+j],green)
				fSet([P34[loops].x+i,P34[loops].y+j],blue)

		#draw all the curve points
		for k in xrange(loops):
			for i in xrange(0,2):
				for j in xrange(0,2):
					fSet([P012[k].x+i,P012[k].y+j],red)
					fSet([P123[k].x+i,P123[k].y+j],green)
					fSet([P234[k].x+i,P234[k].y+j],blue)
		for k in xrange(loops):
			for i in xrange(-1,3):
				for j in xrange(-1,3):
					fSet([P0123[k].x+i,P0123[k].y+j],rg)
					fSet([P1234[k].x+i,P1234[k].y+j],gb)
		for k in xrange(loops):
			for i in xrange(-2,4):
				for j in xrange(-2,4):
					fSet([B[k].x+i,B[k].y+j],white)
		#current bigger
		for i in xrange(-3,4):
			for j in xrange(-3,4):
				fSet([P012[loops].x+i,P012[loops].y+j],red)
				fSet([P123[loops].x+i,P123[loops].y+j],green)
				fSet([P234[loops].x+i,P234[loops].y+j],blue)
				fSet([P0123[loops].x+i,P0123[loops].y+j],rg)
				fSet([P1234[loops].x+i,P1234[loops].y+j],gb)
				fSet([B[loops].x+i,B[loops].y+j],white)
		for i in xrange(WID):
			for j in xrange(HEI):
				for col in xrange(3):
					img[j,i,col]=cimg[i][j][col]
		print loops
		fn="/Users/admin/bezier/bezier-%05d.png" % loops			
		misc.imsave(fn,img)
