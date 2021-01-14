#packingoutline.pyx
#makes png with outline of nxn ponting packing
import numpy as np
cimport numpy as np
from scipy import misc
DEF N=1401
DEF IMX=1280
DEF IMY=720
DEF MARGIN=5
DEF A=(N+1)/2
DEF E=(N-1)/2
DEF NSQUARED=N*N
DEF TOPLEFTSQ=(NSQUARED+1)/2 
cdef struct pt:
	long int x,y
cdef pt d[(N+E)*4+1] 
cdef pt Largest,Smallest
cdef long int x, y,count=0 
Largest=[-1000000, -1000000]
Smallest=[1000000,1000000]

cdef AddPoint(long int a, long int b):
	global x,y,count
	x+=a
	y+=b
	d[count]=[x,y]
	count+=1

cdef DoTop(): #from left to right and continuing around shape clockwise...
	cdef long int i, currentGroup1=TOPLEFTSQ, currentGroup2=NSQUARED-N+1
	Smallest.x=x #0 probably
	AddPoint(0,0)
	AddPoint(currentGroup1,0)
	for i in xrange(E):
		AddPoint(0,-(currentGroup2-currentGroup1))
		AddPoint(currentGroup2,0)
		currentGroup1-=1
		AddPoint(currentGroup1,0)
		currentGroup2-=N
	Smallest.y=y #i.e. the right edge of top side will be the highest point.

cdef DoRight():
	cdef long int i, currentGroup1=TOPLEFTSQ-E, currentGroup2=TOPLEFTSQ+1
	AddPoint(0,currentGroup1)
	for i in xrange(E):
		AddPoint(currentGroup2-currentGroup1,0)
		AddPoint(0,currentGroup2)
		currentGroup1-=N
		AddPoint(0,currentGroup1)
		currentGroup2+=1
	Largest.x=x

cdef DoBottom():
	cdef long int i, currentGroup1=1, currentGroup2=TOPLEFTSQ+N
	AddPoint(-currentGroup1,0)
	for i in xrange(E):
		AddPoint(0,(currentGroup2-currentGroup1))
		AddPoint(-currentGroup2,0)
		currentGroup1+=1
		AddPoint(-currentGroup1,0)
		currentGroup2+=N
	Largest.y=y

cdef DoLeft():
	cdef long int i, currentGroup1=A, currentGroup2=NSQUARED
	AddPoint(0,-currentGroup1)
	for i in xrange(E):
		AddPoint(-(currentGroup2-currentGroup1),0)
		AddPoint(0,-currentGroup2)
		currentGroup1+=N
		AddPoint(0,-currentGroup1)
		currentGroup2-=1
	
cdef RescalePoints():
	cdef float xscale, yscale,scale,xx, yy
	xscale=float(IMX-2*MARGIN)/float(Largest.x-Smallest.x)
	yscale=float(IMY-2*MARGIN)/float(Largest.y-Smallest.y)
	if xscale<yscale:
		scale=xscale
	else:
		scale=yscale
	print "scales:",xscale,yscale,scale
	print Smallest.x,Largest.x,Smallest.y,Largest.y
	print count
	for i in xrange(count):
		xx=(d[i].x-Smallest.x)*scale+MARGIN
		yy=(d[i].y-Smallest.y)*scale+MARGIN
		d[i]=[<int>xx,<int>yy]

cpdef OK():
	global x,y
	cdef int i,j
	cdef np.ndarray[np.uint8_t,ndim = 3] pic = np.zeros((IMY,IMX,3),dtype = np.uint8)
	x=0
	y=0
	DoTop()
	DoRight()
	DoBottom()
	DoLeft()
	RescalePoints()
	for i in xrange(count-1):
		if d[i].x!=d[i+1].x: #horizontal line
			if d[i].x<d[i+1].x:#goes to right
				for j in xrange(d[i].x,d[i+1].x+1):
					pic[d[i].y,j]=[255,255,255]
			else:#to left
				for j in xrange(d[i+1].x,d[i].x+1):
					pic[d[i].y,j]=[255,255,255]
		else: #vertical line
			if d[i].y<d[i+1].y:#goes down
				for j in xrange(d[i].y,d[i+1].y+1):
					pic[j,d[i].x]=[255,255,255]
			else:#up
				for j in xrange(d[i+1].y,d[i].y+1):
					pic[j,d[i].x]=[255,255,255]
	fn="%sx%s-sq-packing.png" % (N,N)
	misc.imsave(fn,pic)