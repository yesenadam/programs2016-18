#pontingpacking.pyx - v1 - 7 Oct 2017
#prints square sizes and coordinates and makes png image of packing
#NB the coordinates are with y=0 at the top. Subtract each y value from
#N*(3*N*N-2*N+3)/4+2*MARGIN for normal Cartesian coords.
#type OK() to run
import numpy as np
cimport numpy as np
from scipy import misc
DEF N = 15 #makes NxN packing
DEF MARGIN = 5
cdef struct pt:
	int x,y
cdef struct sqinfo:
	pt loc 
	int size
cdef sqinfo Square[N][N]
fn = '/Users/admin/%dx%dpacking.png' % (N,N)
cdef int highest

cdef GetSizes():
	cdef int i,j,count = 1
	#do bottom row
	for i in xrange(N-1,-1,-2): # in C: for (i=N-1;i>-1;i=i-2) {
		Square[i][N-1].size = count
		count += 1
	#rest of rows in pairs
	for j in xrange(N-2,0,-2):
		for i in xrange(N-2,0,-2):
			Square[i][j].size = count
			count += 1
		for i in xrange(N-1,-1,-2):
			Square[i][j-1].size = count
			count += 1
	#do right column
	for j in xrange(1,N-1,2): 
		Square[N-1][j].size = count
		count += 1
	#rest of columns in pairs
	for i in xrange(N-2,0,-2):
		for j in xrange(0,N,2):
			Square[i][j].size = count
			count += 1
		for j in xrange(1,N,2):
			Square[i-1][j].size = count
			count += 1
	
cdef GetPositions():
	global highest
	cdef int i,j
	cdef pt startOfRow,currentPos
	#do top row from left to right
	Square[0][0].loc = [0,0] #i.e. bottom left corner of top left square is at 0,0
	startOfRow = [0,0]
	currentPos = [0,0]
	for i in xrange(1,N-1,2):
		currentPos.x += Square[i-1][0].size
		Square[i][0].loc = currentPos
		currentPos.x += Square[i][0].size
		currentPos.y -= Square[i][0].size-Square[i+1][0].size
		Square[i+1][0].loc = currentPos
	#store highest point, i.e. smallest y value in packing
	#which is top of square at right end of top row
	highest = currentPos.y-Square[i+1][0].size
	#do rest of rows in pairs
	for j in xrange(1,N-1,2):
		startOfRow.y += Square[0][j].size
		Square[0][j].loc = startOfRow
		currentPos = startOfRow
		for i in xrange(1,N-1,2):
			currentPos.x += Square[i-1][j].size
			currentPos.y -= Square[i-1][j].size-Square[i][j].size
			Square[i][j].loc = currentPos
			currentPos.x += Square[i][j].size
			Square[i+1][j].loc = currentPos
		startOfRow.x += Square[0][j].size-Square[0][j+1].size
		startOfRow.y += Square[0][j+1].size
		Square[0][j+1].loc = startOfRow
		currentPos = startOfRow
		for i in xrange(1,N-1,2):
			currentPos.x += Square[i-1][j+1].size
			Square[i][j+1].loc = currentPos
			currentPos.x += Square[i][j+1].size
			currentPos.y -= Square[i][j+1].size-Square[i+1][j+1].size
			Square[i+1][j+1].loc = currentPos

cdef CorrectCoords():
	cdef int i,j
	for j in xrange(N):
		for i in xrange(N):
			Square[i][j].loc.y -= highest-MARGIN #so none are <MARGIN
			Square[i][j].loc.x += MARGIN

cdef PrintSizesAndLocations():
	cdef int i,j
	for j in xrange(N):
		for i in xrange(N):
			print "%3d" % Square[i][j].size,
		print	
	print
	print "Locations of bottom left corners of squares:"
	for j in xrange(N):
		print "Row",j,":",
		for i in xrange(N):
			print "(%d,%d)" % (Square[i][j].loc.x,Square[i][j].loc.y),
		print

cpdef OK():
	cdef int width,i,j,m
	GetSizes()
	GetPositions()
	CorrectCoords()
	width = N*(3*N*N-2*N+3)/4
	cdef int IMWIDTH = width+2*MARGIN
	cdef np.ndarray[np.uint8_t,ndim = 3] pic = np.zeros((IMWIDTH,IMWIDTH,3),dtype = np.uint8)
	print N,"x",N," packing, dimensions =",width,"x",width
	print
	PrintSizesAndLocations()
	print
	for j in xrange(N):
		for i in xrange(N):
			for m in xrange(Square[i][j].size):
				pic[Square[i][j].loc.y,Square[i][j].loc.x+m,:] = 255
				pic[Square[i][j].loc.y-m,Square[i][j].loc.x,:] = 255
				pic[Square[i][j].loc.y-Square[i][j].size,Square[i][j].loc.x+m,:] = 255
				pic[Square[i][j].loc.y-m,Square[i][j].loc.x+Square[i][j].size,:] = 255
	misc.imsave(fn,pic) 