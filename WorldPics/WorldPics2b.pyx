#WorldPic
#I changed the d in AbsDiff to d*d to try to, uh, try to get small areas with wrong colour dealt with better...
#i.e. squaring to make outliers stick out more.. cost more.

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
# 	if d>=0:
# 		return d
# 	else:
# 		return -d
	return (d*d)/8 #<-- it was overflowing without the /8
cpdef OK():
	cdef np.ndarray[np.uint8_t, ndim=3] pic #=png target photo
	cdef np.ndarray[np.uint8_t, ndim=3] p #stores the best approximation to target yet
	cdef np.ndarray[np.uint8_t, ndim=2] pa #=1 colour layer of an image, changes tested here.
	pic=misc.imread("/Downloads-1/tiger-09.png") #coast.png")
	cdef int xx,yy,col,change, theta
	cdef float m,point,b,fx,fy,fj
	xx=pic.shape[0] #beware - it loads pic sidewise, so correct for that
	yy=pic.shape[1]
	p =np.empty((xx,yy,3),dtype=np.uint8)
	pa =np.empty((xx,yy),dtype=np.uint8)
	cdef unsigned long diff,diffsum[3] #stores sum of diffs in each pixel
	DEF LOOPS=1000000
	cdef int quit,ii,k,i,j,lr,num=1,inc=0,q=1
	cdef int currdiff=0#, count=0
	#set initial vals & calc initdiff
	DEF TWOPIINT=628
	DEF PIDIV=100 #ie TWOPIINT/DIV ~ 2*pi
	cdef float z,tantable[TWOPIINT+1]
	for i in xrange(1,TWOPIINT+1):
		z=i
		tantable[i]=tan(z/100)
	for k in xrange(3):
		diffsum[k]=0
	for i in xrange(xx):
		for j in xrange(yy):
			for k in xrange(3):
				p[i,j,k]=128
				diffsum[k]+=AbsDiff(p[i,j,k],pic[i,j,k])
	cdef int delta=100 #starting val
	print diffsum[0],diffsum[1],diffsum[2]
	for k in xrange(LOOPS):
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
		while True: #get non-zero change
			change=(rand()%(delta*2+1))-delta #random amount to change colour by.
			if change!=0: #from -50 to 50, not 0.
				break
		#if k==100:
		#	delta=50
		#else:
		if k==3000:
			delta=20 #for finer tuning as it goes on..
# 		else:
# 			if k==2000:
# 				delta=10
# 	#			else:
	#				if k==4000:
	#					delta=5
	#******** Maybe square differences???
	#one dot wrong by 100 is worse than 10 wrong by 10.
		if lr==1:
			for j in xrange(yy): #do each row
				fj=j #float
				point=(fj-b)/m #is to rhs of line? #if so, draw rest of line here####
				for i in xrange(xx):
					if i>point:	  
						for ii in range(i,xx):
							pa[ii,j]=UnsignedIntify(p[ii,j,col],change)
							diff+=AbsDiff(pa[ii,j],pic[ii,j,col])
						break
					else:
						diff+=AbsDiff(p[i,j,col],pic[i,j,col])
			if diff>diffsum[col]: #try doing opposite then if that didnt work
				diff=0
				for j in xrange(yy): #do each row
					fj=j #float
					point=(fj-b)/m #is to rhs of line? #if so, draw rest of line here####
					for i in xrange(xx):
						if i>point:	  
							for ii in range(i,xx):
								pa[ii,j]=UnsignedIntify(p[ii,j,col],-change)
								diff+=AbsDiff(pa[ii,j],pic[ii,j,col])
							break
						else:
							diff+=AbsDiff(p[i,j,col],pic[i,j,col])
		else: #do on LHS
			for j in xrange(yy): #do each row
				fj=j #float
				point=(fj-b)/m #is to rhs of line? #if so, draw rest of line here####
				for i in xrange(xx-1,-1,-1):#draw from R to L
					if i<point:	  
						for ii in range(i,-1,-1):
							pa[ii,j]=UnsignedIntify(p[ii,j,col],change)
							diff+=AbsDiff(pa[ii,j],pic[ii,j,col])
						break
					else:
						diff+=AbsDiff(p[i,j,col],pic[i,j,col])
			if diff>diffsum[col]: #try doing opposite then if that didnt work
				diff=0
				for j in xrange(yy): #do each row
					fj=j #float
					point=(fj-b)/m #is to rhs of line? #if so, draw rest of line here####
					for i in xrange(xx-1,-1,-1):#draw from R to L
						if i<point:	  
							for ii in range(i,-1,-1):
								pa[ii,j]=UnsignedIntify(p[ii,j,col],-change)
								diff+=AbsDiff(pa[ii,j],pic[ii,j,col])
							break
						else:
							diff+=AbsDiff(p[i,j,col],pic[i,j,col])
		#do other 2 #NB store diffs by colour, then no need to re-add 2 of them
		#add other cols..only diffsum[col] has changed
		if diff<diffsum[col]: #have a new record low diff
			diffsum[col]=diff #keep pa, load into p
			p[:,:,col]=pa[:,:]
	#save p array as image
# 			if q==num: #k=0 num=0 inc=1 k 
# 				inc+=1
# 				num+=inc
			misc.imsave('/Downloads-1/worldpic/%05d.png' % k,p)	  
			currdiff=diffsum[0]+diffsum[1]+diffsum[2]
			print k,currdiff,diffsum[0],diffsum[1],diffsum[2],col,change,b,m
#			q+=1