# cython: cdivision=True, boundscheck=False, wraparound=False
#fourthdiffcombinededge.pyx
#simple edge-detection.
#also uses 2nd, 3rd, 4th difference... (maybe in different directions)
#uses max value of those.
#call with OK("filename") - NB dont use extension, the program adds ".png"
import numpy as np
cimport numpy as np
from scipy import misc
#DEF ABS = 0 #1 = just use pos values, abs() of second difference. white on black
#0 =  white and black on grey.
#DEF NEG = 0 #0 = normal, 1 = negative image
#DEF COLOURED = 1 #0 = normal, 1 = use colour.. only for NEG version (white background)
cdef int diff[4], ABS = 0

cdef int SecDiff(int a, int b, int c):
	return a - 2*b + c # (a-b) - (b-c)

cdef int ThirdDiff(int a, int b, int c, int d, int e):
	return a - 2*(b-d) - e # ((a-c)-(b-d)) - ((b-d)-(c-e))

cdef int FourthDiff(int a, int b, int c, int d, int e):
	return a - 4*b + 6*c - 4*d + e #(((a-b)-(b-c))-((b-c)-(c-d))) - (((b-c)-(c-d))-((c-d)-(d-e)))

cdef int ReturnVal(int v):
	cdef:
		int ad, max=-3000, wh, k, power=2**(v-1)
		int powerdouble=2*power
	for k in xrange(4):
		ad = abs(diff[k])
		if ad > max:
			max = ad
			wh = k
	if ABS == 0:
		return (diff[wh]+power*255)/powerdouble #i.e. white and black on grey
	return abs(diff[wh])/power #i.e. white on black

cpdef OK(name):
	global ABS
	cdef float im, fl
	cdef int NEG=0, COLOURED=0,it,val[5],col,i,j,k,hei, wid
	cdef np.ndarray[np.uint8_t, ndim = 3] img, img2
	img = misc.imread(name+".png")
	hei = img.shape[0]
	wid = img.shape[1]
	img2 = np.zeros([hei, wid,3],dtype = np.uint8)
	print hei,wid
	ABS=0
	for loop in xrange(4):
		fn=name
		if loop==1:
			ABS = 1
		if loop==2:
			NEG = 1
		if loop==3:
			COLOURED=1
		for col in xrange(3):
			for j in xrange(2,hei-2): #dont do very edge....
				for i in xrange(2,wid-2):
					diff[0] = img[j+1,i+1,col]-img[j-1,i-1,col]
					diff[1] = img[j,i+1,col]-img[j,i-1,col]
					diff[2] = img[j+1,i,col]-img[j-1,i,col]
					diff[3] = img[j-1,i+1,col]-img[j+1,i-1,col]
					val[1]=ReturnVal(1) #1=1st diff, 2 =2nd diff etc	
					diff[0] = SecDiff(img[j+1,i+1,col],img[j,i,col],img[j-1,i-1,col])
					diff[1] = SecDiff(img[j,i+1,col],img[j,i,col],img[j,i-1,col])
					diff[2] = SecDiff(img[j+1,i,col],img[j,i,col],img[j-1,i,col])
					diff[3] = SecDiff(img[j-1,i+1,col],img[j,i,col],img[j+1,i-1,col])
					val[2]=ReturnVal(2) 
					diff[0] = ThirdDiff(img[j+2,i+2,col],img[j+1,i+1,col],img[j,i,col],img[j-1,i-1,col],img[j-2,i-2,col])
					diff[1] = ThirdDiff(img[j,i+2,col],img[j,i+1,col],img[j,i,col],img[j,i-1,col],img[j,i-2,col])
					diff[2] = ThirdDiff(img[j+2,i,col],img[j+1,i,col],img[j,i,col],img[j-1,i,col],img[j-2,i,col])
					diff[3] = ThirdDiff(img[j-2,i+2,col],img[j-1,i+1,col],img[j,i,col],img[j+1,i-1,col],img[j+2,i-2,col])
					val[3]=ReturnVal(3) 
					diff[0] = FourthDiff(img[j+2,i+2,col],img[j+1,i+1,col],img[j,i,col],img[j-1,i-1,col],img[j-2,i-2,col])
					diff[1] = FourthDiff(img[j,i+2,col],img[j,i+1,col],img[j,i,col],img[j,i-1,col],img[j,i-2,col])
					diff[2] = FourthDiff(img[j+2,i,col],img[j+1,i,col],img[j,i,col],img[j-1,i,col],img[j-2,i,col])
					diff[3] = FourthDiff(img[j-2,i+2,col],img[j-1,i+1,col],img[j,i,col],img[j+1,i-1,col],img[j+2,i-2,col])
					val[4]=ReturnVal(4) 
					#****UM?!?! this doesnt work for ABS=0 does it?!?!
					it = val[1]
					for k in xrange(2,5): # 2-> 4
						if val[k] > it:
							it = val[k]
					if NEG == 1:
						it = 255-it
						if COLOURED == 1:
							fl = it
							fl = 255-(255-fl)*1.5 #make lines darker
							if fl < 0:
								fl = 0
							im = img[j,i,col]
							fl = (fl/255.0)*(255.0-(255.0-im)/1.5) #ie 0->0, 255->faint shade of orig
							it = int(fl)
					img2[j,i,col] = it
		fn += "-4DCE"
		if ABS > 0:
			fn += "-abs"
		if NEG > 0:
			fn += "-neg"
			if COLOURED > 0:
				fn += "-col"
		misc.imsave(fn+".png",img2)