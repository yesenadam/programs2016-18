#trisub.pyx
#from sage.misc.functional import show
from polygonedgecolor import polygon2d
#from sage.plot.line import line2d
from sage.plot.graphics import Graphics
DEF MAX=10000
DEF numtypes=6
DEF R=1.193859111321223132 #expansion factor
DEF RSQ=R*R #1.42529957768470065
polygon2d.options['thickness']=0.3
polygon2d.options['edgecolor']='black'
cdef:
	struct pt:
		double x,y
	struct shape:
		int type
		double A[2] #vertices of triangle **make this A.x,A.y?
		double B[2]
		double C[2]
	int i, numshapes=1, EXIT=0
	int loops=50 #total number of generations to draw
	shape s[MAX]
	shape temp
	float col[numtypes][3]
	double AC[2],BC[2],AB[2]
col[0][:]=[0.05,0,0.2] #violet
col[1][:]=[0.8,0.5,0.2] #orange
col[2][:]=[0.9,0.9,0] #yellow
col[3][:]=[0.3,0.3,1] #light blue
col[4][:]=[0.1,0.1,0.7] #blue
#set initial shape..
s[0].type=0
s[0].A[:]=[0.5,1.084112345508850161] #sqrt(R^2 - 1/4)
s[0].B[:]=[0,0]
s[0].C[:]=[1,0]
cdef float WAve(float P,Q,w1,w2): #if 1:2 then.. is closer to P
#make the first arg a pointer to a pt struct.. then set P.x, P.y
	return (Q*w1+P*w2)/(w1+w2)
#cdef Eq(double* L,R):
#	L[0]=R[0]
#	L[1]=R[1]
cdef Update(int n):
	global numshapes,AC,BC,AB
	s[n].type+=1
	#if type=5, delete and make 4 new shapes
	if s[n].type==5:
		#so.. s[numshapes] is the first empty s[].
		#new pts
#do this with pointers or something?! or just return a float[2]****
		AC[:]=[WAve(s[n].A[0],s[n].C[0],RSQ,1),WAve(s[n].A[1],s[n].C[1],RSQ,1)]
		BC[:]=[WAve(s[n].C[0],s[n].B[0],1,RSQ),WAve(s[n].C[1],s[n].B[1],1,RSQ)]
		AB[:]=[WAve(s[n].B[0],s[n].A[0],1,RSQ),WAve(s[n].B[1],s[n].A[1],1,RSQ)]
		#the new type 1 at B (bottom left)
		s[numshapes].type=1 #and these 3 more
		s[numshapes].A[0]=BC[0]
		s[numshapes].A[1]=BC[1]
		s[numshapes].B[0]=s[n].B[0]
		s[numshapes].B[1]=s[n].B[1]
		s[numshapes].C[0]=AB[0]
		s[numshapes].C[1]=AB[1]
		#the new type 1 above that
		s[numshapes+1].type=1
		s[numshapes+1].A[0]=AB[0]
		s[numshapes+1].A[1]=AB[1]
		s[numshapes+1].B[0]=AC[0] #s[n].B
		s[numshapes+1].B[1]=AC[1] #s[n].B
		s[numshapes+1].C[0]=BC[0]
		s[numshapes+1].C[1]=BC[1]
		#the type 2 at top
		s[numshapes+2].type=2
		s[numshapes+2].A[0]=s[n].A[0]
		s[numshapes+2].A[1]=s[n].A[1]
		s[numshapes+2].B[0]=AB[0]
		s[numshapes+2].B[1]=AB[1]
		s[numshapes+2].C[0]=AC[0]
		s[numshapes+2].C[1]=AC[1]
		#lastly, the new type 0 at bottom right, replacing the old type 5
		s[n].type=0
		s[n].A[0]=AC[0]
		s[n].A[1]=AC[1]
		s[n].B[0]=BC[0]
		s[n].B[1]=BC[1]
		#s[n].C=s[n].C #stays the same point
		numshapes+=3
cdef Gen():
	cdef int tot=numshapes #so that lim stays constant while numshapes is increased
	if tot>MAX:
		print "Too many shapes!"
		EXIT=1
		return
	for i in xrange(tot): #shape 0 to numshapes-1
		Update(i)
cpdef OK():
	cdef int j,ty
	for j in xrange(loops):
		print j,numshapes
		f=Graphics()
		for i in xrange(numshapes):
			ty=s[i].type
			f+=polygon2d([[s[i].A[0],s[i].A[1]],
				[s[i].B[0],s[i].B[1]],
				[s[i].C[0],s[i].C[1]]],
				rgbcolor=(col[ty][0],col[ty][1],col[ty][2]))
		f.save('/Users/admin/trisub/%05d.png' % j,axes=False,figsize=10,aspect_ratio=1)
		Gen()
		if EXIT==1: break
	
# 	cdef:
# 		long double a,y
# 		int i
# 	a = 1.1936 #approx
# 	print "To find sol of a^5=a^2+1"
# 	print "Starting approximation: ",a
# 	print "a_n+1=((a_n)^2+1)^1/5"
# 	for i in xrange(1,25):
# 		y=a**2+1
# 		a=y**(0.2)
# 		print "{0:2d}: {1:.60f}".format(i,a)
# 	y=a**5
# 	print "a^5  : %1.60f" % y
# 	y=a**2+1
# 	print "a^2+1: %1.60f" % y
# 	y=sqrt(a**2-0.25)
# 	print "h= %0.60f" % y
# R=1.193859111321223132051727588986977934837341308593
# h= 1.0841123455088501614795859495643526315689086914
	
	