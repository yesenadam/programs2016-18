#WorldPic
#I changed the d in AbsDiff to d*d to try to, uh, try to get small areas with wrong colour dealt with better...
#i.e. squaring to make outliers stick out more.. cost more.
#THIS VERSION with line smoothing....

import numpy as np
cimport numpy as np
from scipy import misc
from libc.stdlib cimport rand
from libc.math cimport tan,floor
cdef float fj,b,m
cdef inline int GetXCoord(int y, float mm,bb):
	cdef float pt, fly
	fly=y
	pt=(fly-bb)/mm
	return (int) (pt+0.5) #rounded to nearest int
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
	cdef int xx,yy,col,change, theta,poi
	cdef float m,point,b,fx,fy,fj
	xx=pic.shape[0] #beware - it loads pic sidewise, so correct for that
	yy=pic.shape[1]
	p =np.empty((xx,yy,3),dtype=np.uint8)
	pa =np.empty((xx,yy),dtype=np.uint8)
	cdef unsigned long diff,diffsum[3] #stores sum of diffs in each pixel
	DEF LOOPS=1000000
	cdef int quit,ii,k,i,j,lr,num=1,inc=0,q=1
	cdef int currdiff=0, delta=100 #starting val .. 100?
	DEF TWOPIINT=628
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
	print diffsum[0],diffsum[1],diffsum[2]
	for k in xrange(LOOPS):
		diff=0 #reset pixel diff total
		fx=rand() % xx #0 -> xx-1 #Choose random point and random angle through it
		fy=rand() % yy
		theta=(rand()%628)+1 #1 -> 628 #should avoid problem areas i.e. horiz & vert lines
		m=tantable[theta]#tan(theta/100) #theta is in [0.01,0.02..6.28] - maybe do %6283 and /1000 to get more vert/horiz lines
		b=fy-m*fx #i.e. line is y=m*x+b, plug in fx,fy and m (randomly chosen) to find b
		lr=rand()%2 #0 or 1. if 1 draws on right, if 0, and left of line
		col=k%3 #0, 1 or 2 #NB does random (as it was) work better for ice palace?! maybe.
		#then each colour will get stuff in pa[ from both other colours, not just 1. TRY.
		while True: #get non-zero change
			change=(rand()%(delta*2+1))-delta #random amount to change colour by.
			if change!=0: #anything from -delta to delta, but not 0.
				break
		if k==1000:
			delta=50
		else:
			if k==3000:
				delta=20 #for finer tuning as it goes on..
		#pa[:,:]=p[:,:,col] #This line fixed the ice palace bug!!
		if lr==1:
			for j in xrange(yy): #do each row
				poi=GetXCoord(j,m,b) #ie x coord of y=mx+b at y=j.
				for i in xrange(xx):
#					if i==poi: #this is smoothed point. added to diff by 'else' below
#						pa[i,j]=Uint8ifySum(p[i,j,col],change/2)
#but this smoothing leaves weird line artefacts in the 'ice palace bug' mode... so dont use..
#hehe well, maybe will look good after 90000... but after 100, looks weeeeeird.
#better to just use hires pics.
					if i>poi:	  
						for ii in range(i,xx):
							pa[ii,j]=Uint8ifySum(p[ii,j,col],change)
							diff+=AbsDiff(pa[ii,j],pic[ii,j,col])
						break
					else:
						diff+=AbsDiff(pa[i,j],pic[i,j,col]) #NB**** this was pa[ + pic. i think that bug
						#was the original 'ice palace' look!!! but with the pa[:,:]=p[:,:,col] line,
						#pa and p[,,col are the same anyway.
			if diff>diffsum[col]: #try doing opposite then if that didnt work
				diff=0
				for j in xrange(yy): #do each row
					poi=GetXCoord(j,m,b) #ie x coord of y=mx+b at y=j.
					for i in xrange(xx):
# 						if i==poi: #this is smoothed point. added to diff by 'else' below
# 							pa[i,j]=Uint8ifySum(p[i,j,col],-change/2)
						if i>poi:	  
							for ii in range(i,xx):
								pa[ii,j]=Uint8ifySum(p[ii,j,col],-change)
								diff+=AbsDiff(pa[ii,j],pic[ii,j,col])
							break
						else:
							diff+=AbsDiff(pa[i,j],pic[i,j,col])
		else: #do on LHS
			for j in xrange(yy): #do each row
				poi=GetXCoord(j,m,b) #ie x coord of y=mx+b at y=j.
				for i in xrange(xx-1,-1,-1):#draw from R to L
# 					if i==poi: #this is smoothed point. added to diff by 'else' below
# 						pa[i,j]=Uint8ifySum(p[i,j,col],change/2)
					if i<poi:	  
						for ii in range(i,-1,-1):
							pa[ii,j]=Uint8ifySum(p[ii,j,col],change)
							diff+=AbsDiff(pa[ii,j],pic[ii,j,col])
						break
					else:
						diff+=AbsDiff(pa[i,j],pic[i,j,col])
			if diff>diffsum[col]: #try doing opposite then if that didnt work
				diff=0
				for j in xrange(yy): #do each row
					poi=GetXCoord(j,m,b) #ie x coord of y=mx+b at y=j.
					for i in xrange(xx-1,-1,-1):#draw from R to L
# 						if i==poi: #this is smoothed point. added to diff by 'else' below
# 							pa[i,j]=Uint8ifySum(p[i,j,col],-change/2)
						if i<poi:	  
							for ii in range(i,-1,-1):
								pa[ii,j]=Uint8ifySum(p[ii,j,col],-change)
								diff+=AbsDiff(pa[ii,j],pic[ii,j,col])
							break
						else:
							diff+=AbsDiff(pa[i,j],pic[i,j,col])
		if diff<diffsum[col]: #have a new record low diff
			diffsum[col]=diff #keep pa, load into p
			p[:,:,col]=pa[:,:]
			if q==num: #to save every 2nd, 3rd, 4th etc image... 'log interest'.. (stuff happens faster at start)
				inc+=1
				num+=inc
				printf('worldpic/%05d.png\n',k)
				misc.imsave('/Downloads-1/worldpic/%05d.png' % k,p)	  
			currdiff=diffsum[0]+diffsum[1]+diffsum[2]
			print k,currdiff,diffsum[0],diffsum[1],diffsum[2],col,change,b,m
			q+=1