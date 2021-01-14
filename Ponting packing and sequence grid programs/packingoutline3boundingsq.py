#packingoutline3.py
#print width,height,formula
X = 0
Y = 1

def AddPoint(deltaX, deltaY):
	global currentPoint
	currentPoint = [currentPoint[X]+deltaX,currentPoint[Y]+deltaY]
	#print currentPoint
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
	
for N in xrange(3,101,2):
	A = (N+1)/2
	E = (N-1)/2
	TOPLEFTSQSIZE = (N*N+1)/2 
	d = []
	Largest = [-1000000,-1000000]
	Smallest = [1000000,1000000]
	currentPoint = [0,0]
	DoTopSide()
	DoRightSide()
	DoBottomSide()
	DoLeftSide()
	wid=(N*(3*N*N-2*N+3))/4
	print N,Largest[X]-Smallest[X],Largest[Y]-Smallest[Y],wid
