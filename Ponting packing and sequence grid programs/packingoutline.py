#packingoutline.py
#makes png with outline of nxn ponting packing
import numpy as np
from scipy import misc
N=100001
IMX=1280
IMY=720
MARGIN=5
A=(N+1)/2
E=(N-1)/2
NSQUARED=N*N
TOPLEFTSQ=(NSQUARED+1)/2 
dx=[]
dy=[]
Largestx=-1000000
Largesty=-1000000
Smallestx=1000000
Smallesty=1000000

def AddPoint(a, b):
	global x,y#,count
	x+=a
	y+=b
	dx.append(x)
	dy.append(y)#)d[count]=[x,y]

def DoTop(): #from left to right and continuing around shape clockwise...
	global Smallestx, Smallesty
	currentGroup1=TOPLEFTSQ
	currentGroup2=NSQUARED-N+1
	Smallestx=x #0 probably
	AddPoint(0,0)
	AddPoint(currentGroup1,0)
	for i in xrange(E):
		AddPoint(0,-(currentGroup2-currentGroup1))
		AddPoint(currentGroup2,0)
		currentGroup1-=1
		AddPoint(currentGroup1,0)
		currentGroup2-=N
	Smallesty=y #i.e. the right edge of top side will be the highest point.

def DoRight():
	global Largestx
	currentGroup1=TOPLEFTSQ-E
	currentGroup2=TOPLEFTSQ+1
	AddPoint(0,currentGroup1)
	for i in xrange(E):
		AddPoint(currentGroup2-currentGroup1,0)
		AddPoint(0,currentGroup2)
		currentGroup1-=N
		AddPoint(0,currentGroup1)
		currentGroup2+=1
	Largestx=x

def DoBottom():
	global Largesty
	currentGroup1=1
	currentGroup2=TOPLEFTSQ+N
	AddPoint(-currentGroup1,0)
	for i in xrange(E):
		AddPoint(0,(currentGroup2-currentGroup1))
		AddPoint(-currentGroup2,0)
		currentGroup1+=1
		AddPoint(-currentGroup1,0)
		currentGroup2+=N
	Largesty=y

def DoLeft():
	currentGroup1=A
	currentGroup2=NSQUARED
	AddPoint(0,-currentGroup1)
	for i in xrange(E):
		AddPoint(-(currentGroup2-currentGroup1),0)
		AddPoint(0,-currentGroup2)
		currentGroup1+=N
		AddPoint(0,-currentGroup1)
		currentGroup2-=1
	
def RescalePoints():
	#cdef float xscale, yscale,scale,xx, yy
	xscale=float(IMX-2*MARGIN)/float(Largestx-Smallestx)
	yscale=float(IMY-2*MARGIN)/float(Largesty-Smallesty)
	if xscale<yscale:
		scale=xscale
	else:
		scale=yscale
#	print "scales:",xscale,yscale,scale
#	print Smallestx,Largestx,Smallesty,Largesty
#	print count
	for i in xrange(len(dx)):
		xx=(dx[i]-Smallestx)*scale+MARGIN
		yy=(dy[i]-Smallesty)*scale+MARGIN
		dx[i]=int(xx)
		dy[i]=int(yy)

pic = np.zeros((IMY,IMX,3),dtype = np.uint8)
x=0
y=0
DoTop()
DoRight()
DoBottom()
DoLeft()
RescalePoints()
for i in xrange(len(dx)-1):
	if dx[i]!=dx[i+1]: #horizontal line
		if dx[i]<dx[i+1]:#goes to right
			for j in xrange(dx[i],dx[i+1]+1):
				pic[dy[i],j]=[255,255,255]
		else:#to left
			for j in xrange(dx[i+1],dx[i]+1):
				pic[dy[i],j]=[255,255,255]
	else: #vertical line
		if dy[i]<dy[i+1]:#goes down
			for j in xrange(dy[i],dy[i+1]+1):
				pic[j,dx[i]]=[255,255,255]
		else:#up
			for j in xrange(dy[i+1],dy[i]+1):
				pic[j,dx[i]]=[255,255,255]
fn="/Users/admin/%dx%d-sq-packing.png" % (N,N)
misc.imsave(fn,pic)