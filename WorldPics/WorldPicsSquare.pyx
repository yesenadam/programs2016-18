#WorldPic
#I changed the d in AbsDiff to d*d to try to, uh, try to get small areas with wrong colour dealt with better...
#i.e. squaring to make outliers stick out more.. cost more.
#THIS VERSION does random SQUARES.

import numpy as np
cimport numpy as np
from scipy import misc
from libc.stdlib cimport rand
#from libc.math cimport tan,floor
#cdef float fj,b,m
cdef inline int Uint8ifySum(int n1,n2):
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
#	return (d*d)/8 #<-- it was overflowing without the /8
cpdef OK():
	cdef np.ndarray[np.uint8_t, ndim=3] pic #=png target photo
	cdef np.ndarray[np.uint8_t, ndim=3] p #stores the best approximation to target yet
	cdef np.ndarray[np.uint8_t, ndim=2] pa #=1 colour layer of an image, changes tested here.
	pic=misc.imread("/Downloads-1/santorini.png") #coast.png")/Users/admin/Desktop/aerialsydney.png")#picsforcython/gonzalez.png")#
	cdef int xx,yy,col,change,fx,fy
	xx=pic.shape[0] #beware - it loads pic sidewise, so correct for that
	yy=pic.shape[1]
	p =np.empty((xx,yy,3),dtype=np.uint8)
	pa =np.empty((xx,yy),dtype=np.uint8)
	cdef unsigned long diff,pdiff#diffsum[3] #stores sum of diffs in each pixel
	DEF LOOPS=1000000
	cdef int quit,ii,k,i,j,lr,num=1,inc=0,q=1
	cdef int currdiff=0, delta=100 #starting val .. 100?
	for i in xrange(xx):
		for j in xrange(yy):
			for k in xrange(3):
				p[i,j,k]=0 #black
	cdef int side, smallest=5 #smallest square side allowed
	cdef int biggest=xx-5
	if biggest>yy-5:
		biggest=yy-5 #make sure biggest square fits in pic.
	#now either:
	#1. square of any size allowed all through
	#2. start with biggest, get smaller. maybe even do say 100 of each size, from biggest to smallest..
	#probably should try to include ice palace bug, for more surprising results.....
	for k in xrange(LOOPS):
		diff=0 #reset pixel diff total
		pdiff=0
		#choose bottom left corner
		#first choose side length
		side=rand() % (biggest-smallest+1) + smallest #range = smallest -> biggest
		fx=rand() % (xx-side) #0 -> xx-1 #Choose random point and random angle through it
		fy=rand() % (yy-side) #0 --> yy-side-1 so y max will be yy-1 --> yup.
		col=k%3 #0, 1 or 2 #NB does random (as it was) work better for ice palace?! maybe.
		#then each colour will get stuff in pa[ from both other colours, not just 1. TRY.
		while True: #get non-zero change
			change=(rand()%(delta*2+1))-delta #random amount to change colour by.
			if change!=0: #anything from -delta to delta, but not 0.
				break
# 		if k==1000:
# 			delta=50
# 		else:
# 			if k==3000:
# 				delta=20 #for finer tuning as it goes on..
		pa[:,:]=p[:,:,col] #This line fixed the ice palace bug!!
		#now diff & pdiff just measure the sum of pixel differences within the current random square.
		for j in xrange(fy,fy+side+1): #do each row
			for i in xrange(fx,fx+side+1):
					pa[i,j]=Uint8ifySum(p[i,j,col],change)
					diff+=AbsDiff(pa[i,j],pic[i,j,col]) #diff from target pic
					pdiff+=AbsDiff(p[i,j,col],pic[i,j,col]) #current pic diff from target pic
		if diff>pdiff: #if that wasnt successful, try opposite
			diff=0
			for j in xrange(fy,fy+side+1): #do each row
				for i in xrange(fx,fx+side+1):
						pa[i,j]=Uint8ifySum(p[i,j,col],-change)
						diff+=AbsDiff(pa[i,j],pic[i,j,col]) #diff from target pic
#						pdiff+=AbsDiff(p[i,j,col],pic[i,j,col]) #current pic diff from target pic
#ie pdiff hasnt changed - dont need to add it up again
		if diff<pdiff: #have a new record low diff
			p[:,:,col]=pa[:,:]
			if q==num: #to save every 2nd, 3rd, 4th etc image... 'log interest'.. (stuff happens faster at start)
				inc+=1
				num+=inc
				printf('worldpic/%05d.png\n',k)
				misc.imsave('/Downloads-1/worldpic/%05d.png' % k,p)	  
			print k,col,change,fx,fy,side,diff,pdiff
			q+=1