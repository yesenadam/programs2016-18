# cython: boundscheck=False,cdivision=True
#ventrellav2.pyx
#to do Ventrella-type Koch-ish fractals.
DEF PI=3.141592653
DEF WID=3000#1280
DEF HEI=2000#920#720
DEF MAXLEVEL=7#7#9
DEF NUMSEGS=4
DEF INITSIZE=2
DEF MULT=650#100#0#1100#.0
DEF XOFF=1000#0#350#1900#
DEF YOFF=700#0#300#1100#200
# DEF WID=3000#1280 #good settings for 2-seg map
# DEF HEI=2000#920#720
# DEF MAXLEVEL=16#7#9
# DEF NUMSEGS=2#5
# DEF INITSIZE=2
# DEF MULT=900#100#0#1100#.0
# DEF XOFF=700#0#350#1900#
# DEF YOFF=1400#0#300#1100#200
import numpy as np
cimport numpy as np
from scipy import misc
from libc.math cimport sqrt,sin,cos,atan,fabs,fmod
cdef:
	struct segment_info:
		float theta, len
		int DIRFLIP # flip direction. 1=swap start and end of segment, 0=no flip
		int SIDEFLIP # -1=multiply angles by -1, 1=no flip
	segment_info map[NUMSEGS]
	struct pt:
		float x,y
	struct line:
		pt start, end
		float size,angle
		int flip
	int cimg[WID][HEI][3]
	pt INITSTART=[0,0], INITEND=[2,0]
	line L=[INITSTART,INITEND,INITSIZE,0,1]
#type P3
# map[0]=[0,0.25,0,0]
# map[1]=[PI/4,sqrt(2.0)/4.0,0,0]
# map[2]=[0,0.25,0,0]
# map[3]=[7*PI/4.0,sqrt(2.0)/4.0,1,0]
#ventrella p117
map[0]=[PI/2,0.5,0,1]
map[1]=[0,0.5,0,1]
map[2]=[3*PI/2,0.5,0,1]
#map[2]=[7*PI/4.0,sqrt(2.0)/4.0,0,-1]
#map[3]=[5*PI/4.0,sqrt(2.0)/4.0,0,1]
#map[3]=[7*PI/4.0,sqrt(2.0)/4.0,1,1]
#map[4]=[PI/4.0,sqrt(2.0)/4.0,1,1]
map[3]=[0,0.5,1,1]
#polya sweep
# map[0]=[7*PI/4,sqrt(2)/2,0,1]
# map[1]=[PI/4,sqrt(2)/2,1,1]
#polya sweep with ang=40 deg not 45
# map[0]=[2*PI-0.6981317,0.6527,0,1]
# map[1]=[0.6981317,0.6527,1,1]

cdef void Set(int x,int y) nogil:
	cdef int c
	if x<0 or x>WID-1 or y<0 or y>HEI-1:
		return
	for c in xrange(3):
		cimg[x][HEI-1-y][c]=255 #white on black #upside down!! (y=0 is the top)

cdef void Plot(line L) nogil:
#very rough! do a better one, with thickness setting:
#find a bounding rect around where the line will go, and set all pixels with distance<=thickness
#from the line.
	cdef float length
	cdef pt delta, step, stepSum
	cdef int i,intlen
	stepSum=[0.5,0.5] #for rounding
	L.start=[L.start.x*MULT+XOFF,L.start.y*MULT+YOFF]
	L.end=[L.end.x*MULT+XOFF,L.end.y*MULT+YOFF]
	delta=[L.end.x-L.start.x,L.end.y-L.start.y]
	length=fabs(delta.x)
	if fabs(delta.y)>length:
		length=fabs(delta.y)
	#length=sqrt(delta.y*delta.y+delta.x*delta.x) #this looks better when tiny
	#as diagonals look as bright as horiz/verticals. But closeup looks so rough/wrong.
	step=[delta.x/length,delta.y/length]
	intlen=int(length)
	for i in xrange(intlen+1):
		Set(int(L.start.x+stepSum.x),int(L.start.y+stepSum.y))
		stepSum=[stepSum.x+step.x,stepSum.y+step.y]
		
cdef float angMod(float ang) nogil: #puts angle between 0 and 2*PI
	return fmod(ang+2*PI,2*PI)

cdef float reverseIfNotInQuadrant(float angle,int quadrant) nogil:
	cdef float minval= (quadrant-1)*PI/2, maxval=quadrant*PI/2
	if angle>minval and angle<maxval:
		return angle
	return angMod(angle+PI)
		
cdef float fixAngle(line L) nogil:
	if L.end.y>L.start.y: 
		if L.end.x>L.start.x: #Q1, #so angle should be between 0 and PI/2 etc
			return reverseIfNotInQuadrant(L.angle,1)
		elif L.end.x<L.start.x: #Q2
			return reverseIfNotInQuadrant(L.angle,2)
	elif L.end.y<L.start.y:
		if L.end.x<L.start.x: #Q3
			return reverseIfNotInQuadrant(L.angle,3)
		elif L.end.x>L.start.x: #Q4
			return reverseIfNotInQuadrant(L.angle,4)
	return L.angle #this line ever used? only if L.start and L.end are same point.
	
cdef pt getEnd(pt start, line L, int i) nogil:
	cdef float th = L.angle+L.flip*map[i].theta, r = L.size*map[i].len
	return [start.x+r*cos(th),start.y+r*sin(th)]

cdef line calcAngle(line L) nogil:
	cdef pt length=[L.end.x-L.start.x,L.end.y-L.start.y]
	if fabs(length.x)<0.0001: #vertical
		L.end.x=L.start.x
		if L.start.y<L.end.y: #(up)
			L.angle=PI/2.0
		else:
			L.angle=3*PI/2.0 #down
	elif fabs(length.y)<0.0001: #horizontal
		L.end.y=L.start.y
		if L.start.x<L.end.x: #(right)
			L.angle=0
		else:
			L.angle=PI #left
	else:
		L.angle=angMod(atan(length.y/length.x))
	return L

cdef void DrawSeg(line L,int level) nogil:
	cdef pt previousEnd,temp
	cdef line N
	L.angle=fixAngle(calcAngle(L))
	if level==MAXLEVEL:
		Plot(L)
		return
	N.start=L.start 
	N.end=getEnd(N.start,L,0)
	previousEnd=N.end
	for i in xrange(NUMSEGS):
		if i>0:
			N.start=previousEnd
			if i==NUMSEGS-1:
				N.end=L.end
			else:
				N.end=getEnd(N.start,L,i)
				previousEnd=N.end
		if map[i].DIRFLIP==1:
			temp=N.start
			N.start=N.end
			N.end=temp
		N.size=L.size*map[i].len
		N.flip=map[i].SIDEFLIP
		DrawSeg(N,level+1)
			
cpdef OK():
	cdef int i,j,col
	cdef np.ndarray[np.uint8_t, ndim = 3] img
	img = np.zeros([HEI,WID,3],dtype=np.uint8)
	DrawSeg(L,0)
	for i in xrange(WID):
		for j in xrange(HEI):
			for col in xrange(3):
				img[j,i,col]=cimg[i][j][col]
	misc.imsave("/Users/admin/ventrella.png",img)
