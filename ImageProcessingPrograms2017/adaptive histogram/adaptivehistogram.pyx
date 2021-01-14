import numpy as np
cimport numpy as np
from scipy import misc
#adaptive histogram - not the usual grid of blocks, with linear combination of 4 of them....
#but a PSxPS square moves over the image, each one making a histogram...
#so eg 20x20 will make 400 calculations for each point..
#save that, also that averaged with orig image...
#dont need to store each histogram..
DEF PS=500 #patch size
DEF STEP=20#50
cdef int h[3][256]

#call with OK("filename-without-extension") (png only)
cpdef OK(fn):
	cdef int yy,xx,x,y, col,max,i, j,k,hei, wid
	cdef float ratio, cum[3][256]
	#cdef int total[hei][wid][3], num[hei][wid][3] #num of values stored in total[][][]
	cdef np.ndarray[np.uint8_t, ndim = 3] img, img2,img3
	cdef np.ndarray[np.int32_t, ndim = 3] total,num#img, img2,img3
	cdef float pix=PS*PS#hei*wid
	cdef float tot
	img = misc.imread(fn+".png")
	hei = img.shape[0]
	wid=img.shape[1]
	img2=np.zeros([hei, wid,3],dtype=np.uint8)
	img3=np.zeros([hei, wid,3],dtype=np.uint8)
	total=np.zeros([hei, wid,3],dtype=np.int32)
	num=np.zeros([hei, wid,3],dtype=np.int32)
# 	for k in xrange(hei):
# 		for j in xrange(wid):
# 			for i in xrange(3):
# 				total[k][j][i]=0
# 				num[k][j][i]=0
	print hei,wid
	#loop over every position of a PSxPS patch on the image.
	for y in xrange(0,hei-PS+1,STEP): #if wid=5,PS=3..do 3 times
		print y
		for x in xrange(0,wid-PS+1,STEP): #if wid=5,PS=3..do 3 times
#			print y,x
			#make histogram for the patch
			for i in xrange(3):
				for j in xrange(256):
					h[i][j]=0
			for i in xrange(3):
				for k in xrange(PS): #loop over patch
					for j in xrange(PS):
						h[i][img[y+k,x+j,i]]+=1
			for col in xrange(3):
				tot=0
				for i in xrange(256):
					tot+=h[col][i]	
					cum[col][i]=tot/pix
			for col in xrange(3):
				for k in xrange(PS):
					for j in xrange(PS):
						total[y+k,x+j,col]+=int(cum[col][img[y+k,x+j,col]]*255.0)
						num[y+k,x+j,col]+=1
	for col in xrange(3):
		for k in xrange(hei):
			for j in xrange(wid):
				if num[k,j,col]>0:
					img2[k,j,col]=total[k,j,col]/num[k,j,col] #int division should be close enough.
					img3[k,j,col]=(img[k,j,col]+img2[k,j,col])/2
	misc.imsave(fn+"-adapthist.png",img2)	
	misc.imsave(fn+"-adapthist-ave.png",img3)