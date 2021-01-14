#trisub.pyx
from polygonedgecolor import polygon2d
from sage.plot.graphics import Graphics
DEF MAX=100000
DEF NUMBEROFTYPES=5
DEF R=1.193859111 #expansion factor
DEF H=1.0841123455 #height of first triangle. H^2+(1/2)^2=R^2
DEF LOOPS=50 #total number of generations to draw
polygon2d.options['thickness']=0.3
polygon2d.options['edgecolor']='black'
cdef:
	struct pt:
		double x,y
	struct shape:
		int type
		pt A,B,C
	int t=1 #total number of shapes so far
	shape s[MAX]
	float col[NUMBEROFTYPES][3]
col[0][:]=[0.05,0,0.2] 	#violet
col[1][:]=[0.8,0.5,0.2] #orange
col[2][:]=[0.9,0.9,0] 	#yellow
col[3][:]=[0.3,0.3,1] 	#light blue
col[4][:]=[0.1,0.1,0.7] #blue
s[0]=[0,[0.5,H],[0,0],[1,0]] #initial triangle, type 0
cdef pt WeightedAve(pt J, pt K,float w1,w2):
	cdef float sum=w1+w2
	return [(K.x*w1+J.x*w2)/sum,(K.y*w1+J.y*w2)/sum]
cdef Update(int n):
	global t
	cdef pt AC,BC,AB,A=s[n].A,B=s[n].B,C=s[n].C
	s[n].type+=1
	if s[n].type==5: 	#delete and make 4 new shapes
		AC=WeightedAve(A,C,R*R,1) #new point between A & C
		BC=WeightedAve(B,C,R*R,1)
		AB=WeightedAve(A,B,R*R,1)
		#s[t] is the first empty s[].
		s[t]=[1,BC,B,AB] #the new type 1 at B (bottom left)
		s[t+1]=[1,AB,AC,BC] #the new type 1 above that
		s[t+2]=[2,A,AB,AC] #the type 2 at top
		#lastly, the new type 0 at bottom right, replacing the old type 5
		s[n]=[0,AC,BC,C] #C stays the same point
		t+=3
cpdef OK():
	cdef int i, j, w, tot
	for j in xrange(LOOPS):
		tot=t
		print j,tot
		f=Graphics()
		for i in xrange(tot):
			w=s[i].type
			f+=polygon2d([[s[i].A.x,s[i].A.y],[s[i].B.x,s[i].B.y],
				[s[i].C.x,s[i].C.y]],rgbcolor=(col[w][0],col[w][1],col[w][2]))
		f.save('/Users/admin/trisub/%05d.png' % j,axes=False,figsize=12,
			aspect_ratio=1,xmin=0.25,xmax=0.75,ymin=0.05,ymax=0.5)
		for i in xrange(tot): #from shape 0 --> tot-1
			Update(i)

	