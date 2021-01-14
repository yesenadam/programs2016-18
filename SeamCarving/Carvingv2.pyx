#Carvingv2.pyx
#My naive version of seam carving, after reading about it today..
#(The algorithm is mine)

#for now, no branching at all.
#v1 will use 3 branches at each level. good for tiny blocks.
#but ridiculous exponential growth, impossible for big pics.
import numpy as np
cimport numpy as np
from scipy import misc
fn="/Downloads-1/Tuscany.png"#PanjinCropOrig-170+80-7331-340+160-7331-680+320-7331-1360+640-7331.png"#PanjinCropOrig-170+80-321ave-340+160-321ave.png"#Panjin-Red-Beach-China--620x614.png"
na=fn[:fn.find('.')] #strip off the '.png'
DEF Width =620#image width - must be a constant for C arrays
DEF Height =422#image height - ditto
DEF MaxPaths = Width#100,000 #too low I guess..
DEF NumLoops=400
#cdef int wid=Width, hei=Height # they decrease each time
cdef:
	struct dirpair:
		bint L, R
	struct pathtype: #now (v2) the initx= pathnum.
		int totdiff
		dirpair dir[Height]	
	pathtype path[MaxPaths]
	int b[Width][Height][3]
	int Diff(int xx,int yy):
		global b
		cdef int i, di=0, coldiff
	# adds difference in R, G, B between pixels (xx,yy) and (xx+1,yy)
		for i in range(3):
			coldiff=b[xx][yy][i]-b[xx+1][yy][i]
			if coldiff<0:
				di-=coldiff # ie adding -coldiff. instead of abs()
			else:
				di+=coldiff
		return di

cpdef OK(): #NB the first path is path no. 1
	global b, path
	cdef int which, wid, hei, aa, bb, cc, i, j, k, initx, inity, wh, tdiff, m, lowest
	#load image.
	cdef np.ndarray[np.uint8_t, ndim=3] a #, b
	a=misc.imread(fn)
	initx=a.shape[1] #arghh so its sideways? so should rot90 the array..
	inity=a.shape[0]
	#copy it to a C array
	for j in range(initx):
		for k in range(inity):
			for i in range(3):
				b[j][k][i]=a[k][j][i] #indices swapped so right side up.
	wid=initx
	hei=inity
	for m in range(NumLoops):
		#need to do rows too!! maybe when vert path finder works well..
		#Initialize path array, - is it already? especially dirs to False.
		for j in range(wid):
			for k in range(hei):
				path[j].dir[k].L=False
				path[j].dir[k].R=False
		for j in range(wid-1): #a path up starts from each bottom row pixel
			tdiff=Diff(j,0)
			#the dir[] for level 0 will hold direction path goes to get
			#to level 1.. which will be minimum of the 2 or 3.
			xloc=j #initial x pos
			for k in range (hei-1): #H-1? think so. dont need to add last row.
				#so, 3 cases. 1. LS 2. RS 3. LRS (left right and/or straight)	
				if xloc>0: #to avoid index errors
					aa=Diff(xloc-1,k+1) #left
				bb=Diff(xloc,k+1) #straight
				if xloc<wid-2:
					cc=Diff(xloc+1,k+1) #go right
				if xloc==0: #cant go left
					if bb<cc: #so go straight
						tdiff+=bb
					else: #go right
						path[j].dir[k].R=True
						tdiff+=cc
						xloc+=1				
					continue	
				if xloc>wid-3: #as far right as possible, so cant go right
					if bb<aa: #so go straight
						tdiff+=bb
					else: #go left
						path[j].dir[k].L=True
						tdiff+=aa
						xloc-=1				
					continue	
				#so.. must be able to go L, R or straight
				#wh: 0=left, 1=straight, 2=right
				if aa<bb: #so, not straight
					if aa<cc:	wh=0#so, left
					else:	wh=2 #go right
				else: #so, not left
					if bb<cc:	wh=1 #straight
					else:	wh=2 #right
				if wh==0: #left
					path[j].dir[k].L=True
					xloc-=1
					tdiff+=aa
					continue
				#use case or elses here to speed up IFs.
				if wh==1: #straight
					tdiff+=bb
					continue
				#next line not needed - wh must be 2.
				if wh==2: #right
					path[j].dir[k].R=True
					xloc+=1
					tdiff+=cc
			path[j].totdiff=tdiff
#			print "Path",j,"total diff=",tdiff
		#now! Find path with lowest totdiff and remove
		lowest=1000000
		for j in range(1,wid+1):
			if path[j].totdiff<lowest:
				lowest=path[j].totdiff
				which=j
		print m,"Lowest total=",lowest,"Path no.",which
#		for k in range(hei):
#			print "path[",which,"dir[",k,".L:",path[which].dir[k].L,"R:",path[which].dir[k].R
		#now go up image, shifting leftwards all pixels to the right of
		#the 'winning' path.
		#Find average of the two rows and put as left pixel, move
		#new pixel left into the right pixel's old place...
		#now image will be (Width-1)xHeight.
		#whoops, also need Row-deleting function....
		xloc=which #the starting pixel is also the index of path
		#just copy these new c-array vals to a-array,
		#PLUS A BLACK LINE AROUND THE EDGE!!
		#otherwise.... the top/right edge will drag across screen..
#		print "hei=",hei,"wid=",wid,"initx=",initx,"inity=",inity
		for k in range(hei): # hmm in top row? what happens.. goes straight.
#			print k, xloc
			#put black line on a-array, here I guess
			for i in range(3):
				a[k][xloc][i]=0 #<-- swapped indices. is right, no?
			#get ave of pixels & put in left pixel
			for i in range(3):
				b[xloc][k][i]=(b[xloc][k][i]+b[xloc+1][k][i])/2
			#slide remaining row left
			for j in range(xloc+1,wid-1):
				for i in range(3):
					b[j][k][i]=b[j+1][k][i]
			#these next lines dont apply to top row, but are harmless
			#so better not to waste time testing if they should apply....
			if path[which].dir[k].L==True:	
				xloc-=1 #'==True' not needed i guess
			else:
				if path[which].dir[k].R==True:	
					xloc+=1
		#NOW save a-array image. NOW!
		#then copy c-array to a array, with black line at r-edge.
		name="/Downloads-1/tuscanypics/0%d.png" % m 
		misc.imsave(name,a)
		wid-=1 #<-- this line needed here.
		for j in range(wid): #initx#hmm no, only go to wid
			for k in range(inity):
				for i in range(3):
					a[k][j][i]=b[j][k][i]#=a[k][j][i] #indices swapped so right side up.
		#put black line on right edge of array
		for k in range(inity):
				for i in range(3):
					a[k][wid][i]=0#b[j][k][i]#=a[k][j][i] #indices swapped so right side up.
		#I suspect that last looping is faster with i loop on the
		#outside. is it? how much faster? hmm.
		#is it faster for numpy arrays or c arrays or both?
	#PUT END OF THAT LOOP HERE

#IDEAS
		
	#better to make a new ndarray for saving pic?
	#although I want to save every time...
	#I guess better to have same-size images.....?
	#hmm probably better to write to new array, centre
	#on a black boundary <--- SIIII.
		
	#since this doesnt use colour... why not just use B&W?
	#finding the sum of R, G, B differences..
	#abs (R1-R2) + abs(G1-G2) + abs(B1-B2)=diff
	#is that different to.. hmm well. I guess it is.
	#and maybe can use sum of squared diffs later or something..
	#although does make it A LOT slower................
	
	#maybe loop, saving image each time.. make movie of shrinking image..
	
	#******* draw the chosen path on an intermediate image? hmm....
	#maybe draw it black before deleting row...
	#otherwise how will I see it?!
	# = one good reason to work with numpy arrays!!
	#well... dont really need 'a' array after loading it.
	#use it for display? write the chosen path in black and delete...
	
	#it would be nice to see all paths! I guess they group together..
	#otherwise whole pic would be black.. (or just show every 5th one
	#or something..........
	
	