#WorldPic
#I changed the d in AbsDiff to d*d to try to, uh, try to get small areas with wrong colour dealt with better...
#i.e. squaring to make outliers stick out more.. cost more.
#THIS VERSION does random SQUARES.
#this version adds necessary amount (no trial and error) to random square..

import numpy as np
cimport numpy as np
from scipy import misc
from libc.stdlib cimport rand
cdef inline int Uint8ifySum(int n1,n2):
	cdef int n
	n=n1+n2
	if n<0:
		return 0
	if n>255:
		return 255
	return n
cpdef OK():
	cdef np.ndarray[np.uint8_t, ndim=3] pic #=png target photo
	cdef np.ndarray[np.uint8_t, ndim=3] p #stores the best approximation to target yet
	pic=misc.imread("/Downloads-1/picsforcython/tiger-09.png") #coast.png")/Users/admin/Desktop/aerialsydney.png")#picsforcython/gonzalez.png")#
	cdef int xx,yy,col,fx,fy
	xx=pic.shape[0] #beware - it loads pic sidewise, so correct for that
	yy=pic.shape[1]
	p =np.empty((xx,yy,3),dtype=np.uint8)
#	cdef unsigned long diff,pdiff#diffsum[3] #stores sum of diffs in each pixel
	DEF LOOPS=2000000
	cdef int quit,ii,k,i,j,lr,num=0,inc=0,q=1,fn=0
#	cdef int currdiff=0, delta=100 #starting val .. 100?
	for i in xrange(xx):
		for j in xrange(yy):
			for k in xrange(3):
				p[i,j,k]=0 #black
	cdef int hei,wid, smallest=3 #smallest square side allowed
	cdef int widest=xx-5, tallest=yy-5
	#if biggest>yy-5:
	#	biggest=yy-5 #make sure biggest square fits in pic.
	#probably should try to include ice palace bug, for more surprising results.....
	cdef int ptotal, ttotal, dd
	for k in xrange(LOOPS):
		#choose bottom left corner
		#first choose side length
		wid=rand() % (widest-smallest+1) + smallest #range = smallest -> biggest
		hei=rand() % (tallest-smallest+1) + smallest #range = smallest -> biggest
		fx=rand() % (xx-wid) #0 -> xx-1 #Choose random point and random angle through it
		fy=rand() % (yy-hei) #0 --> yy-side-1 so y max will be yy-1 --> yup.
		col=k%3 #0, 1 or 2 #NB does random (as it was) work better for ice palace?! maybe.
		ptotal=0 #pic
		ttotal=0 #target pic
		for j in xrange(fy,fy+hei+1): #do each row
			for i in xrange(fx,fx+wid+1):
				ptotal+=p[i,j,col]
				ttotal+=pic[i,j,col] #current pic diff from target pic
		dd=(ttotal-ptotal)/(hei*wid) #ie if pos, pic needs more of colour
		#maybe add line here: if dd<5 and dd>-5: dd*=2 or 5 or something.... no tiny changes wanted.
		if dd!=0:
			for j in xrange(fy,fy+hei+1): #do each row
				for i in xrange(fx,fx+wid+1):
					p[i,j,col]=Uint8ifySum(p[i,j,col],dd)
		if k==num: #to save every 2nd, 3rd, 4th etc image... 'log interest'.. (stuff happens faster at start)
			num+=1
			if fn>300:
				inc+=1
				num+=inc
				inc=(inc*5)/4
#			printf('worldpic/%05d.png\n',k)
			misc.imsave('/Downloads-1/worldpic/%07d.png' % fn,p)	 
			if k<20:
				for i in xrange((20-k)/3+1):
					fn+=1
					misc.imsave('/Downloads-1/worldpic/%07d.png' % fn,p)	 
			fn+=1
			print k,inc
#		q+=1