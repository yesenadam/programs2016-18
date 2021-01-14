#
#World Pics v3
#this one picks random line, then adds/subtracts exact amount to make diff=0..hmm
#prev version used non-linear to improve fit, but i guess this doesnt need to....
#plus that simplifies matching diff/num dots
# NB line 78, added 2*, makes stipply Monet-like effect.
#first one was done with 1*, lovely Cezannish folder paper out-of-focus dreamlike...
import numpy as np
cimport numpy as np
from scipy import misc
from libc.stdlib cimport rand
from libc.math cimport tan
cdef inline int UnsignedIntify(int n1,n2):
	cdef int n
	n=n1+n2
	if n<0:
		return 0
	if n>255:
		return 255
	return n
cdef inline int AbsDiff(int n1, n2): #%%%%%% tried changing to diff squared..
	cdef int d=n1-n2
	if d>=0:
		return d
	else:
		return -d
# 	return (d*d)/8 #<-- it was overflowing without the /8
cpdef OK():
	cdef np.ndarray[np.uint8_t, ndim=3] pic #=png target photo
	cdef np.ndarray[np.uint8_t, ndim=3] p #stores the best approximation to target yet
#	cdef np.ndarray[np.uint8_t, ndim=2] pa #=1 colour layer of an image, changes tested here.
	pic=misc.imread("/Downloads-1/Santorini.png") #coast.png")
	cdef int xx,yy,col,theta,dd
	cdef float m,point,b,fx,fy,fj#,mod=1
	xx=pic.shape[0] #beware - it loads pic sidewise, so correct for that
	yy=pic.shape[1]
	p =np.empty((xx,yy,3),dtype=np.uint8)
	cdef long ptot,pictot,diff
	DEF LOOPS=1000000
	cdef int ii,k,i,j,lr,dots, num=1,inc=0
	cdef int currdiff=0#, count=0
	#set initial vals & calc initdiff
	DEF TWOPIINT=628
	cdef float z,tantable[TWOPIINT+1]
	for i in xrange(1,TWOPIINT+1):
		z=i
		tantable[i]=tan(z/100)
	for i in xrange(xx):
		for j in xrange(yy):
			for k in xrange(3):
				p[i,j,k]=128
	misc.imsave('/Downloads-1/worldpic/000000.png',p)	  
	for k in xrange(1,LOOPS):
		diff=0 #reset pixel diff total
		fx=rand() % xx #0 -> xx-1 #Choose random point and random angle through it
		fy=rand() % yy
		theta=(rand()%628)+1 #1 -> 628 #should avoid problem areas i.e. horiz & vert lines
		m=tantable[theta]#tan(theta/100) #theta is in [0.01,0.02..6.28] - maybe do %6283 and /1000 to get more vert/horiz lines
		b=fy-m*fx
		#i.e. line is y=m*x+b
		#plug in fx,fy and m (randomly chosen) to find b
		lr=rand()%2 #0 or 1. if 1 draws on right, if 0, and left of line
		col=k%3 #0, 1 or 2
		ptot=0
		pictot=0
		dots=0
		if lr==1:
#first time, tally totals
			for j in xrange(yy): #do each row
				fj=j #float
				point=(fj-b)/m #is to rhs of line? #if so, draw rest of line here####
				for i in xrange(xx):
					if i>=point:	  
						for ii in range(i,xx):
							ptot+=p[ii,j,col]
							pictot+=pic[ii,j,col]
							dots+=1
						break
			diff=pictot-ptot #ie pos means, add more
			dd=2*diff/dots #average per dot to add #^^^^^^^ added *2 here
#second time, redo points
			for j in xrange(yy): #do each row
				fj=j #float
				point=(fj-b)/m #is to rhs of line? #if so, draw rest of line here####
				for i in xrange(xx):
					if i>point:	  
						for ii in range(i,xx):
							p[ii,j,col]=UnsignedIntify(p[ii,j,col],dd)
						break
		else: #do on LHS
#first time, tally totals
			for j in xrange(yy): #do each row
				fj=j #float
				point=(fj-b)/m #is to rhs of line? #if so, draw rest of line here####
				for i in xrange(xx-1,-1,-1):
					if i<point:	  
						for ii in range(i,-1,-1):
							ptot+=p[ii,j,col]
							pictot+=pic[ii,j,col]
							dots+=1
						break
			diff=pictot-ptot #ie pos means, add more
			dd=2*diff/dots #average per dot to add
#second time, redo points
			for j in xrange(yy): #do each row
				fj=j #float
				point=(fj-b)/m #is to rhs of line? #if so, draw rest of line here####
				for i in xrange(xx-1,-1,-1):
					if i<point:	  
						for ii in range(i,-1,-1):
							p[ii,j,col]=UnsignedIntify(p[ii,j,col],dd)
						break
		if k==num: #k=0 num=0 inc=1 k 
			inc+=1
			num+=inc
			misc.imsave('/Downloads-1/worldpic/%06d.png' % k,p)	  
			print k,ptot,pictot,diff,dots,dd,m,b,fx,fy