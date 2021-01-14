# cython: cdivision=True, boundscheck=False, wraparound=False
import numpy as np
cimport numpy as np
from scipy import misc
#adaptive histogram v2- (not the usual grid of blocks, with linear combination of 4 of them....)
#but a PSxPS square moves over the image, each one making a histogram...
#so eg 20x20 will make 400 calculations for each point..
#save that, also that averaged with orig image...
#dont need to store each histogram..
#step size skips some, making it quicker... but less accurate. makes bands if too large....

#v2 - doesnt recalc whole patch each time - removes LH strip, add RH strip...
DEF PS=350 #patch size
DEF STEP=10#50
cdef int h[3][256]

#call with OK("filename-without-extension") (png only)
cpdef OK(fn):
	cdef int m,n,x,y, col, j,k,hei, wid, bin
	cdef float cum[3][256]
	cdef np.ndarray[np.uint8_t, ndim = 3] img, img2,img3
	cdef np.ndarray[np.int32_t, ndim = 3] total
	cdef np.ndarray[np.int16_t, ndim = 3] num
	cdef float tot, pix=PS*PS
	tag="-ps%d-step%d" % (PS,STEP)
	img = misc.imread(fn+".png")
	hei = img.shape[0]
	wid=img.shape[1]
	img2=np.zeros([hei, wid,3],dtype=np.uint8)
	img3=np.zeros([hei, wid,3],dtype=np.uint8)
	total=np.zeros([hei, wid,3],dtype=np.int32)
	num=np.zeros([hei, wid,3],dtype=np.int16)
	print hei,wid
	#loop over every position of a PSxPS patch on the image.
	for col in xrange(3):
		print "Colour #",col
		for y in xrange(0,hei-PS+1,STEP): #if wid=5,PS=3..do 3 times
			print y
			for x in xrange(0,wid-PS+1,STEP): #if wid=5,PS=3..do 3 times
				#make histogram for the patch
				if x==0:
					for bin in xrange(256):
						h[col][bin]=0
					for k in xrange(PS): #loop over patch
						for j in xrange(PS):
							h[col][img[y+k,x+j,col]]+=1
				else:
				#remove LH strip, i.e. a strip 1 STEP wide from past the left edge of the new x.
					for m in xrange(1,STEP+1): #go left 1 --> STEP
						for n in xrange(PS):
							h[col][img[y+n,x-m,col]]-=1
				#add RH strip, exactly 1 patch width further to the right..
					for m in xrange(1,STEP+1): #go left 1 --> STEP
						for n in xrange(PS):
							h[col][img[y+n,PS+x-m,col]]+=1
				tot=0
				for bin in xrange(256):
					tot+=h[col][bin]	
					cum[col][bin]=tot/pix
				for k in xrange(PS):
					for j in xrange(PS):
						total[y+k,x+j,col]+=int(cum[col][img[y+k,x+j,col]]*255.0)
						num[y+k,x+j,col]+=1
		for k in xrange(hei):
			for j in xrange(wid):
				if num[k,j,col]>0:
					img2[k,j,col]=total[k,j,col]/num[k,j,col] #int division should be close enough.
					img3[k,j,col]=(img[k,j,col]+img2[k,j,col])/2
	misc.imsave(fn+tag+"-adapthist.png",img2)	
	misc.imsave(fn+tag+"-adapthist-ave.png",img3)