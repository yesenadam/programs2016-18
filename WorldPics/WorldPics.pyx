import numpy as np
cimport numpy as np
from scipy import misc
from libc.stdlib cimport rand
from libc.math cimport abs, tan, floor
cdef int UnsignedIntify(int n1,n2):
	cdef int n
	n=n1+n2
	if n<0:
		return 0
	if n>255:
		return 255
	return n
cdef int AbsDiff(int n1, n2):
	return abs(n1-n2)
cpdef OK():
	cdef np.ndarray[np.uint8_t, ndim=3] pic
	cdef np.ndarray[np.uint8_t, ndim=3] p
	cdef np.ndarray[np.uint8_t, ndim=3] pa
	pic=misc.imread("/Downloads-1/sydney copy.png") #coast.png")
	cdef int xx,yy
	xx=pic.shape[1] #beware - it loads pic sidewise, so correct for that
	yy=pic.shape[0]
	#pic to save
	p =np.empty((xx,yy,3),dtype=np.uint8)
	pa =np.empty((xx,yy,3),dtype=np.uint8)
	cdef long int diff, diffsum[3] #stores sum of diffs in each pixel
	DEF LOOPS=1000000
	cdef int fx, fy #location of fault
	cdef int a,b,c,k,i,j, dir, col, tcol,wh, new, change
	cdef int xa,quit
	cdef int currdiff=0, count=0
	#set initial vals & calc initdiff
	for k in xrange(3):
		diffsum[k]=0
	for i in xrange(xx):
		for j in xrange(yy):
			for k in xrange(3):
				p[i,j,k]=128
				diffsum[k]+=abs(int(p[i,j,k])-int(pic[j,i,k]))
#				 diffsum[k]+=AbsDiff(p[i,j,k],pic[j,i,k])
	print diffsum[0],diffsum[1],diffsum[2]
#	currdiff=diffsum[0]+diffsum[1]+diffsum[2]
	cdef float theta, m,bb, point
	for k in xrange(LOOPS):
		#do vertical fault pics into pa array
		diff=0 #reset pixel diff total
		fx=rand() %xx #0 -> xx-1
		fy=rand() % yy
		theta=(rand()%628)+1 #1 -> 628
		theta/=100 #-> should never be 0 or infinite
		m=tan(theta)
		#get b
		bb=fy-m*fx
		#do fault pic into pa array
		#make dir either 1 or -1
		dir=rand()%2
		if dir==0:
			dir=-1
		col=k%3#rand()%3 #affect random colour
		while True: #get non-zero change
			change=(rand()%101)-50 #-15 -> 15 #### was 31)-15
			if change!=0:
				break
		for b in xrange(yy): #do each row
			quit=0
			for a in xrange(xx):
				point=m*(float(b)-bb) #is to rhs of line? #if so, draw rest of line here####
				if a>floor(point):	  
					for xa in range(a,xx):
						#pa[xa,b,col]=p[xa,b,col]+dir*change #UnsignedIntify(p[xa,b,col],dir*change)
						new=int(p[xa,b,col])+int(dir*change)
						if new>255:
							new=255
						if new<0:
							new=0
						pa[xa,b,col]=new
						diff+=abs(int(pa[xa,b,col])-int(pic[b,xa,col]))
					quit=1
					break
				else:
					#pa[a,b,col]
		#try not doing the opposite on other side... D'OH
# 					new=int(p[a,b,col])-int(dir*change)
# 					if new>255:
# 						new=255
# 					if new<0:
# 						new=0
# 					pa[a,b,col]=new
# 					#UnsignedIntify(p[a,b,col],-dir*change)
					diff+=abs(int(pa[a,b,col])-int(pic[b,a,col]))
		#do other 2 #NB store diffs by colour, then no need to re-add 2 of them
		#add other cols..only diffsum[col] has changed
		if diff<diffsum[col]: #have a new record low diff
			diffsum[col]=diff #keep pa, load into p
			for a in xrange(xx):
				for b in xrange(yy):
#					for c in xrange(3):
#						p[a,b,c]=pa[a,b,c]
						p[a,b,col]=pa[a,b,col]
		count+=1  
	#save p array as image
		if count%100==0:
			misc.imsave('/Downloads-1/worldpic/%05d.png' % count,p)	  
			currdiff=diffsum[0]+diffsum[1]+diffsum[2]
			print count,k,currdiff,diffsum[0],diffsum[1],diffsum[2],col,diff