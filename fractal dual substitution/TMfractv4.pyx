#%cython
#TMfract.pyx - Thue-Morse 2D tiling fractal
#from N Frank paper "Fractal Dual Substitution Tilings" p3
import numpy as np
cimport numpy as np
from scipy import misc
DEF MAXPTS=10000 #30000 #10000 #20000
DEF MAXLEV=4 #5 #4 #5
DEF ARRAYWID=600 #2400 #600 #2400
DEF HALF=ARRAYWID/2
DEF MARG=20
DEF COLOURS=2 #White, Blue
DEF DIRECTIONS=4 #Top, Right, Bottom, Left
DEF MAXPATHSEGS=10 #current max=7 
DEF GRIDSIDE=4
cdef:
	enum:
		T=0, R=1, B=2, L=3 #type
		Wh=0,Bl=1	#subcol
	struct pt:
		int x,y
	pt z, C[COLOURS][MAXPTS] #C[0]=white pixels, C[1]=blue
	int tot[COLOURS] #total num of white, blue pixels stored so far
	int numrules[COLOURS][DIRECTIONS] #stores num of steps in each subpath
	struct pa:
		int sc,ty
		pt lo
	pa path[COLOURS][DIRECTIONS][MAXPATHSEGS]
	int Done(int col,pt d,int lev):
		if lev==MAXLEV:
			C[col][tot[col]]=d #add point to end of list of pts
			tot[col]+=1
			return 1 # i.e. otherwise return 0
numrules[Wh][:]=[9,7,3,5] #White T,R,B,L path lengths
numrules[Bl][:]=[7,5,5,7] #Blue   "
# *** the colour name isnt needed here, can be worked out by prog
# so maybe make 'sc' separate to the 'pa' struct, so it
#doesnt have to be specified here.
#HMM but then how to say e.g. path[Wh][T]=?!?!?!

#also add bit that puts the lil drawing of the path map on the pic, at top.
path[Wh][T][0:9]=[[Bl,T,[1,0]],[Bl,L,[1,0]],[Wh,R,[0,0]],
	[Wh,B,[0,0]],[Bl,T,[0,1]],[Bl,B,[0,1]],[Bl,T,[0,2]],
	[Bl,R,[0,2]],[Wh,L,[1,2]]]
path[Wh][R][0:7]=[[Wh,R,[1,2]],[Wh,L,[2,2]],[Wh,R,[2,2]],
	[Bl,L,[3,2]],[Bl,T,[3,2]],[Bl,B,[3,1]],[Bl,R,[3,1]]]
path[Wh][B][0:3]=[[Wh,B,[1,2]],[Bl,T,[1,3]],[Bl,B,[1,3]]]
path[Wh][L][0:5]=[[Bl,L,[0,1]],[Bl,R,[0,1]],[Wh,L,[1,1]],
	[Wh,B,[1,1]],[Wh,T,[1,2]]]
path[Bl][T][0:7]=[[Wh,T,[1,0]],[Wh,R,[1,0]],[Wh,L,[2,0]],
	[Wh,B,[2,0]],[Bl,T,[2,1]],[Bl,B,[2,1]],[Bl,T,[2,2]]]
path[Bl][R][0:5]=[[Bl,R,[2,2]],[Wh,L,[3,2]],[Wh,T,[3,2]],
	[Wh,B,[3,1]],[Wh,R,[3,1]]]
path[Bl][B][0:5]=[[Bl,B,[2,2]],[Wh,T,[2,3]],[Wh,L,[2,3]],
	[Wh,R,[1,3]],[Wh,B,[1,3]]]
path[Bl][L][0:7]=[[Wh,L,[0,1]],[Wh,R,[0,1]],[Bl,L,[1,1]],
	[Bl,B,[1,1]],[Bl,T,[1,2]],[Bl,R,[1,2]],[Bl,L,[2,2]]]
cdef Do(int subcol, type, col,pt loc, pt s,int lev):
	#subcolour, type, colour, location(x,y), sublocation(x,y),level
	# 'col' never changes. 'subcol' is current colour.
	cdef int n
	s=[loc.x*GRIDSIDE+s.x,loc.y*GRIDSIDE+s.y]
	if not Done(col,s,lev):
		for n in xrange(numrules[subcol][type]):
			Do(path[subcol][type][n].sc,path[subcol][type][n].ty,
				col,s,path[subcol][type][n].lo,lev+1)
cpdef OK():
	cdef:
		int i, j, k, side=GRIDSIDE**MAXLEV
		np.ndarray[np.uint8_t,ndim=3] a=np.empty((HALF,ARRAYWID,3),dtype=np.uint8)
	tot[:]=[0,0]
	z.x=0
	z.y=0
	for k in xrange(COLOURS): #White, Blue
		for j in xrange(DIRECTIONS): #T,R,B,L
			Do(k,j,k,z,z,0)
	for k in xrange(3): #make image white
		for j in xrange(ARRAYWID):
			for i in xrange(HALF):
				a[i,j,k]=255
	for i in xrange(side): #blue square
		for k in xrange(side):
			a[MARG+k,MARG+HALF+i]=[50,50,255]
	for j in xrange(COLOURS): #plot fractal points
		for i in xrange(tot[j]): #[0]=white cell, [1]=blue
			a[MARG+C[j][i].y,MARG+C[j][i].x+j*HALF]=[0,0,0] #black
		for i in xrange(side):#black frame around cells
			for k in xrange(COLOURS):
				a[MARG+side*k,MARG+i+j*HALF]=[0,0,0]
				a[MARG+i,MARG+side*k+j*HALF]=[0,0,0]
	misc.imsave('TMfract.png',a)
	print tot[0],tot[1]