# cython: boundscheck=False,cdivision=True
#ventrella.pyx
#to do Ventrella-type Koch-ish fractals.
DEF PI=3.141592653
DEF WID=2500#1280
DEF HEI=1840#920#720
DEF MAXLEVEL=4
DEF NUMSEGS=4
DEF INITSIZE=2
#graphics consts
DEF MULT=500#250.0
DEF XOFF=700#350
DEF YOFF=600#300#200
import numpy as np
cimport numpy as np
from scipy import misc
from libc.math cimport sqrt,sin,cos,atan,fabs,fmod

cdef:
	struct segment_info:
		float theta, len
		int DIRFLIP, SIDEFLIP
	segment_info seg[NUMSEGS]
	struct pt:
		float x,y
	pt START, END
	int cimg[WID][HEI][3]
START=[0,0]
END=[INITSIZE,0]
seg[0]=[atan(0.5),sqrt(5.0)/4,0,0]
seg[1]=[PI/2,0.3,1,0]
seg[2]=[0,0.5,0,0]
seg[3]=[3*PI/2.0,0.5,0,1]

cdef void Set(int x,int y):
	cdef int c
	if x<0 or x>WID-1 or y<0 or y>HEI-1:
#		print "ERROR!",
		return
	for c in xrange(3):
		cimg[x][HEI-1-y][c]=255 #white on black #upside down!! (y=0 is the top)

cdef Plot(pt S, pt E):
	cdef float i,length,dx,dy,xstep,ystep
	cdef int ilen
	S=[S.x*MULT+XOFF,S.y*MULT+YOFF]
	E=[E.x*MULT+XOFF,E.y*MULT+YOFF]
	dy=E.y-S.y
	dx=E.x-S.x
	length=sqrt(dy*dy+dx*dx)
	xstep=dx/length
	ystep=dy/length
	ilen=int(length)
	for i in xrange(ilen+1):
		Set(int(S.x+i*xstep),int(S.y+i*ystep))

cdef float Modded(float ang): #puts angle between 0 and 2*PI
	return fmod(ang+2*PI,2*PI)

cdef float reverseIfNotInRange(float angle,float minval, float maxval):
	cdef float mAngle=Modded(angle)
	if mAngle>minval and mAngle<maxval:
		return mAngle
	else:
		return Modded(angle+PI)
		
cdef DrawSeg(pt Start, pt End, int level, float size, int SFLIP):
	cdef pt S,E,oldE,temp
	cdef float initAngle, mAngle
	cdef int flip
	if SFLIP==1:
		flip=-1
	else:
		flip=1
	if fabs(End.y-Start.y)<0.0001:
		End.y=Start.y
	if fabs(End.x-Start.x)<0.0001:
		End.x=Start.x

	if fabs(End.x-Start.x)<0.0001: #vertical
		if Start.y<End.y: #(up)
			initAngle=PI/2.0
		else:
			initAngle=3*PI/2.0 #down
	elif fabs(End.y-Start.y)<0.0001: #horizontal
		if Start.x<End.x: #(right)
			initAngle=0
		else:
			initAngle=PI #left
	else:
		initAngle=Modded(atan((End.y-Start.y)/(End.x-Start.x))) #not if denom=0
	if End.y>Start.y:
		if End.x>Start.x: #Q1, #so angle should be between 0 and PI/2 etc
			initAngle=reverseIfNotInRange(initAngle,0,PI/2)
		elif End.x<Start.x: #Q2
			initAngle=reverseIfNotInRange(initAngle,PI/2,PI)
	elif End.y<Start.y:
		if End.x<Start.x: #Q3
			initAngle=reverseIfNotInRange(initAngle,PI,1.5*PI)
		elif End.x>Start.x: #Q4
			initAngle=reverseIfNotInRange(initAngle,1.5*PI,2*PI)
	if level==MAXLEVEL:
		Plot(Start,End)
		return
	for i in xrange(NUMSEGS):
		if i==0:
			S=Start #NB first get it working without the flips.
			E=[S.x+size*seg[0].len*cos(initAngle+flip*seg[0].theta),
			S.y+size*seg[0].len*sin(initAngle+flip*seg[0].theta)]
			oldE=E
		else:
			S=oldE
			if i==NUMSEGS-1:
				E=End
			else:
				E=[S.x+size*seg[i].len*cos(initAngle+flip*seg[i].theta),
				S.y+size*seg[i].len*sin(initAngle+flip*seg[i].theta)]
				oldE=E
		if seg[i].DIRFLIP==1:
			temp=S
			S=E
			E=temp
		DrawSeg(S,E,level+1,size*seg[i].len,seg[i].SIDEFLIP)
			
cpdef OK():
	cdef int i,j,col
	cdef np.ndarray[np.uint8_t, ndim = 3] img
	img = np.zeros([HEI,WID,3],dtype=np.uint8)
	DrawSeg(START,END,0,INITSIZE,0) #ie init segment len is 2
	for i in xrange(WID):
		for j in xrange(HEI):
			for col in xrange(3):
				img[j,i,col]=cimg[i][j][col]
	misc.imsave("/Users/admin/ventrella.png",img)
