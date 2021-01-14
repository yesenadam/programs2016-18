#Carvingv4.pyx - written in its entirety today 21 Sept 2016. Man I'm exhausted. :-)
#My naive version of seam carving, after reading about it today..
#(The algorithm is mine)

#version 4 - improved I hope..
#Just didnt want to change v3 which works..

import numpy as np
cimport numpy as np
#from libcpp cimport bool
from scipy import misc
fn="/Downloads-1/streeton.png"#PanjinCropOrig-170+80-7331-340+160-7331-680+320-7331-1360+640-7331.png"#PanjinCropOrig-170+80-321ave-340+160-321ave.png"#Panjin-Red-Beach-China--620x614.png"
na=fn[:fn.find('.')] #strip off the '.png'
folderToWrite="/Downloads-1/streeton/"
name=""
#make these 'plenty' so they dont need to be changed. I guess having b array
#larger than necessary doesnt slow it down THAT much. Q How much? Find out.

#TO DO
#Add bit that saves an image every 50 or 100 frames.. maybe 10 from the whole range.
#ie in a different folder. To save bothering to do that.
DEF Width =1088#59#620#image width - must be a constant for C arrays
DEF Height =720#05#422#image height - ditto
DEF MaxSide = Width #NB!! or = Height if Height>Width #<-- fix this so it's automatic
DEF NumLoops=1000#720#500
cdef float tax=5 #multiplier penalty 'tax'for path going straight, to deter that
cdef int j, k, m=-1, wid, hei #frame number
def GetFilename():
	global m
	m+=1
	return folderToWrite+"0%d.png" % m 
cdef:
	inline int Compare(int aa, int bb, int cc):
		if aa<bb: #so, not straight
			if aa<cc:	return 0#so, left
			else:	return 2 #go right
		else: #so, not left
			if bb<cc:	return 1 #straight
			else:	return 2 #right	
	InitializePath():
		global path
		for j in range(wid):		
			for k in range(hei):
				path[j].dir[k].L=False
				path[j].dir[k].R=False
	struct dirpair:
		bint L, R #Im sure 'bint' is (yet another) Python gag!
	struct pathtype: 
		int totdiff
		dirpair dir[MaxSide]	
	pathtype path[MaxSide]
	int b[Width][Height][3]
	inline int Taxed(int n): 
		cdef float nf=n
		nf=tax*nf
		return <int> nf #try 1.5
	inline int Diff(int xx,int yy):
		cdef int i, di=0, coldiff
	# adds difference in R, G, B between pixels (xx,yy) and (xx+1,yy)
		for i in range(3):
			coldiff=b[xx][yy][i]-b[xx+1][yy][i]
			if coldiff<0:
				di-=coldiff # ie adding -coldiff. instead of abs()
			else:
				di+=coldiff
		return di
	inline int YDiff(int xx,int yy):
		cdef int i, di=0, coldiff
		for i in range(3):
			coldiff=b[xx][yy][i]-b[xx][yy+1][i]
			if coldiff<0:
				di-=coldiff # ie adding -coldiff. instead of abs()
			else:
				di+=coldiff
		return di
cpdef OK(): #NB the first path is path no. 1
	global b, path, m, j, k, wid, hei
	cdef int which, aa, bb, cc, i
	cdef int initx, inity, wh, tdiff, lowest, xloc, yloc
	cdef float ww, hh, initRatio
	#load image.
	cdef np.ndarray[np.uint8_t, ndim=3] a
	a=misc.imread(fn)
	initx=a.shape[1] #arghh so its sideways? so should rot90 the array..
	inity=a.shape[0]
	#copy it to a C array
	for i in range(3):
		for j in range(initx):
			for k in range(inity):
				b[j][k][i]=a[k][j][i] #indices swapped so right side up.
	wid=initx ; hei=inity
	ww=wid ; hh=hei
	initRatio=ww/hh #this will never change.
	misc.imsave(GetFilename(),a) #save first image
	while m<NumLoops:
		ww=wid; hh=hei
		if ww/hh>=initRatio: #ie if it's at least wide enough do a vertical cut
#--------VERTICAL PATH BIT---------------------------------------------#
			InitializePath()
			for j in range(wid-1): #a path up starts from each bottom row pixel
				tdiff=Diff(j,0) #the dir[] for level 0 will hold dir the path 
				#goes to get to level 1.. which will be minimum of the 2 or 3.
				xloc=j #initial x pos
				for k in range (hei-1): #H-1? think so. dont need to add last row.
					#so, 3 cases. 1. LS 2. RS 3. LRS (left right and/or straight)	
					if xloc>0: #to avoid index errors
						aa=Diff(xloc-1,k+1) #left
					bb=Taxed(Diff(xloc,k+1)) #straight
					if xloc<wid-2:
						cc=Diff(xloc+1,k+1) #go right
					if xloc==0: #cant go left
						if bb<cc: tdiff+=bb #so go straight
						else: #go right
							path[j].dir[k].R=True
							tdiff+=cc
							xloc+=1				
						continue	
					if xloc>wid-3: #as far right as possible, so cant go right
						if bb<aa:	tdiff+=bb #so go straight
						else: #go left
							path[j].dir[k].L=True
							tdiff+=aa
							xloc-=1				
						continue	
					#so.. must be able to go L, R or straight
					wh=Compare(aa,bb,cc) #wh= 0=go left, 1=straight, 2=right
					if wh==0: #left
						path[j].dir[k].L=True
						xloc-=1
						tdiff+=aa
						continue #<-- does this work? skips the wh=2 bit?!
					elif wh==1: #straight
						tdiff+=bb
						continue
					path[j].dir[k].R=True #so wh=2
					xloc+=1
					tdiff+=cc
				path[j].totdiff=tdiff
			lowest=1000000 #Find path with lowest totdiff and remove
			for j in range(1,wid+1):
				if path[j].totdiff<lowest:
					lowest=path[j].totdiff
					which=j
			print m,"Lowest total=",lowest,"Vertical path no.",which
			xloc=which #the starting pixel is also the index of path
			for k in range(hei): # hmm in top row? what happens.. goes straight.
				#to see the seams, put black line on a-array here:
	# 			for i in range(3):
	# 				a[k][xloc][i]=0 #<-- swapped indices. is right, no?
				#get ave of pixels & put in left pixel
				for i in range(3):
					b[xloc][k][i]=(b[xloc][k][i]+b[xloc+1][k][i])/2
					a[k][xloc][i]=b[xloc][k][i]
				for i in range(3):
					for j in range(xloc+1,wid-1): #slide remaining row left
						b[j][k][i]=b[j+1][k][i]
						a[k][j][i]=b[j][k][i]
				#and 
				#these next lines dont apply to top row, but are harmless
				#so better not to waste time testing if they should apply....
				if path[which].dir[k].L==True:	
					xloc-=1 #'==True' not needed i guess
				else:
					if path[which].dir[k].R==True:	
						xloc+=1
			misc.imsave(GetFilename(),a)
			wid-=1 
			for i in range(3):
				for k in range(inity):
					a[k][wid-1][i]=0 #indices swapped so right side up.
					a[k][wid][i]=0 #indices swapped so right side up. #to try to fix bug
		ww=wid; hh=hei
		if ww/hh<=initRatio: #ie if it's at least tall enough
		#--------HORIZONTAL PATH BIT---=====================-------#
			InitializePath()
			for k in range(1,hei-1): #a path across starts from each left pixel
				tdiff=YDiff(0,k)
				yloc=k #initial x pos
				for j in range (wid-1): #H-1? think so. dont need to add last row.
					#so, 3 cases. 1. DS 2. US 3. DUS (down up right and/or straight)	
					if yloc>0: #to avoid index errors
						aa=YDiff(j+1,yloc-1)#down xloc-1,k+1) #left
					bb=Taxed(YDiff(j+1,yloc))#straight xloc,k+1) #straight
					if yloc<hei-3: cc=YDiff(j+1,yloc+1)#go up xloc+1,k+1) #go right
					if yloc==0: #cant go down xloc==0: #cant go left
						if bb<cc: #so go straight
							tdiff+=bb  ##NB left=down (smaller index) right=up (larger)
						else: #go up     #right
							path[k].dir[j].R=True
							tdiff+=cc
							yloc+=1				
						continue	
					if yloc>hei-3: #as far up as possible, so cant go up
						if bb<aa: #so go straight
							tdiff+=bb
						else: #go down
							path[k].dir[j].L=True
							tdiff+=aa
							yloc-=1				
						continue	
					wh=Compare(aa,bb,cc)
					if wh==0: #left
						path[k].dir[j].L=True
						yloc-=1
						tdiff+=aa
						continue
					elif wh==1: #straight
						tdiff+=bb
						continue
					path[k].dir[j].R=True #so wh==2: #right
					yloc+=1
					tdiff+=cc
				path[k].totdiff=tdiff
			lowest=1000000
			#this 5, -5 dont make sense.. dont make the paths if they wont ever be used.
			
			for k in range(5,hei-5):#i made this 10,hei-10 before to make it work.. dunno why#1,hei):# hei+1):
				if path[k].totdiff<lowest:
					lowest=path[k].totdiff
					which=k
			print m,"Lowest total=",lowest,"Horiz path no.",which
			yloc=which #the starting pixel is also the index of path
			for j in range(wid): # hmm in top row? what happens.. goes straight.
				#put black line on a-array, here I guess
				#but it will be erased immediately... hmm
	# 			for i in range(3):
	# 				a[yloc][j][i]=0 
	
	#NB combine these 2 loops!
				for i in range(3): #get ave of pixels & put in left pixel
					b[j][yloc][i]=(b[j][yloc][i]+b[j][yloc+1][i])/2
					a[yloc][j][i]=b[j][yloc][i]		
				for i in range(3):
					for k in range(yloc+1,hei-1): #slide set of row down
						b[j][k][i]=b[j][k+1][i]
						a[k][j][i]=b[j][k][i]#=a[k][j][i] #indices swapped so right side up.
				#these next lines dont apply to top row, but are harmless
				#so better not to waste time testing if they should apply....

#can I skip the ==True if theyre bools?
				if path[which].dir[j].L==True:		yloc-=1 
				else:
					if path[which].dir[j].R==True:	yloc+=1
			misc.imsave(GetFilename(),a)
			hei-=1 
			for i in range(3): #put in black line
				for j in range(initx):
					a[hei-1][j][i]=0 #indices swapped so right side up.
					a[hei][j][i]=0 #indices swapped so right side up. #to try to fix bug
	#------END HORIZ PATH BIT------===================================---#								
	for i in range(75): #5 seconds more at 15 fr/sec.
		misc.imsave(GetFilename(),a)

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
	#****************************
	#?! can't I just sum the R+G+B numbers and use that?
	#I mean, make C array hold those numbers all along.
	#same sum of difference between pixels isnt it?
	#saves testing each colour separately...
	#NOOOOO thats very very different.
	
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
	
	