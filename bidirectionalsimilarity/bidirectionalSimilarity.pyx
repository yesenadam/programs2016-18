# simple bidirectional similarity algorithm
#######################@cython.boundscheck(False)

import numpy as np
cimport numpy as np
from scipy import misc
from sage.misc.prandom import random
#DEF SXDim=513 #source
#DEF SYDim=513
DEF TXDim=450 #target
DEF TYDim=450
DEF MaxDim=513 #so can do it with rectangular pics
DEF MaxPatches=508*508# should need 507*507
DEF PatchSize=7 #7x7
#cdef struct colour:
#	int col[3]
#cdef struct patch:
#	colour xy[PatchSize][PatchSize] #,dtype=np.uint8_t) v#[np.uint8_t, ndim=3] v
#cdef patch p[1000]
#cdef patch pat
#@cython.boundscheck(False) #uncomment once it works to speed up.
cpdef OK():
	cdef int i, j, k, n, nP, nQ, jj, kk, SXDim, SYDim
	cdef np.ndarray[np.uint8_t, ndim=3] im #for image
	cdef np.ndarray[np.uint8_t, ndim=3] Sim,Tim #for source & target image
	cdef np.ndarray[int, ndim=4] P,Q #patches S[15768][6][5][2] #hay 250,000+! S[patch][x][y][col]
	cdef int whP[MaxPatches][2] #this stores location of ul edge of source patch no. wh[k] in wh[k][0]=x, wh[k][1]=y
	cdef int whQ[MaxPatches][2] #this stores location of ul edge of target patch no. wh[k] in wh[k][0]=x, wh[k][1]=y
	fn ="/Downloads-1/tiger-09.png"
	im=misc.imread(fn)
	SXDim=im.shape[1] #arghh so its sideways? so should rot90 the array..
	SYDim=im.shape[0]
	Sim=np.empty([SXDim,SYDim,3],dtype=np.uint8) 
	for j in range(SXDim):
		for k in range(SYDim):
			for i in range(3):
				Sim[j,k,i]=im[k,j,i] #flip			
	Tim=np.empty([TXDim,TYDim,3],dtype=np.uint8) #random target!
	P=np.empty([MaxPatches,PatchSize,PatchSize,3],dtype=int) #source patches
	Q=np.empty([MaxPatches,PatchSize,PatchSize,3],dtype=int) #target patches
	
#random target image
	for j in range(TXDim):
		for k in range(TYDim):
			for i in range(3):
				Tim[j,k,i]=random()*256
	misc.imsave('patchtest.png',Tim)
#make source patches S[]
	nP=0 #the count. first patch is patch number 1 <-- $$$$$$$$
	for k in range(SYDim-PatchSize+1): #this first so they're numbered along rows.. no lo importa tanto
		for j in range(SXDim-PatchSize+1): #513-7+1=507 i.e. last is 506
			#each of these (~250,000) is ul corner of a patch..
			nP+=1
			P[nP,:,:,:]=Sim[j:j+PatchSize,k:k+PatchSize,:]
						#and store where it came from
			whP[nP][0]=j
			whP[nP][1]=k
	print "Total P source patches:",nP		
#make target patches T[]
	nQ=0 #the count. first patch is patch number 1 <-- $$$$$$$$
	for k in range(TYDim-PatchSize+1):
		for j in range(TXDim-PatchSize+1): #513-7+1=507 i.e. last is 506
			#each of these (~250,000) is ul corner of a patch..
			nQ+=1
			Q[nQ,:,:,:]=Tim[j:j+PatchSize,k:k+PatchSize,:]
						#and store where it came from
			whQ[nQ][0]=j
			whQ[nQ][1]=k
	print "Total Q target patches:",nQ		
	#1. For each target patch $Q$ find the most similar source patch $P$ (minimize $D(P,Q)$)
	cdef int closestPtoQ[MaxPatches]
	cdef long int dist, diff, mindist
	#cdef int[:,:,:,:] cP = P
	#cdef int[:,:,:,:] cQ = P
	for n in range(1,nQ+1): #for each target
		#check EVERY source patch.. and store minimum, and which has that minimum..
		mindist=100000000
		for m in range(1,nP+1): #check all source patches
			dist=0
			for i in range(3):
				for j in range(PatchSize):
					for k in range(PatchSize):
						#pnjki=P[n,j,k,i]
						#qnjki=Q[m,j,k,i]
						#diff=pnjki-qnjki
						diff=P[m,j,k,i]-Q[n,j,k,i]
						#diff=np.subtract(P[n][j][k][i],Q[m][j][k][i])
						dist+=diff*diff#diff*diff
			if dist<mindist:
				mindist=dist
				closestPtoQ[n]=m
		print n, closestPtoQ[n], mindist

	#For this first attempt.. just use patches at the image level (not the gaussian pyramid.)
# 	1. For each target patch $Q$ find the most similar source patch $P$ (minimize $D(P,Q)$). Colors of pixels in $P$ are votes for pixels in $Q$ with weight $1/N_T$. 
# 
# 2. In the opposite direction: for each $\hat{P}$ find the most similar $\hat{Q}$. Pixels in $\hat{P}$ vote for pixels in $\hat{Q}$ with weight $1/N_S$.
# 
# 3. For each target pixel $q$ take weighted average of all 
# its votes as its new color $T^{r+1}(q)$. (Color votes $S(p_i)$ are 
# found in step 1, $S(\hat{p}_i)$ in step 2.) 
