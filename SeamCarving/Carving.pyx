#Carving.pyx
#My naive version of seam carving, after reading about it today..
#(The algorithm is mine)

#VErsion note:abandoning this and going to v2 already.
#branching 3 times at each point is just hugely too massive/slow 
#for an image.. 3^50 = 10^23 (Avogadro hehe) .. so even 50x50
#wayyy to big. 3^20=300 million, more realistic.
#so, this method would be optimal for little blocks.
#maybe that would work, dividing image up into little blocks..
#hmm yeah, and starting new path from the place the last one finished
#to avoid seams.. but anyway.
#will do one with no branching at all.
#a path for each pixel should be enough.
#or maybe branch every 10,20,50 pixels or something....
#but for now, no branching... just find 'best way' to turn
#left, right or straight... with numpaths=width of pic-1.
DEF Width =500#image width - must be a constant for C arrays
DEF Height =500#image height - ditto
DEF MaxPaths = 100,000 #too low I guess..
cdef int n=0 #current total number of paths.
struct dirpair:
	bint L, R
struct pathtype:
	int initx
	int totdiff
	dirpair dir[Height]	
cdef pathtype path[MaxPaths]

cdef int Diff(xx,yy):
# adds difference in R, G, B between pixels (xx,yy) and (xx+1,yy)
#NB use the C abs!!! or just if diff<0, diff=-diff. si, mejor

cdef GetPaths(int level, int xloc, int pathnum): #recursive
	path[pathnum].totdiff+=Diff(xloc,level)
	if level==Height:
		return
	#so add new level
	if xloc>0: #left is possible, so add left turn to path
		path[pathnum].dir[level].L=True
		path[pathnum].dir[level].R=False #<-- initialize them to False
		#so I dont have to bother setting things to False.
		#NB but first copy whole path n into path n+1!!!

		#then increase total num of paths
		n+=1
		GetPaths(level+1,xloc-1,n) #n+1=it's a new path
	
	#Go right

	#Straight ahead
	
	return #is that statement at all needed?!
	
cpdef OK(): #NB the first path is path no. 1
	cdef int j, lowest=1,000,000
#now, to use numpy arrays in subsidiary funcs,
#I have to copy to a C array I think..
	#load image.
	
	#copy it to a C array.
	
	for j in range(Width-1):
	#hmm if width is 5.. pixels 0,1,2,3,4. paths are 0,1,2,3. so yup.
		n+=1 #add new path for each pixel on bottom row
		path[n].initx=j
		path[n].totdiff=Diff(j,0)
		GetPaths(0,j,n) #level, xloc, pathnum
	#now! Find path with lowest totdiff and remove
	for j in range(1,n+1):
		if path[j].totdiff<lowest:
			lowest=j
	#now go up image, shifting leftwards all pixels to the right of
	#the 'winning' path.
	#Find average of the two rows and put as left pixel, move
	#new pixel left into the right pixel's old place...
	#now image will be (Width-1)xHeight.
	#whoops, also need Row-deleting function....
	
	#IDEAS
	#since this doesnt use colour... why not just use B&W?
	#finding the sum of R, G, B differences..
	#abs (R1-R2) + abs(G1-G2) + abs(B1-B2)=diff
	#is that different to.. hmm well. I guess it is.
	#and maybe can use sum of squared diffs later or something..
	#although does make it A LOT slower................
		
	