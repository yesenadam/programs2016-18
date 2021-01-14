#bezier.pyx
DEF MAXPTS = 4
DEF WID=1280
DEF HEI = 720
DEF STEPS=500
import numpy as np
cimport numpy as np
from scipy import misc
from libc.math cimport sqrt,sin,cos,atan,fabs,fmod,round
cdef struct pt:
	float x,y
cdef struct rgb:
	int col[3]
cdef pt P[MAXPTS]
cdef int cimg[WID][HEI][3]
cdef rgb white,green, blue, red
white.col[:]=[255,255,255]
green.col[:]=[0,255,20]
red.col[:]=[255,60,60]
blue.col[:]=[60,60,255]
P[0]=[100,100]
P[1]=[400,560]
P[2]=[800,230]
P[3]=[1180,620]


cdef void Set(int x,int y, rgb r) nogil:
	cdef int c
	if x<0 or x>WID-1 or y<0 or y>HEI-1:
		return
	for c in xrange(3):
		cimg[x][HEI-1-y][c]=r.col[c] #upside down!! (y=0 is the top)
		
cdef void fSet(pt P, rgb r) nogil:
	cdef int c, x=rnd(P.x),y=rnd(P.y)
	if x<0 or x>WID-1 or y<0 or y>HEI-1:
		return
	for c in xrange(3):
		cimg[x][HEI-1-y][c]=r.col[c] #upside down!! (y=0 is the top)

cdef void SetMore(int x,int y, rgb r) nogil:
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
	
cdef void Plot(pt M, pt N):#int a, int b, int c, int d):
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
			Set(rnd(a),i,white)
	if b==d:
		if c>a:
			inc=1
		else:
			inc=-1
		for i in xrange(rnd(a),rnd(c+1),inc): #mut. mut.
			Set(i,rnd(b),white)
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
			SetMore(lower,i,colourFract(hdist,white))
			SetMore(higher,i,colourFract(ldist,white))
			
	else:
		if c>a:
			inc=1
		else:
			inc=-1
		ratio=(d-b)/(c-a)
		for i in xrange(rnd(a),rnd(c+1),inc):
#			finc=ratio*(i-a)
#			Set(i,rnd(b+finc),white)
			finc=ratio*(i-a)
			lower=int(b+finc)
			higher=lower+1
			ldist=fabs(b+finc-lower)
			hdist=fabs(b+finc-higher) #are not these always adding to 1?!
			#so the smaller dist gets larger fract : swap
			SetMore(i,lower,colourFract(hdist,white))
			SetMore(i,higher,colourFract(ldist,white))

cdef pt deCast(float t,pt A, pt B):
	return [(1-t)*A.x+t*B.x,(1-t)*A.y+t*B.y]	

cpdef OK():
	cdef int i,j,k,col,loops
	cdef float t, paraminc=1/float(STEPS)
	cdef np.ndarray[np.uint8_t, ndim = 3] img
	cdef pt P01[STEPS],P12[STEPS],P23[STEPS], pp
	cdef pt P012[STEPS],P123[STEPS], B[STEPS]
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
			Plot(P[i],P[i+1])
		P01[loops]=deCast(t,P[0],P[1])
		P12[loops]=deCast(t,P[1],P[2])
		P23[loops]=deCast(t,P[2],P[3])
		
		P012[loops]=deCast(t,P01[loops],P12[loops])
		P123[loops]=deCast(t,P12[loops],P23[loops])
		B[loops]=deCast(t,P012[loops],P123[loops])
		Plot(P01[loops],P12[loops])
		Plot(P12[loops],P23[loops])
		Plot(P012[loops],P123[loops])
		#draw all the curve points
		for k in xrange(loops):
			for i in xrange(-1,2):
				for j in xrange(-1,2):
					fSet([B[k].x+i,B[k].y+j],green)
			fSet([P012[k].x,P012[k].y],red)
			fSet([P123[k].x,P123[k].y],blue)
		#current bigger
		for i in xrange(-3,4):
			for j in xrange(-3,4):
				fSet([B[loops].x+i,B[loops].y+j],green)
		for i in xrange(-2,3):
			for j in xrange(-2,3):
				fSet([P012[loops].x+i,P012[loops].y+j],red)
				fSet([P123[loops].x+i,P123[loops].y+j],blue)
		for i in xrange(WID):
			for j in xrange(HEI):
				for col in xrange(3):
					img[j,i,col]=cimg[i][j][col]
		print loops,
		fn="/Users/admin/bezier/bezier-%05d.png" % loops			
		misc.imsave(fn,img)
