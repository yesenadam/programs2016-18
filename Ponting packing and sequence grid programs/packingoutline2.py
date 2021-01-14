#packingoutline2.py
#makes png with outline of nxn ponting packing
import numpy as np
from scipy import misc
N = 1001 #700001
fn = "/Users/admin/%dx%d-sq-packing.png" % (N,N) #change path for your computer
imageWidth = 1280
imageHeight = 720
MARGIN = 5
A = (N+1)/2
E = (N-1)/2
TOPLEFTSQSIZE = (N*N+1)/2 
X = 0
Y = 1
d = []
Largest = [-1000000,-1000000]
Smallest = [1000000,1000000]

def AddPoint(deltaX, deltaY):
	global currentPoint
	currentPoint = [currentPoint[X]+deltaX,currentPoint[Y]+deltaY]
	d.append(currentPoint)

def DoTopSide(): #from left to right
	currentGroup1SquareSize = TOPLEFTSQSIZE
	currentGroup2SquareSize = N*N-N+1
	Smallest[X] = currentPoint[X]
	AddPoint(0,0)
	AddPoint(currentGroup1SquareSize,0)
	for i in xrange(E):
		AddPoint(0,currentGroup1SquareSize-currentGroup2SquareSize)
		AddPoint(currentGroup2SquareSize,0)
		currentGroup1SquareSize -= 1
		AddPoint(currentGroup1SquareSize,0)
		currentGroup2SquareSize -= N
	Smallest[Y] = currentPoint[Y] #i.e. the right edge of top side will be the highest point.

def DoRightSide(): #continue around shape clockwise
	currentGroup1SquareSize = TOPLEFTSQSIZE-E
	currentGroup2SquareSize = TOPLEFTSQSIZE+1
	AddPoint(0,currentGroup1SquareSize)
	for i in xrange(E):
		AddPoint(currentGroup2SquareSize-currentGroup1SquareSize,0)
		AddPoint(0,currentGroup2SquareSize)
		currentGroup1SquareSize -= N
		AddPoint(0,currentGroup1SquareSize)
		currentGroup2SquareSize += 1
	Largest[X] = currentPoint[X]

def DoBottomSide():
	currentGroup1SquareSize = 1
	currentGroup2SquareSize = TOPLEFTSQSIZE+N
	AddPoint(-currentGroup1SquareSize,0)
	for i in xrange(E):
		AddPoint(0,currentGroup2SquareSize-currentGroup1SquareSize)
		AddPoint(-currentGroup2SquareSize,0)
		currentGroup1SquareSize += 1
		AddPoint(-currentGroup1SquareSize,0)
		currentGroup2SquareSize += N
	Largest[Y] = currentPoint[Y]

def DoLeftSide():
	currentGroup1SquareSize = A
	currentGroup2SquareSize = N*N
	AddPoint(0,-currentGroup1SquareSize)
	for i in xrange(E):
		AddPoint(currentGroup1SquareSize-currentGroup2SquareSize,0)
		AddPoint(0,-currentGroup2SquareSize)
		currentGroup1SquareSize += N
		AddPoint(0,-currentGroup1SquareSize)
		currentGroup2SquareSize -= 1
	
def RescalePoints():
	xscale = float(imageWidth-2*MARGIN)/float(Largest[X]-Smallest[X])
	yscale = float(imageHeight-2*MARGIN)/float(Largest[Y]-Smallest[Y])
	if xscale < yscale:
		scale = xscale
	else:
		scale = yscale
	for i in xrange(len(d)):
		xx = (d[i][X]-Smallest[X])*scale+MARGIN
		yy = (d[i][Y]-Smallest[Y])*scale+MARGIN
		d[i] = [int(xx),int(yy)]

pic = np.zeros((imageHeight,imageWidth,3),dtype = np.uint8)
currentPoint = [0,0]
DoTopSide()
DoRightSide()
DoBottomSide()
DoLeftSide()
RescalePoints()
for i in xrange(len(d)-1):
	if d[i][X] != d[i+1][X]: #horizontal line
		if d[i][X] < d[i+1][X]: #goes to right
			for j in xrange(d[i][X],d[i+1][X]+1):
				pic[d[i][Y],j,:] = 255
		else:#to left
			for j in xrange(d[i+1][X],d[i][X]+1):
				pic[d[i][Y],j,:] = 255
	else: #vertical line
		if d[i][Y] < d[i+1][Y]: #goes down
			for j in xrange(d[i][Y],d[i+1][Y]+1):
				pic[j,d[i][X],:] = 255
		else:#up
			for j in xrange(d[i+1][Y],d[i][Y]+1):
				pic[j,d[i][X],:] = 255
misc.imsave(fn,pic)