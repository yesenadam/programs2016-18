#TMfract3types.pyx - Thue-Morse 2D tiling fractal
#from N Frank paper "Fractal Dual Substitution Tilings" p3

#NB CHANGE THE OTHER VERSIONS:
# -specify ALL types in function argument list. otherwise is YELLOWWW.
# - setting array points with eg [0,0,0] array is YELLOW.

import numpy as np
cimport numpy as np
from scipy import misc
from libc.stdlib cimport rand
DEF MAXPTS=12000 #NB this must be larger than number of points in each tile
DEF MAXLEV=4 
DEF ARRAYWID=850 
DEF ARRAYHEI=400
DEF MARG=20
DEF COLOURS=3 #White, Blue, Green
DEF DIRECTIONS=4 #Top, Right, Bottom, Left
DEF MAXPATHSEGS=13 #NB this must be > largest value in numrules[][] array
DEF GRIDSIDE=4
DEF side=GRIDSIDE**MAXLEV
DEF TILEWID=8 # times 256 =2048
DEF PICWID=TILEWID*side
#------- User settings: ------
DEF DRAWTILINGGRID=1 #set to 0 =DONT DRAW GRID on tiling pic, 1 = DRAW
cdef:
	enum etype:
		T=0, R=1, B=2, L=3 #type
	enum ecol:
		Wh=0,Bl=1,Gr=2	#subcol
# 	enum:
# 		T=0, R=1, B=2, L=3 #type
# 		Wh=0,Bl=1,Gr=2	#subcol
	struct pt:
		int x,y
	pt C[COLOURS][MAXPTS] #C[0]=white pixels, C[1]=blue
	int col, tot[COLOURS] #total num of white, blue pixels stored so far
	int numrules[COLOURS][DIRECTIONS] #stores num of steps in each subpath
	struct pa:
		ecol subcol
		etype type
		pt loc
	pa path[COLOURS][DIRECTIONS][MAXPATHSEGS], it
	unsigned short Black[3],Blue[3],Green[3], Gray[3], LightGray[3], \
		shade[3][3], pic[PICWID][PICWID][3], fillcol[3]
	Fill(int x, int y):
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
	int Done(pt d,int lev):
		if lev==MAXLEV:
			C[col][tot[col]]=d #add point to end of list of pts
			tot[col]+=1
			return 1 # i.e. otherwise return 0
Black[:]=[0,0,0]
Gray[:]=[100,100,100]
LightGray[:]=[180,180,180]
shade[Wh][:]=[255,255,255] #white
shade[Bl][:]=[80,80,255] #blue
shade[Gr][:]=[0,180,0] #green

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

cdef Do(pa which,pt where, int lev):
	cdef int n
	where=[where.x*GRIDSIDE+which.loc.x,where.y*GRIDSIDE+which.loc.y]
	if not Done(where,lev):
		for n in xrange(numrules[which.subcol][which.type]):
			Do(path[which.subcol][which.type][n],where,lev+1)
cpdef OK():
	global fillcol,col
	cdef:
		int i, j, k, c, xx, yy, m, n, f
		np.ndarray[np.uint8_t,ndim=3] a= \
			np.empty((ARRAYHEI,ARRAYWID,3),dtype=np.uint8)
		np.ndarray[np.uint8_t,ndim=3] t= \
			np.empty((PICWID,PICWID,3),dtype=np.uint8)
		pt z=[0,0]
	tot[:]=[0,0,0]
	for col in xrange(COLOURS): #White, Blue, Green
		for j in xrange(DIRECTIONS): #T,R,B,L
			Do([col,j,z],z,0) #construct the fractal paths
	a.fill(255) #make array for tiles image white
	for j in xrange(PICWID):
			for i in xrange(PICWID):
				pic[i][j][0]=255 #make tiling image white
				#well- red is white enough - only red pix tested later by Fill
	for i in xrange(side): #coloured squares
		for k in xrange(side):
			for j in xrange(3):
				a[MARG+k,MARG*2+side+i,j]=shade[Bl][j]
				a[MARG+k,MARG*3+2*side+i,j]=shade[Gr][j]
	for k in xrange(3):
		for i in xrange(COLOURS): 
			for j in xrange(tot[i]): #plot fractal points
				a[MARG+C[i][j].y,MARG+C[i][j].x+i*(MARG+side),k]=0 #black
			for j in xrange(side): #black frame around cells
				a[MARG+j,MARG+i*(MARG+side),k]=0 #LHS
				a[MARG+j,MARG+side+i*(MARG+side),k]=0 #RHS
				a[MARG,MARG+i*(MARG+side)+j,k]=0 #top
				a[MARG+side,MARG+i*(MARG+side)+j,k]=0 #bot
	#print grids underneath
	DEF CELLWID=16
	DEF GAP=20 #between tiles and cells
	DEF CELLTOP=MARG+side+GAP
	DEF XOFF=100
	#first, grey over whole cell - so that white can be seen for type 1.
	for i in xrange(COLOURS):
		for j in xrange(CELLWID*4):
			for k in xrange(CELLWID*4):
				for c in xrange(3):
					a[CELLTOP+k,MARG+XOFF+(MARG+side)*i+j,c]=LightGray[c]
#	for i in xrange(COLOURS):
		for j in xrange(DIRECTIONS): #do cell colours
			for k in xrange(numrules[i][j]):
				it=path[i][j][k] #subcol,type,loc - i=which map,subcol=colour to draw,type=pos
				xx=MARG+XOFF+(MARG+side)*i+it.loc.x*CELLWID
				yy=CELLTOP+it.loc.y*CELLWID
				for m in xrange(CELLWID):
					for n in xrange(CELLWID):
						for c in xrange(3):
							a[yy+n,xx+m,c]=shade[it.subcol][c]
		for j in xrange(5): #gray border lines
			for k in xrange(4*CELLWID):
				for c in xrange(3):
					a[CELLTOP+k,MARG+XOFF+(MARG+side)*i+j*CELLWID,c]=Gray[c]
					a[CELLTOP+j*CELLWID,MARG+XOFF+(MARG+side)*i+k,c]=Gray[c]
		for j in xrange(DIRECTIONS): #black path lines
			for k in xrange(numrules[i][j]):
				it=path[i][j][k]
				xx=MARG+XOFF+(MARG+side)*i+it.loc.x*CELLWID
				yy=CELLTOP+it.loc.y*CELLWID
				if it.type==T:
					for n in xrange(CELLWID/2+1):
						for c in xrange(3):
							a[yy+n,xx+CELLWID/2,c]=0 #black
				elif it.type==R:
					for n in xrange(CELLWID/2+1):
						for c in xrange(3):
							a[yy+CELLWID/2,xx+CELLWID/2+n,c]=0
				elif it.type==B:
					for n in xrange(CELLWID/2+1):
						for c in xrange(3):
							a[yy+CELLWID/2+n,xx+CELLWID/2,c]=0
				elif it.type==L:
					for n in xrange(CELLWID/2+1):
						for c in xrange(3):
							a[yy+CELLWID/2,xx+n,c]=0
	misc.imsave('TMt3t-fract-.png',a)
	print tot[0],tot[1],tot[2],side
	#save sample pic..4x4 random cells
	for j in xrange(TILEWID):
		for k in xrange(TILEWID):
			if DRAWTILINGGRID>0:
					for i in xrange(j*side,(j+1)*side,2): #dotted line
						pic[i][k*side][:]=Black
						pic[k*side][i][:]=Black
			m=rand()%COLOURS
			f=rand()%2 #to flip or not
			for n in xrange(tot[m]):
				if f==0:			
					pic[j*side+C[m][n].x][k*side+C[m][n].y][:]=Black #[0,0,0]
				else: #flip - swap x and y
						pic[j*side+C[m][n].y][k*side+C[m][n].x][:]=Black
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
	misc.imsave('TMt3t-tiling-.png',t)