#ImageDouble-Alg2.pyx - Sept 2016
#Makes an image twice the width and height.
#Interpolates pixels..so images can be blown up indefinitely without pixelation.

#Another algorithm.
#turn each pixel into 4.. so e.g. the top right 'quarter'  new pixel
#is a mix of 4 pixels : 2 x the original + the pixels to the top and right.
import numpy as np
cimport numpy as np
from scipy import misc
fn="/Downloads-1/tara-356+316-211-712+632-211-1424+1264-211.png"#PanjinCropOrig-170+80-321ave-340+160-321ave.png"#Panjin-Red-Beach-China--620x614.png"
na=fn[:fn.find('.')] #strip off the '.png'
cpdef OK():
	cdef:
		int tot, j, i, k, initx, inity, endx, endy, home, left, right, bottom, top
		np.ndarray[np.uint8_t, ndim=3] a, b
		float ave
	a=misc.imread(fn)
	initx=a.shape[0] #arghh so its sideways? so should rot90 the array..
	inity=a.shape[1]
	endx=2*initx
	endy=2*inity
	b=np.empty([endx,endy,3],dtype=np.uint8)#dtype=DTYPE_t) # i THINK these need to be reversed..
	for j in range(1,initx-1):
		for k in range(1,inity-1):
			for i in range(3):
				home=a[j][k][i] #is the base pixel we are building, used for all 4..
				top=a[j][k-1][i]
				left=a[j-1][k][i]
				right=a[j+1][k][i]
				bottom=a[j][k+1][i] #nb change back to (2 + 1 + 1) /4 :-)
				b[j*2][k*2][i]=(2*home+top+left)/4 #top left 'quarter of pixel'
				b[j*2+1][k*2][i]=(2*home+top+right)/4
				b[j*2+1][k*2+1][i]=(2*home+bottom+right)/4
				b[j*2][k*2+1][i]=(2*home+bottom+left)/4
	name=na+"-%d+%d-211.png" % (endy,endx) #yes, its on its side 8|
	misc.imsave(name,b)
#try other averages, like (3+1+1)/5 or (1+1+1)/3 etc... maybe different ones work better for different images.
#or (3+2+1)/6 maybe.. with rotational symmetry
#Conclusion: I looked at 211 (orig), 311, 321 (going clockwise) and 111.
#311 has the sharpest horizontal lines; 211 the best diagonals.