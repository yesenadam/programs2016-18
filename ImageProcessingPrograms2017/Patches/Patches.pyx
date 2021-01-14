# simple bidirectional similarity algorithm
#v3 just uses step1.
#adapted for large pics.
# v2 try again.. dont make list of patches!! takes days to even do 1 pass.
# So far this isnt bidirectional! But does step 1 - For each target patch, finds the closest source patch.
# Now will add the reverse bit for v3.
# Also, it doesnt do multiple scales yet i.e. the Gaussian pyr. Just the actual pics.
# Im not even sure if it works - hard to test...
#qqq#cython: boundscheck=False, wraparound=False

#try with the colours done separately, i.e. votes for each colour separately..

#S = source, T = target, P = patch
import numpy as np
cimport numpy as np
from scipy import misc
DEF defTWidth = 231#379#615#46 #209
DEF defTHeight = 300#649#95 #139
DEF defSWidth = 400#46#797
DEF defSHeight = 261#95#547
DEF PatchSize = 7 #7x7
DEF TODO = 100 #Number of cycles to do, images to save etc..
cdef:
	struct pt:
		int x,y
	pt closest
#	pt closestPtoQ[defTWidth][defTHeight]
	struct vote:
		int col[3]
		int num
	vote votes[defTWidth][defTHeight]
	int sx, sy, tx, ty, minDist, dist
	int cT[defTWidth][defTHeight][3]
	int cS[defSWidth][defSHeight][3] #i.e. C-style arrays
	int sourceImgWidth, sourceImgHeight
	int SqTable[256]
	
# cdef TryPreviousClosestSourcePatch():
# 	global minDist
# 	cdef int diff, colour, px, py, xx, yy
# 	minDist = 0
# 	for colour in xrange(3): 
# 		for px in xrange(PatchSize):
# 			for py in xrange(PatchSize):
# 				xx = closestPtoQ[tx][ty].x+px
# 				yy = closestPtoQ[tx][ty].y+py
# 				diff = cS[xx][yy][colour]-cT[tx+px][ty+py][colour]
# 				minDist += diff*diff
# 	closest = closestPtoQ[tx][ty] #in case it actually is the closest

cdef int FindSquaredDifferencesOfAllPointsInTheTwoPatches():
	cdef int distance = 0,colour, px, py,diff
	for colour in xrange(3): #find the squared difference of all points in the 2 patches, x 3 colours
		for px in xrange(PatchSize):
			for py in xrange(PatchSize):
				diff=cS[sx+px][sy+py][colour]-cT[tx+px][ty+py][colour]
				if diff>=0:
					distance+=SqTable[diff]
				else:
					distance+=SqTable[-diff] #IS THIS FASTER than plain **2?? TEST.
				#distance += diff*diff
			if distance>minDist: #ie not the one that I want, so return early
				return distance
	return distance		
	
cdef FindClosestSourcePatch():
	global minDist, dist,sx,sy
	for sx in xrange(sourceImgWidth-PatchSize+1):
		for sy in xrange(sourceImgHeight-PatchSize+1):
			dist=FindSquaredDifferencesOfAllPointsInTheTwoPatches()
			if dist<minDist:
				minDist = dist
				closest.x = sx
				closest.y = sy
#test:
				#print sx, sy, tx, ty
cdef AddVotesForClosestPatch():
	cdef int px,py,colour
	for px in xrange(PatchSize): #add points for each pixel in the Source patch nearest the T patch.
		for py in xrange(PatchSize):
			for colour in xrange(3):
				votes[tx+px][ty+py].col[colour] += cS[closest.x+px][closest.y+py][colour]
			votes[tx+px][ty+py].num += 1
						
cpdef OK():
	global dist, minDist, sx, sy, tx, ty, sourceImgWidth, sourceImgHeight
	cdef:
		int diff,i
		int loop, colour, px, py
		np.ndarray[np.uint8_t, ndim = 3] SImage, TImage#, T
	SImage = misc.imread("cpastoral400-261.png")#forCremorne-copia.png")#eye of van goghx5-part.png")#forCremorne-500.png")
	TImage = misc.imread("van-gogh-self-portrait copia.png")#"cpastoral400-261-part.png")#sydney2-part.png")
	sourceImgWidth = SImage.shape[1] 
	sourceImgHeight = SImage.shape[0]
	print "Source:"
	print SImage.shape[1],defSWidth
	print SImage.shape[0],defSHeight
	print "Target:"
	print TImage.shape[1],defTWidth
	print TImage.shape[0],defTHeight
	
	for i in xrange(256):
		SqTable[i]=i*i
	for colour in xrange(3):
		for sx in xrange(sourceImgWidth):
			for sy in xrange(sourceImgHeight):
				cS[sx][sy][colour] = SImage[sy,sx,colour]
		for tx in xrange(defTWidth):
			for ty in xrange(defTHeight):
				cT[tx][ty][colour] = TImage[ty,tx,colour]
	for loop in xrange(1,TODO+1):
		for tx in xrange(defTWidth):
			for ty in xrange(defTHeight):
				for colour in xrange(3):
					votes[tx][ty].col[colour] = 0
				votes[tx][ty].num = 0	
		print "Starting loop no.",loop
		#STEP 1. For each target patch $Q$ find the most similar source patch $P$ (minimize $D(P,Q)$) ================
		for ty in xrange(defTHeight-PatchSize+1):
			for tx in xrange(defTWidth-PatchSize+1): #for every target patch
#				if loop == 1:
				minDist = 100000000 #work out better value for this.
#				else: #try the S patch that was closest last time for better min.
#					TryPreviousClosestSourcePatch()
				FindClosestSourcePatch()
#				closestPtoQ[tx][ty] = closest
				#i.e. the closest source patch to the target patch starting at tx,ty
				#is the source patch starting at closestPtoQ.x, .y
				AddVotesForClosestPatch()
			print "Step 1. Done target ty",ty
		#Step 3. ===================================================================================
		for tx in xrange(defTWidth):
			for ty in xrange(defTHeight):
				for colour in xrange(3):
					cT[tx][ty][colour] = votes[tx][ty].col[colour] / votes[tx][ty].num
					TImage[ty,tx,colour] = cT[tx][ty][colour]
		fn = "cpastoral400-261.png-van-gogh-self-portrait copia 231x300-%d.png" % loop #cpastoral-400-261-part-%d.png" % loop
		misc.imsave(fn,TImage)

	#For this first attempt.. just use patches at the image level (not the gaussian pyramid.)
			
		#Also - maybe better to use "Difference from the patch average" than "absolute colour level" in all this.
		#Cause absolute level depends too much on lighting conditions etc, doesnt capture the form, which is 
		#lo importante.
		#Also try - flipped horizontally? May be very important in some pics... like architecture, faces etc with symm.
		#rotated? etc... (good for clouds and stuff not... under gravity, I guess.)

#YE OFFICIAL STEPS
# 	1. For each target patch $Q$ find the most similar source patch $P$ (minimize $D(P,Q)$). Colors of pixels in $P$
#are votes for pixels in $Q$ with weight $1/N_T$. 
# 
# 2. In the opposite direction: for each $\hat{P}$ find the most similar $\hat{Q}$. Pixels in $\hat{P}$ vote for
#pixels in $\hat{Q}$ with weight $1/N_S$.
# 
# 3. For each target pixel $q$ take weighted average of all 
# its votes as its new color $T^{r+1}(q)$. (Color votes $S(p_i)$ are 
# found in step 1, $S(\hat{p}_i)$ in step 2.) 
