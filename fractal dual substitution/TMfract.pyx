#%cython
#TMfract.pyx - Thue-Morse 2D tiling fractal
#from N Frank paper "Fractal Dual Substitution Tilings" p3
import numpy as np
cimport numpy as np
from scipy import misc
DEF MAXPTS=10000 #30000
DEF MAXLEV=4 #5
DEF ARRAYWID=600 #2400
DEF HALF=ARRAYWID/2
DEF MARG=20
cdef:
	struct pt:
		int x,y
	pt z, C[2][MAXPTS] #C[0]=white pixels, C[1]=blue
	int tot[2] #total num of white, blue pixels stored so far
	int AddPix(int col,pt d,int lev):
		if lev==MAXLEV:
		#TO ADD: first check that pixel isnt already used.
		#or do that at end maybe ## better. 'sort | uniq' the list.
			C[col][tot[col]].x=d.x #add point to end of list of pts
			C[col][tot[col]].y=d.y #add point to end of list of pts
			tot[col]+=1
			return 1 # i.e. otherwise return 0
	WhiteTop(int col,pt loc, pt s,int lev):
			#colour, location(x,y), sublocation(x,y),level
		s=[loc.x*4+s.x,loc.y*4+s.y]
		if not AddPix(col,s,lev):
			BlueTop(col,s,[1,0],lev+1)
			BlueRight(col,s,[1,0],lev+1)
			BlueLeft(col,s,[2,0],lev+1)
			BlueBottom(col,s,[2,0],lev+1)
			WhiteTop(col,s,[2,1],lev+1)
	WhiteRight(int col,pt loc, pt s,int lev):
		s=[loc.x*4+s.x,loc.y*4+s.y]
		if not AddPix(col,s,lev):
			WhiteRight(col,s,[2,1],lev+1)
			BlueLeft(col,s,[3,1],lev+1)
			BlueRight(col,s,[3,1],lev+1)
	WhiteBottom(int col,pt loc, pt s,int lev):
		s=[loc.x*4+s.x,loc.y*4+s.y]
		if not AddPix(col,s,lev):
			WhiteBottom(col,s,[2,1],lev+1)
			WhiteTop(col,s,[2,2],lev+1)
			WhiteBottom(col,s,[2,2],lev+1)
			BlueTop(col,s,[2,3],lev+1)
			BlueLeft(col,s,[2,3],lev+1)
			BlueRight(col,s,[1,3],lev+1)
			BlueBottom(col,s,[1,3],lev+1)
	WhiteLeft(int col,pt loc, pt s,int lev):
		s=[loc.x*4+s.x,loc.y*4+s.y]
		if not AddPix(col,s,lev):
			BlueLeft(col,s,[0,1],lev+1)
			BlueRight(col,s,[0,1],lev+1)
			WhiteLeft(col,s,[1,1],lev+1)
			WhiteRight(col,s,[1,1],lev+1)
			WhiteLeft(col,s,[2,1],lev+1)
	BlueTop(int col,pt loc, pt s,int lev):
		s=[loc.x*4+s.x,loc.y*4+s.y]
		if not AddPix(col,s,lev):
			WhiteTop(col,s,[1,0],lev+1)
			WhiteRight(col,s,[1,0],lev+1)
			WhiteLeft(col,s,[2,0],lev+1)
			WhiteBottom(col,s,[2,0],lev+1)
			BlueTop(col,s,[2,1],lev+1)
			BlueBottom(col,s,[2,1],lev+1)
			BlueTop(col,s,[2,2],lev+1)
	BlueRight(int col,pt loc, pt s,int lev):
		s=[loc.x*4+s.x,loc.y*4+s.y]
		if not AddPix(col,s,lev):
			BlueRight(col,s,[2,2],lev+1)
			WhiteLeft(col,s,[3,2],lev+1)
			WhiteTop(col,s,[3,2],lev+1)
			WhiteBottom(col,s,[3,1],lev+1)
			WhiteRight(col,s,[3,1],lev+1)
	BlueBottom(int col,pt loc, pt s,int lev):
		s=[loc.x*4+s.x,loc.y*4+s.y]
		if not AddPix(col,s,lev):
			BlueBottom(col,s,[2,2],lev+1)
			WhiteTop(col,s,[2,3],lev+1)
			WhiteLeft(col,s,[2,3],lev+1)
			WhiteRight(col,s,[1,3],lev+1)
			WhiteBottom(col,s,[1,3],lev+1)
	BlueLeft(int col,pt loc, pt s,int lev):
		s=[loc.x*4+s.x,loc.y*4+s.y]
		if not AddPix(col,s,lev):
			WhiteLeft(col,s,[0,1],lev+1)
			WhiteRight(col,s,[0,1],lev+1)
			BlueLeft(col,s,[1,1],lev+1)
			BlueBottom(col,s,[1,1],lev+1)
			BlueTop(col,s,[1,2],lev+1)
			BlueRight(col,s,[1,2],lev+1)
			BlueLeft(col,s,[2,2],lev+1)
cpdef OK():
	cdef:
		int q, i, j, k, side=4**MAXLEV
		np.ndarray[np.uint8_t,ndim=3] a=np.empty((HALF,ARRAYWID,3),dtype=np.uint8)
	tot[:]=[0,0]
	z.x=0
	z.y=0
	#White Cell
	WhiteTop(0,z,z,0)
	WhiteRight(0,z,z,0)
	WhiteBottom(0,z,z,0)
	WhiteLeft(0,z,z,0)
	#Blue Cell
	BlueTop(1,z,z,0)
	BlueRight(1,z,z,0)
	BlueBottom(1,z,z,0)
	BlueLeft(1,z,z,0)
	for k in xrange(3):
		for j in xrange(ARRAYWID):
			for i in xrange(HALF):
				a[i,j,k]=255
	for i in xrange(side):
		for k in xrange(side):
			a[MARG+k,MARG+HALF+i]=[50,50,255]
	for j in xrange(2):
		for i in xrange(tot[j]): #[0]=white cell, [1]=blue
			a[MARG+C[j][i].y,MARG+C[j][i].x+j*HALF]=[0,0,0] #black
		for i in xrange(side):
			for q in xrange(2):
				a[MARG+side*q,MARG+i+j*HALF]=[0,0,0]
				a[MARG+i,MARG+side*q+j*HALF]=[0,0,0]
	misc.imsave('TMfract.png',a)
	print tot[0],tot[1]