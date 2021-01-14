import numpy as np
cimport numpy as np
from scipy import misc
cdef int h[3][256]

cpdef OK():
	cdef int yy,xx,y, col,max,i, j,k,hei, wid, histHei=500, diagHei=450,histWid=3*255+30
	cdef float ratio, cum[3][256]
	cdef np.ndarray[np.uint8_t, ndim = 3] img, img2,img3,hist
	hist=np.zeros([histHei, histWid,3],dtype=np.uint8)
	img = misc.imread("sydney1-edge.png")#2017 voronoi/vor17-453210-detail.png")
	hei = img.shape[0]
	wid=img.shape[1]
	img2=np.zeros([hei, wid,3],dtype=np.uint8)
	img3=np.zeros([hei, wid,3],dtype=np.uint8)
	for i in xrange(3):
		for j in xrange(256):
			h[i][j]=0
	max=0
	for i in xrange(3):
		for k in xrange(hei):
			for j in xrange(wid):
				h[i][img[k,j,i]]+=1
				if h[i][img[k,j,i]]>max:
					max=h[i][img[k,j,i]]
	#calc cumul
	cdef int pix=hei*wid
	cdef float tot
	for col in xrange(3):
		tot=0
		for i in xrange(256):
			tot+=h[col][i]	
			cum[col][i]=tot/pix
#			print col,i,cum[col][i]
	for col in xrange(3):
		for i in xrange(hei):
			for j in xrange(wid):
				img2[i,j,col]=int(cum[col][img[i,j,col]]*255.0)
				img3[i,j,col]=(img[i,j,col]+img2[i,j,col])/2
	cdef Bmarg=10, Lmarg=10
	ratio=float(max)/float(diagHei)
	print max, ratio,diagHei
	#frame, first sides...
	for yy in range(diagHei):
		for col in range(3):
			hist[histHei-yy-Bmarg,Lmarg,col]=255
	for yy in range(diagHei):
		for col in range(3):
			hist[histHei-yy-Bmarg,256*3+Lmarg,col]=255
	for xx in range(256*3):
		for col in range(3):
			hist[histHei-Bmarg,xx+Lmarg,col]=255
	for xx in range(256*3):
		for col in range(3):
			hist[histHei-diagHei-Bmarg,xx+Lmarg,col]=255
		
	for col in xrange(3):
		for j in xrange(256):
			for k in xrange(3):
				y=int(float(h[col][j])/ratio)
				hist[histHei-y-Bmarg,j*3+k+Lmarg,col]=255
	misc.imsave("sydney1-edge-hist.png",hist)
	misc.imsave("sydney1-edge-histeqlz.png",img2)	
	misc.imsave("sydney1-edge-ave.png",img3)