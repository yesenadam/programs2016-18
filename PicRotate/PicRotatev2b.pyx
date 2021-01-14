#PicRotatev2a
#hopefully, all in 1 go!
import numpy as np
cimport numpy as np
from scipy import misc
DEF p1=2
DEF p2=4
DEF p3=8
DEF p4=16
DEF p5=32
DEF p6=64
DEF p7=128
DEF p8=256
DEF p9=512
struct p:
	int x,y
cdef int b[512][512]
#b stores the position of where to get the pixels for ar in the orig pic. starts off 0,0=0,0, 0,1=0,1 etc
cdef int i,j,k
cdef RotRow(int r):
	#rotate row number r 1 pixel
	
	
cpdef OK():
	cdef int xx,yy,w,v,u
	cdef np.ndarray[np.uint8_t, ndim=3] pic
	cdef np.ndarray[np.uint8_t, ndim=3] a
	cdef int i,j,k,picx,picy
	cdef int x0,x1,x2,x3,x4,x5,x6,x7,x8
	cdef int y0,y1,y2,y3,y4,y5,y6,y7,y8
	cdef int t0,t1,t2,t3,t4,t5,t6,t7,t8
	#cdef int k0,k1,k2,k3,k4,k5,k6,k7,k8
	fn="tiger-09.png" 
	pic=misc.imread(fn)
	xx=pic.shape[0] #beware - it loads pic sidewise, so correct for that
	yy=pic.shape[1]
	a=np.empty((xx,yy,3),dtype=np.uint8)
	a=pic
	int t[3] # temp to store bottom left pixel
	int L
	for w in xrange(200):
		L= 256-w #if row=256,L=0, row=255, L=1
		for i in xrange(3):
			t[i]=a[L][L][i]
		for i in xrange(L,511-L):
			a[L][i]=a[L][i+1]
		#move top across
		for i in xrange(L,511-L):
			a[i][511-L]=a[i+1][511-L]
		#move right up
		for i in xrange(511-L,L,-1):
			a[511-L][i]=a[511-L][i-1]
		#move bottom to right
		for i in xrange(511-L,L,-1):
			a[511-L][L]=a[511-L-1][L]
		#put temp
		a[L+1][L]=t

#		RotRow(w)
		print w
		misc.imsave('tpics/%05d.png' % w,a)
