#FDS3types.pyx - 
#modified from Thue-Morse 2D tiling fractal program - Apr 2017
#from N Frank paper "Fractal Dual Substitution Tilings" p3
import numpy as np
cimport numpy as np
from scipy import misc
from libc.stdlib cimport rand
DEF MAXPTS=12000 #NB this must be larger than number of points in each tile
DEF MAXLEVEL=4 
DEF ARRAYWID=850 
DEF ARRAYHEI=400
DEF MARG=20
DEF COLOURS=3 #White, Blue, Green
DEF DIRECTIONS=4 #Top, Right, Bottom, Left
DEF MAXPATHSEGS=13 #NB this must be > largest value in numrules[][] array
DEF INITSIDE=4
DEF SIDE=INITSIDE**MAXLEVEL
DEF TILEWID=8 # times 256 =2048
DEF PICWID=TILEWID*SIDE
DEF DRAWTILINGGRID=1 #set to 0 =DONT DRAW GRID on tiling pic, 1 = DRAW
cdef:
	enum:
		T=0, R=1, B=2, L=3 #type
		Wh=0,Bl=1,Gr=2	#subcol
	struct point:
		int x,y
	point C[COLOURS][MAXPTS] #C[0]=white pixels, C[1]=blue
	int col, total[COLOURS] #total num of white, blue pixels stored so far
	int numrules[COLOURS][DIRECTIONS] #stores num of steps in each subpath
	struct pa:
		int subcol,type
		point loc
	pa path[COLOURS][DIRECTIONS][MAXPATHSEGS], it
	unsigned short Black[3], shade[3][3], pic[PICWID][PICWID][3], fillcol[3]
	Fill(int x, int y): #colour in tile with fillcol
		if pic[x][y][0]==255: #if red=255, i.e. if White
			pic[x][y][:]=fillcol
			if x<PICWID-1:
				Fill(x+1,y)
				if y<PICWID-1: #do upper right
					Fill(x+1,y+1)
				if y>0: #lower right
					Fill(x+1,y-1)
			if x>0:
				Fill(x-1,y)
				if y<PICWID-1: #do upper left
					Fill(x-1,y+1)
				if y>0: #lower left
					Fill(x-1,y-1)
			if y<PICWID-1:
				Fill(x,y+1)
			if y>0:
				Fill(x,y-1)
	int Done(point d,int level):
		if level==MAXLEVEL:
			C[col][total[col]]=d #add point to end of list of pts
			total[col]+=1
			return 1 # i.e. otherwise return 0
Black[:]=[0,0,0]
Gray=[100,100,100]
LightGray=[180,180,180]
shade[Wh][:]=[255,255,255] #white
shade[Bl][:]=[80,80,255] #blue
shade[Gr][:]=[0,180,0] #green
# ---------------- change the below settings to change fractal.
# the number path[][][num] must = the number of segments in list.
# and those 4 nums for each colour must be put in its numrules[][] list.
# make sure MAXPATHSEGS>greatest num. and MAXPTS>points in each fract segment
numrules[Wh][:]=[1,11,11,5]
numrules[Bl][:]=[5,11,11,1]
numrules[Gr][:]=[7,1,9,11]
path[Wh][T][:1]=[[Bl,T,[1,0]]]
path[Wh][R][:11]=[[Bl,R,[1,0]],[Gr,L,[2,0]],[Gr,B,[2,0]],[Bl,T,[2,1]],
[Bl,B,[2,1]],[Gr,T,[2,2]],[Gr,R,[2,2]],
[Wh,L,[3,2]],[Wh,T,[3,2]],[Gr,B,[3,1]],[Gr,R,[3,1]]]
path[Wh][B][:11]=[[Bl,B,[1,0]],[Wh,T,[1,1]],[Wh,B,[1,1]],[Bl,T,[1,2]],
[Bl,L,[1,2]],[Gr,R,[0,2]],[Gr,B,[0,2]],[Wh,T,[0,3]],[Wh,R,[0,3]],
[Bl,L,[1,3]],[Bl,B,[1,3]]]
path[Wh][L][:5]=[[Bl,L,[1,0]],[Gr,R,[0,0]],[Gr,B,[0,0]],[Bl,T,[0,1]],[Bl,L,[0,1]]]

path[Bl][T][:5]=[[Gr,T,[0,1]],[Gr,B,[0,0]],[Gr,R,[0,0]],[Wh,L,[1,0]],[Wh,T,[1,0]]]
path[Bl][R][:11]=[[Gr,R,[0,1]],[Bl,L,[1,1]],[Bl,R,[1,1]],[Gr,L,[2,1]],
[Gr,T,[2,1]],[Wh,B,[2,0]],[Wh,R,[2,0]],[Gr,L,[3,0]],[Gr,B,[3,0]],[Wh,T,[3,1]],
[Wh,R,[3,1]]]
path[Bl][B][:11]=[[Gr,B,[0,1]],[Bl,T,[0,2]],[Bl,R,[0,2]],[Gr,L,[1,2]],
[Gr,R,[1,2]],[Bl,L,[2,2]],[Bl,B,[2,2]],[Bl,T,[2,3]],[Bl,L,[2,3]],[Wh,R,[1,3]],
[Wh,B,[1,3]]]
path[Bl][L][:1]=[[Gr,L,[0,1]]]

path[Gr][T][:7]=[[Wh,T,[3,1]],[Gr,B,[3,0]],[Gr,L,[3,0]],[Bl,R,[2,0]],
[Bl,L,[2,0]],[Wh,R,[1,0]],[Wh,T,[1,0]]]
path[Gr][R][:1]=[[Wh,R,[3,1]]]
path[Gr][B][:9]=[[Bl,B,[1,3]],[Bl,R,[1,3]],[Wh,L,[2,3]],[Wh,R,[2,3]],[Bl,L,[3,3]],
[Bl,T,[3,3]],[Wh,B,[3,2]],[Wh,T,[3,2]],[Wh,B,[3,1]]]
path[Gr][L][:11]=[[Wh,L,[0,1]],[Wh,R,[0,1]],[Bl,L,[1,1]],[Bl,B,[1,1]],
[Wh,T,[1,2]],[Wh,R,[1,2]],[Wh,L,[2,2]],[Wh,T,[2,2]],[Wh,B,[2,1]],[Wh,R,[2,1]],
[Wh,L,[3,1]]]

cdef Do(pa which,point where, int level):
	cdef int n
	where=[where.x*INITSIDE+which.loc.x,where.y*INITSIDE+which.loc.y]
	if not Done(where,level):
		for n in xrange(numrules[which.subcol][which.type]):
			Do(path[which.subcol][which.type][n],where,level+1)
cpdef OK():
	global fillcol,col
	cdef:
		int i, j, k, c, xx, yy, m, n, f, xloc
		np.ndarray[np.uint8_t,ndim=3] a= \
			np.empty((ARRAYHEI,ARRAYWID,3),dtype=np.uint8)
		np.ndarray[np.uint8_t,ndim=3] t= \
			np.empty((PICWID,PICWID,3),dtype=np.uint8)
		point z=[0,0]
	total[:]=[0,0,0]
	for col in xrange(COLOURS): #White, Blue, Green
		for j in xrange(DIRECTIONS): #T,R,B,L
			Do([col,j,z],z,0) #construct the fractal paths
	a.fill(255) #make array for tiles image white
	for j in xrange(PICWID):
		for i in xrange(PICWID):
			pic[i][j][0]=255 #make tiling image white
			#well- red is white enough - only red tested later by Fill
	for i in xrange(SIDE): #coloured squares
		for k in xrange(SIDE):
			for j in xrange(3):
				a[MARG+k,MARG*2+SIDE+i,j]=shade[Bl][j]
				a[MARG+k,MARG*3+2*SIDE+i,j]=shade[Gr][j]
	DEF UNIT=MARG+SIDE #cell+gap; width of whole repeating unit
	DEF CELLWID=16
	DEF HALF=CELLWID/2
	DEF GAP=20 #between tiles and cells
	DEF CELLTOP=UNIT+GAP
	DEF XMARG=MARG+100
	for k in xrange(3):
		for i in xrange(COLOURS): 
			xloc=MARG+UNIT*i
			for j in xrange(total[i]): #plot fractal points
				a[MARG+C[i][j].y,C[i][j].x+xloc,k]=0 #black
			for j in xrange(SIDE): #black frame around cells
				a[MARG+j,xloc,k]=0 #LHS
				a[MARG+j,(i+1)*UNIT,k]=0 #RHS
				a[MARG,xloc+j,k]=0 #top
				a[MARG+SIDE,xloc+j,k]=0 #bot
	#first, grey over whole cell - so that white can be seen for type 1.
	for i in xrange(COLOURS):
		xloc=XMARG+UNIT*i
		for j in xrange(CELLWID*4):
			for k in xrange(CELLWID*4):
				a[CELLTOP+k,xloc+j,:]=LightGray
		for j in xrange(DIRECTIONS): #do cell colours
			for k in xrange(numrules[i][j]):
				it=path[i][j][k] 
				xx=xloc+it.loc.x*CELLWID
				yy=CELLTOP+it.loc.y*CELLWID
				for m in xrange(CELLWID):
					for n in xrange(CELLWID):
						for c in xrange(3):
							a[yy+n,xx+m,c]=shade[it.subcol][c]
		for j in xrange(5): #gray border lines
			for k in xrange(4*CELLWID):
				a[CELLTOP+k,xloc+j*CELLWID,:]=Gray
				a[CELLTOP+j*CELLWID,xloc+k,:]=Gray
		for j in xrange(DIRECTIONS): #black path lines
			for k in xrange(numrules[i][j]):
				it=path[i][j][k]
				xx=xloc+HALF+it.loc.x*CELLWID
				yy=CELLTOP+HALF+it.loc.y*CELLWID
				if it.type==T:
					for n in xrange(HALF+1):
						a[yy-HALF+n,xx,:]=[0,0,0] #black
				elif it.type==R:
					for n in xrange(HALF+1):
						a[yy,xx+n,:]=[0,0,0]
				elif it.type==B:
					for n in xrange(HALF+1):
						a[yy+n,xx,:]=[0,0,0]
				elif it.type==L:
					for n in xrange(HALF+1):
						a[yy,xx-HALF+n,:]=[0,0,0]
	misc.imsave('FDS3types-fract.png',a)
	print total[0],total[1],total[2],SIDE
	#save sample pic..4x4 random cells
	for j in xrange(TILEWID):
		for k in xrange(TILEWID):
			if DRAWTILINGGRID>0:
				for i in xrange(j*SIDE,(j+1)*SIDE,2): #dotted line
					pic[i][k*SIDE][:]=Black
					pic[k*SIDE][i][:]=Black
			m=rand()%COLOURS
			f=rand()%2 #to flip or not
			for n in xrange(total[m]):
				if f==0:			
					pic[j*SIDE+C[m][n].x][k*SIDE+C[m][n].y][:]=Black 
				else: #flip - swap x and y
					pic[j*SIDE+C[m][n].y][k*SIDE+C[m][n].x][:]=Black
	#fill cells with rand col
	for j in xrange(0,PICWID,10): #test each 10x10 square for unfilledness
		for k in xrange(0,PICWID,10):
			if pic[j][k][0]==255: #found a white spot - fill
				fillcol[:]=[rand()%80,rand()%120+100,rand()%80]
				print j,k,fillcol[0],fillcol[1],fillcol[2]
				Fill(j,k)
	for c in xrange(3):
		for j in xrange(PICWID):
			for k in xrange(PICWID):
				t[j,k,c]=pic[k][j][c] #swaps x and y..
	misc.imsave('FDS3types-tiling.png',t)