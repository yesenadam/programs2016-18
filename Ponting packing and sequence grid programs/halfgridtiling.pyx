#%cython
#July 2017
#this is a version of sqsinone.pyx which does upper left halfgrid only
# INPUT: set a,b,d,e of central hvline in DEF section below. Value of "n" gives nxn grid/tiling.
# hvline is a b | e
#           ----|
#           c d | f
# where a+b=c+d and b+d=e+f
# *See my paper on the subject!
# OUTPUT:
# -grid or half/grid pic (pops up). Just upper left of grid if JUSTDOHALFGRID.
# -2d or 3d pic of tiling (if PLOTIN3D)
# 	-which is labelled with sizes if DOLABELS.
# 	-draws lil circles where the 0-size squares are, if MARKZEROS.

#mainly I need to ouput centre and radius of circles, exactly where the squares are in each p packing.
#but may as well have a struct with L,R,T,B,side,centre in an nxn array.

#use output in circleinversion4.pyx program input..

#NB getting the 0-size sq circles and font sizes right takes a bit of ad hoc juggling, see below
from sage.plot.polygon import polygon2d #polygonedgecolor
from sage.plot.circle import circle
from sage.plot.line import line2d
from sage.misc.functional import show
from sage.plot.graphics import Graphics
from sage.plot.text import text
from sage.plot.plot3d.shapes import Box
DEF MAX=500 #25 #15 #i.e. MAX x MAX is max grid size you might be needing. set and forget
DFILE="/Users/admin/sqsizes.txt"
DEF a=1 #-10 #-117 #26 #3
DEF b=2 #-0.5 +2.5#46 #-4.5 + 50.5 4951 #-49.5 + 5000.5 #10001 #99-196 #6#-6 #1
DEF d=1 #0#23 #0
DEF e=1 #2 #103#28 #5
#bools
DEF DOGRID=1 #dont draw grid png if=0
DEF DOLABELS=1 #1 if want square size labelled, 0 otherwise
DEF JUSTDOHALFGRID=0#=draws just upper left half of grid, 0=draw whole grid as before.
DEF MARKZEROS=1 #1=draws circles where the size 0 squares are
DEF PLOTIN3D=0 #1

DEF TILINGFIGSIZE=30 #20#30
DEF ZEROCIRCRAD=0.5 #5 #1 #size of the circles where the 0-size sqs are.
DEF GRIDSIZE=20
DEF GRIDFIGSIZE=8
DEF GRIDFONTSIZE=12
DEF GAP=3 #between overlapping lines on the grid
DEF n=15 #21 #nxn is dimension of square array to calculate. MUST BE ODD!!
#4 font sizes: <11 <25 <40 bigger
cdef int fontsizes[4],MINSQTOLABEL
#fontsizes[:]=[8,12,16,20] # font size for <11, <25, <40, >40
fontsizes[:]=[12,16,20,24] # font size for <11, <25, <40, >40
MINSQTOLABEL=3 #smallest square that gets a label
# if n<25:
# 	fontsizes[:]=[8,10,12,15]
# 	MINSQTOLABEL=3
# else:
#fontsizes[:]=[4,6,9,12]
#MINSQTOLABEL=6
cdef struct square:
	float L,R,T,B, side, cx,cy
	int Known #0 if everything not known yet, 1 otherwise
cdef square sq[MAX][MAX]
cdef struct sqis:
	int side,Known
cdef sqis sqi[n][n]
cdef enum:
	UP=-1,DOWN=1,RIGHT=1,LEFT=-1
cdef int nn,A
IFILE="/Users/admin/sqsizes.txt"
OFILE="/Users/admin/dfile.txt"

cdef int Even(int q):
	return q%2==0
	
cdef int Odd(int q):
	return q%2==1

cdef DoDiag(int val, int inc,int xloc, int yloc, int xdir, int ydir):
	while True:
		xloc+=1*xdir
		yloc+=1*ydir
		val+=inc
		if xloc>n-1:
			break
		if yloc<0:
			break
		if yloc>n-1:
			break
		if xloc<0:
			break
		sqi[xloc][yloc].side=val
		sqi[xloc][yloc].Known=1

cdef DoHlineTopRow(int j): #i.e. a row which at left edge is the upper half of an hline
	cdef int i
	for i in xrange(1,nn,2): #do in pairs. if nn=5 ->> i=1,3
		sq[i][j].L=sq[i-1][j].R
		sq[i][j].R=sq[i][j].L+sq[i][j].side
		sq[i][j].B=sq[i-1][j].B
		sq[i][j].T=sq[i-1][j].B+sq[i][j].side
		sq[i+1][j].L=sq[i][j].R
		sq[i+1][j].R=sq[i+1][j].L+sq[i+1][j].side
		sq[i+1][j].T=sq[i][j].T
		sq[i+1][j].B=sq[i][j].T-sq[i+1][j].side
		
cdef DoHlineBottomRow(int j): #i.e. a row which at left edge is the lower half of an hline
	cdef int i
	for i in xrange(1,nn,2): #do in pairs. if nn=5 ->> i=1,3
		sq[i][j].L=sq[i-1][j].R
		sq[i][j].R=sq[i][j].L+sq[i][j].side
		sq[i][j].T=sq[i-1][j].T
		sq[i][j].B=sq[i-1][j].T-sq[i][j].side
		sq[i+1][j].L=sq[i][j].R
		sq[i+1][j].R=sq[i+1][j].L+sq[i+1][j].side
		sq[i+1][j].B=sq[i][j].B
		sq[i+1][j].T=sq[i+1][j].B+sq[i+1][j].side

cdef GetSqs(): #0,0 is known...
	cdef int j
	print "GetSqs",nn
	DoHlineTopRow(0)
	#work out [0][1]
	for j in xrange(1,nn,2):
		sq[0][j].L=sq[0][j-1].L
		sq[0][j].R=sq[0][j].L+sq[0][j].side
		sq[0][j].T=sq[0][j-1].B
		sq[0][j].B=sq[0][j].T-sq[0][j].side
		DoHlineBottomRow(j)
		#work out [0][2]
		sq[0][j+1].R=sq[0][j].R
		sq[0][j+1].L=sq[0][j+1].R-sq[0][j+1].side
		sq[0][j+1].T=sq[0][j].B
		sq[0][j+1].B=sq[0][j+1].T-sq[0][j+1].side
		DoHlineTopRow(j+1)
		
cdef CalculateSquareSizes(): #this was main() of another program. Sorry for crazy design :-)
	cdef int val,xloc,yloc,inc1, inc2, inc3,i,j,c
	cdef int cen=(n-1)/2 # centre - position of a, then 0,0 is also UL of hline...
	for i in xrange(n):
		for j in xrange(n):
			sqi[i][j].Known=0
	sqi[cen][cen].side=a
	sqi[cen+1][cen].side=b
	sqi[cen+1][cen+1].side=d
	sqi[cen+2][cen].side=e
	sqi[cen][cen].Known=1
	sqi[cen+1][cen].Known=1
	sqi[cen+1][cen+1].Known=1
	sqi[cen+2][cen].Known=1
	#fill in LL of first hline
	c=a+b-d
	sqi[cen][cen+1].side=c
	sqi[cen][cen+1].Known=1
	inc1=b-c
	inc3=e-d
	inc2=a-d
	#do diag to upper right
	DoDiag(b,inc1,cen+1,cen,RIGHT,UP)
	DoDiag(b,-inc1,cen+1,cen,LEFT,DOWN)
	DoDiag(a,inc2,cen,cen,LEFT,UP)
	DoDiag(a,-inc2,cen,cen,RIGHT,DOWN)
	DoDiag(b,b-(b+d-e),cen+1,cen,LEFT,UP)
	DoDiag(b,-(b-(b+d-e)),cen+1,cen,RIGHT,DOWN)
	DoDiag(e,inc3,cen+2,cen,RIGHT,UP)
	DoDiag(e,-inc3,cen+2,cen,LEFT,DOWN)
	#now loop over entire array.. at end, check if all are Known
	#NB n-1 is max dimension.
	while True:
		for i in xrange(n):
			for j in xrange(n):
				if sqi[i][j].Known:
					continue
				if i%2==j%2: #Even(i) and Even(j): #UL of hline
					if i<n-1 and j<n-1: #check 1. UL of hline #can be UL of hline
						if sqi[i+1][j].Known and sqi[i][j+1].Known and sqi[i+1][j+1].Known:
							sqi[i][j].side=sqi[i][j+1].side+sqi[i+1][j+1].side-sqi[i+1][j].side
							sqi[i][j].Known=1
					if i<n-1 and j>0: #2. LL of vline
						if sqi[i][j-1].Known and sqi[i+1][j].Known and sqi[i+1][j-1].Known:
							sqi[i][j].side=sqi[i+1][j].side+sqi[i+1][j-1].side-sqi[i][j-1].side
							sqi[i][j].Known=1
					if i>0 and j<n-1: #3. UR of vline
						if sqi[i-1][j].Known and sqi[i-1][j+1].Known and sqi[i][j+1].Known:
							sqi[i][j].side=sqi[i-1][j].side+sqi[i-1][j+1].side-sqi[i][j+1].side
							sqi[i][j].Known=1
					if i>0 and j>0: #4. LR of hline
						if sqi[i-1][j].Known and sqi[i-1][j-1].Known and sqi[i][j-1].Known:
							sqi[i][j].side=sqi[i-1][j-1].side+sqi[i][j-1].side-sqi[i-1][j].side
							sqi[i][j].Known=1
				else:
					if i<n-1 and j>0: #check 1. LL of hline
						if sqi[i][j-1].Known and sqi[i+1][j].Known and sqi[i+1][j-1].Known:
							sqi[i][j].side=sqi[i][j-1].side+sqi[i+1][j-1].side-sqi[i+1][j].side
							sqi[i][j].Known=1
					if i>0 and j<n-1: #2. UR of hline
						if sqi[i-1][j].Known and sqi[i-1][j+1].Known and sqi[i][j+1].Known:
							sqi[i][j].side=sqi[i-1][j+1].side+sqi[i][j+1].side-sqi[i-1][j].side
							sqi[i][j].Known=1
					if i<n-1 and j<n-1: #3.UL of vline #can be UL of hline
						if sqi[i+1][j].Known and sqi[i][j+1].Known and sqi[i+1][j+1].Known:
							sqi[i][j].side=sqi[i+1][j].side+sqi[i+1][j+1].side-sqi[i][j+1].side
							sqi[i][j].Known=1
					if i>0 and j>0: #4. LR of vline
						if sqi[i-1][j].Known and sqi[i-1][j-1].Known and sqi[i][j-1].Known:
							sqi[i][j].side=sqi[i-1][j].side+sqi[i-1][j-1].side-sqi[i][j-1].side
							sqi[i][j].Known=1
		finished=1
		for j in xrange(n):
			for i in xrange(n):
				if sqi[i][j].Known==0:
					finished=0
		if finished:
			break
	txt = open(DFILE, "w")
	txt.write("%d\n" % n)
	for j in xrange(n):
		for i in xrange(n):
			txt.write("%d,%d,%d\n" % (i,j,sqi[i][j].side))
	txt.close()
	
cpdef OK():
	global nn
	cdef int lineLength, invj, parity,k,sqSize
	CalculateSquareSizes()
	txt = open(IFILE, "r")
	NL=0
	for line in txt.readlines():
		if NL==0:
			nn=int(line)
			withoutsize=int(line)*int(line)
			print "nn=",nn
		else:
			words=line.split(",")
			i=int(words[0]) 
			j=int(words[1]) 
			sq[i][j].side=int(words[2]) 
		NL+=1
	txt.close()
	for i in xrange(0,nn):
		for j in xrange(0,nn):
			sq[i][j].Known=0
	A=sq[0][0].side
	sq[0][0]=[0,A,A,0,A,A/2,A/2,1]
	GetSqs()
	f=Graphics()		
	g=Graphics()		
	count=0
	txt = open(OFILE, "w")
	#Im surprised this works - txt is 2 different files at the same time.
	txt.write("%d\n" % nn)
	for j in xrange(nn):
		if JUSTDOHALFGRID:
			if j>(nn-1)/2+1:
				lineLength=nn-j+1
			else:
				lineLength=nn-j+2
			if lineLength>nn:
				lineLength=nn
		else:
			lineLength=nn
		for i in xrange(lineLength): 
			if DOGRID>0: #do grid
				invj=nn-j
				# NB put "$%d$" %  before int in next line for latex font
				g+=text(int(sq[i][j].side),(i*GRIDSIZE+GRIDSIZE/2,invj*GRIDSIZE+GRIDSIZE/2),
				fontsize=GRIDFONTSIZE,color="black")
				parity=(i+j)%2
				if parity==0: #draw hline
					p1=[i*GRIDSIZE+GAP,invj*GRIDSIZE] #underbar
					p2=[(i+1)*GRIDSIZE,invj*GRIDSIZE]
					p3=[(i+1)*GRIDSIZE,invj*GRIDSIZE+GAP] #rightbar
					p4=[(i+1)*GRIDSIZE,(invj+1)*GRIDSIZE]
					g+=line2d([p1,p2],color="blue")
					g+=line2d([p3,p4],color="blue")
					if i==0: #leftbar
						p3=[i*GRIDSIZE,invj*GRIDSIZE]
						p4=[i*GRIDSIZE,(invj+1)*GRIDSIZE-GAP]
						g+=line2d([p3,p4],color="blue")
				else:
					p1=[i*GRIDSIZE,invj*GRIDSIZE]
					p2=[(i+1)*GRIDSIZE-GAP,invj*GRIDSIZE]
					p3=[(i+1)*GRIDSIZE,invj*GRIDSIZE]
					p4=[(i+1)*GRIDSIZE,(invj+1)*GRIDSIZE-GAP]
					g+=line2d([p1,p2],color="blue")
					g+=line2d([p3,p4],color="blue")
					if i==0:
						p3=[i*GRIDSIZE,invj*GRIDSIZE+GAP]
						p4=[i*GRIDSIZE,(invj+1)*GRIDSIZE]
						g+=line2d([p3,p4],color="blue")
# 			#do tiling
			pts=[[sq[i][j].L,sq[i][j].B],[sq[i][j].R,sq[i][j].B],
			[sq[i][j].R,sq[i][j].T],[sq[i][j].L,sq[i][j].T]]
			sq[i][j].cx=(sq[i][j].L+sq[i][j].R)/2
			sq[i][j].cy=(sq[i][j].T+sq[i][j].B)/2
			if PLOTIN3D==1:
				rad=abs(sq[i][j].side/2)
				Col=[0,0,0]
				Col[0]=255-int(rad*8) #adjust 3D colours with these lines
				Col[1]=int((sq[i][j].cx-rad)*(255.0/623.0))-int(rad*8)
				Col[2]=int((sq[i][j].cy-rad+390)*(255.0/(390.0+59.0)))-int(rad*8)
				for k in xrange(3):
					if Col[k]>255:
						Col[k]=255
					if Col[k]<0:
						Col[k]=0
				f+=Box([rad,rad,rad], color='#%02x%02x%02x' % \
				(Col[0],Col[1],Col[2])).translate(sq[i][j].cx,sq[i][j].cy,rad)
			else:
				f+=polygon2d(pts,fill=False,color='black')#,color='#%02x%02x%02x'
			if DOLABELS and PLOTIN3D==0: 
				sqSize=abs(int(sq[i][j].side))
				if sqSize<11:
					fsize=fontsizes[0]
				elif sqSize<25:
					fsize=fontsizes[1]
				elif sqSize<40:
					fsize=fontsizes[2]
				else:
					fsize=fontsizes[3]
				if sqSize==0:
					if MARKZEROS:
						f+=circle((sq[i][j].cx,sq[i][j].cy),ZEROCIRCRAD,color='black',thickness=0.5)
				elif sqSize>=MINSQTOLABEL:
					f+=text(sqSize,(sq[i][j].cx,sq[i][j].cy),color='black',fontsize=fsize)
			txt.write("%.5f,%.5f,%.5f\n" % (sq[i][j].cx,sq[i][j].cy,sq[i][j].side)) #NB side not radius!!
			count+=1		
	f.show(axes=False,figsize=TILINGFIGSIZE,aspect_ratio=1)
	if DOGRID>0:
		g.show(axes=False,figsize=GRIDFIGSIZE,aspect_ratio=1)
	txt.close()