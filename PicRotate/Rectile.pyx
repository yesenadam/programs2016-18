#%cython
# RectangleTesselation v3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
from sage.misc.functional import show
from sage.plot.graphics import Graphics
from sage.plot.line import line2d
from sage.plot.text import text
from sage.plot.polygon import polygon2d as p
from sage.misc.latex import latex
DEF cx=30
DEF cy=30
DEF MAXDIM=60
DEF gridwidth=52 # number of cells x cells to show on grid
DEF H=gridwidth/2 #<-- NB ** must be even!! won't work otherwise
DEF TESSH=H-1 #half-width of tesselation to draw
DEF INIT=-1000 #pos for unset sides
cdef bint Success
cdef int i,j,k
f=Graphics()
cdef struct sq: 
    int w,h #length of sides
    bint WK,HK #true if width, height known
    int L,R,T,B #x/y loc of sides in tesselation
    bint D #true if drawn in tesselation already
cdef sq a[MAXDIM][MAXDIM], *C #used to point to current rect
cdef EnterSize(int x[2], int wid, int hei): #to manually enter a few rects to start with. See below
    C = &a[x[0]+cx][x[1]+cy]
    C.w=wid
    C.h=hei
    C.WK=True
    C.HK=True
cdef ExtrapolateWidths(int xoff, int yoff): #try filling widths diagonally from known squares
    global Success
    cdef sq *opp=&a[i-xoff][j-yoff] #i.e. 'opp' is on the opposite side of current square to 'new'
    cdef sq *new=&a[i+xoff][j+yoff]
    if opp.WK and not new.WK: #ie 2 in a row, fill the third one with sequence
        new.w=(a[i][j].w-opp.w)+a[i][j].w
        new.WK=True
        Success=True
cdef ExtrapolateHeights(int xoff, int yoff):
    global Success
    cdef sq *opp=&a[i-xoff][j-yoff] #i.e. 'opp' is on the opposite side of current square to 'new'
    cdef sq *new=&a[i+xoff][j+yoff]
    if opp.HK and not new.HK:
        new.h=(a[i][j].h-opp.h)+a[i][j].h
        new.HK=True
        Success=True
cdef Check(int *aa,int *bb,int *cc,int *dd,bint *Knaa,bint *Knbb,bint *Kncc,bint *Kndd):
#    global Success #checks if 3 rects from an hline/vline already known, if so adds the 4th.
    if Kncc[0] and Knaa[0] and Knbb[0] and not Kndd[0]: #if a,b,c known, and not d, d=a+b-c
        dd[0]=aa[0]+bb[0]-cc[0] # this [0] just dereferences pointers in cython 
        Kndd[0]=True 
        Success=True
    if Kndd[0] and Knaa[0] and Knbb[0] and not Kncc[0]:
        cc[0]=aa[0]+bb[0]-dd[0] 
        Kncc[0]=True 
        Success=True
    if Knaa[0] and Kncc[0] and Kndd[0] and not Knbb[0]:
        bb[0]=cc[0]+dd[0]-aa[0] 
        Knbb[0]=True                     
        Success=True
    if Knbb[0] and Kncc[0] and Kndd[0] and not Knaa[0]: 
        aa[0]=cc[0]+dd[0]-bb[0] 
        Knaa[0]=True
        Success=True
cdef bint Extrapolate():
    global i, j, k, Success
    cdef bint *Knaa, *Knbb, *Kncc, *Kndd
    cdef int *aa, *bb, *cc, *dd, u, v
    Success=False
    for i in range(cx-H,cx+H):
        #tries to fill empty grid numbers. returns True if it's made progress, else False.
        for j in range(cy-H,cy+H):
            if a[i][j].WK:
                for u in range(-1,2,2):
                    for v in range(-1,2,2):
                        ExtrapolateWidths(u,v) 
            if a[i][j].HK:
                for u in range(-1,2,2): #i.e. -1 then 1
                    for v in range(-1,2,2):
                        ExtrapolateHeights(u,v) #try extending heights
    for i in range(cx-H,cx+H+1): #now try to fill in h-lines.
        for k in range(cy-H,cy+H+1,2):  #cy-H must be even  
            j=k+i%2 #to get the checkerboard pattern. i & j are both odd or both even.
            #let c (i+0,j+0) = bottom left of an h-line.
            Check(&a[i][j+1].w,&a[i+1][j+1].w,&a[i][j].w,&a[i+1][j].w, \
             &a[i][j+1].WK, &a[i+1][j+1].WK, &a[i][j].WK, &a[i+1][j].WK)
    for i in range(cx-H,cx+H+1):  #try to complete VLINES
        for k in range(cy-H+1,cy+H+1,2): #cy-H+1 must be odd
            j=k+i%2 #i & j are now opposite parity.
            Check(&a[i][j+1].h,&a[i][j].h,&a[i+1][j+1].h,&a[i+1][j].h, \
             &a[i][j+1].HK, &a[i][j].HK, &a[i+1][j+1].HK, &a[i+1][j].HK)
    return Success # true if anything has been learnt/added this time through
cdef ShowGridVals(): #draws the known grid values on the grid
    global f,i,j
    for i in range(cx-H,cy+H):
        for j in range(cx-H,cy+H):
            if a[i][j].WK: #if width known, print it
                f+=text("${}$".format(a[i][j].w),(i+0.25,j+0.75))  
            if a[i][j].HK:
                f+=text("${}$".format(a[i][j].h),(i+0.75,j+0.25))  
cdef Draw(int x,int y):
    global f
    cdef sq *S = &a[x][y]
    f+=p([[S.L,S.B],[S.R,S.B],[S.R,S.T],[S.L,S.T]],fill=False,color="black")
#    f+=text("${},{}$".format(S.w,S.h),((S.L+S.R)/2.0,(S.T+S.B)/2.0))   
    a[x][y].D = True # has been Drawn
cdef DrawAndFindType1NeighboursSides(int X, int Y):
    if X>cx+TESSH or X<cx-TESSH or Y>cy+TESSH or Y<cy-TESSH:
        return
    cdef sq *C, *S = &a[X][Y]
    Draw(X,Y)
    #given type 1 rect at X,Y, work out neighbours' sides positions
    #rect to right
    C=&a[X+1][Y]
    if not C.D and C.h>0 and C.w>0: #if not drawn yet, and has sides>0
        C.T=S.T
        C.L=S.R 
        C.R=C.L+C.w
        C.B=C.T-C.h
        DrawAndFindType2NeighboursSides(X+1,Y)
    #rect above
    C=&a[X][Y+1]
    if not C.D and C.h>0 and C.w>0:
        C.T=S.T+C.h
        C.L=S.L
        C.R=S.L+C.w
        C.B=S.T
        DrawAndFindType2NeighboursSides(X,Y+1)
    #rect below
    C=&a[X][Y-1]
    if not C.D and C.h>0 and C.w>0:
        C.T=S.B #a[X][Y].B
        C.L=S.R-C.w
        C.R=S.R #a[X][Y].R
        C.B=S.B-C.h
        DrawAndFindType2NeighboursSides(X,Y-1)
    #rect to left
    C=&a[X-1][Y]
    if not C.D and C.h>0 and C.w>0:
        C.T=S.B+C.h
        C.L=S.L-C.w
        C.R=S.L 
        C.B=S.B 
        DrawAndFindType2NeighboursSides(X-1,Y)
cdef DrawAndFindType2NeighboursSides(int X, int Y):
    if X>cx+TESSH or X<cx-TESSH or Y>cy+TESSH or Y<cy-TESSH:
        return
    cdef sq *C, *S = &a[X][Y]
    Draw(X,Y)
    #given type 2 rect at X,Y, work out neighbours' sides positions
    C=&a[X+1][Y] #rect to right
    if not C.D and C.h>0 and C.w>0:
        SetSides(C,S.B+C.h,S.R+C.w,S.B,S.R)
        DrawAndFindType1NeighboursSides(X+1,Y)
    C=&a[X][Y+1] #rect above
    if not C.D and C.h>0 and C.w>0:
        SetSides(C,S.T+C.h,S.R,S.T,S.R-C.w)
        DrawAndFindType1NeighboursSides(X,Y+1)
    C=&a[X][Y-1] #rect below
    if not C.D and C.h>0 and C.w>0:
        SetSides(C,S.B,S.L+C.w,S.B-C.h,S.L) 
        DrawAndFindType1NeighboursSides(X,Y-1)
    C=&a[X-1][Y]  #rect to left
    if not C.D and C.h>0 and C.w>0:
        SetSides(C,S.T,S.L,S.T-C.h,S.L-C.w)
        DrawAndFindType1NeighboursSides(X-1,Y)
cdef SetSides(sq *C,int T, int R, int B, int L):
    C.T=T
    C.R=R
    C.B=B
    C.L=L
#Initialize vars
for i in range(MAXDIM):
    for j in range(MAXDIM):
        C=&a[i][j]
        C.WK=False
        C.HK=False
        C.D=False
        SetSides(C,INIT,INIT,INIT,INIT) #INIT =-1000
#draw grid
for i in range(cx-H,cx+H,2):
    for j in range(cx-H,cx+H,2):
        for k in range(2):
            f+=line2d([[i+0.1+k,j+1+k],[i+1.9+k,j+1+k]],color="black")
            f+=line2d([[i+k+1,j+1.1-k],[i+k+1,j+2.9-k]],color="black")
#manually enter known vals  
EnterSize([0,0],3,2) #enter w=3,h=2 in cell (20,20)= (centre) = [0,0]
EnterSize([1,0],6,4) 
EnterSize([2,0],6,2) 
EnterSize([0,1],5,3) 
EnterSize([1,1],4,3) 
EnterSize([2,1],7,5) 
while Extrapolate():
    pass 
ShowGridVals()
show(f, aspect_ratio=1,figsize=12)
f=Graphics()
C=&a[cx][cy] #position rect [cy][cy] with its bottom right at cx,cy, then work outwards
SetSides(C,cy+C.h,cx+C.w,cy,cx) #pointer,top,right,bottom,left sides.
##[cx,cy] is type 1 - bottom left of an h-line. its perp neighbours are type2.
DrawAndFindType1NeighboursSides(cx,cy)
show(f,aspect_ratio=1,figsize=18,axes=False)