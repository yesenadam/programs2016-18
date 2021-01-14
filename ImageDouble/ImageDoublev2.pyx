#ImageDouble.pyx - v2 Sept 2016
#Makes an image twice the width and height.

#Was fiddling around enhancing the filled in pixels in various ways.
#didnt try other averages than mean yet..
#going to try just enhancing the original pixels.
#otherwise it's just spotty... although maybe looks better from a distance.
import numpy as np
cimport numpy as np
from scipy import misc
DEF maxStartImageSize = 800 #make sure image is no bigger.
DEF maxFinalImageSize = maxStartImageSize*2 #800 #make sure image is no bigger.
fn="/Downloads-1/PanjinCropOrig-170+80-340+160.png"
na=fn[:fn.find('.')] #strip off the '.png' - does this work if the . is missing?! guess not
cpdef OK():
	cdef int j, i, k, initx, inity, endx, endy, a1, a2, a3, a4
	cdef np.ndarray[np.uint8_t, ndim=3] a, b
	cdef float ave
	cdef float enhance=0.2 #1= makes it black/white. 0=the same.
	cdef int tot
	a=misc.imread(fn)
	#a=np.rot90(a)
	initx=a.shape[0] #arghh so its sideways? so should rot90 the array..
	inity=a.shape[1]
	endx=2*initx
	endy=2*inity
	#cdef np.ndarray[np.int_t, ndim=3] b
	b=np.empty([endx,endy,3],dtype=np.uint8)#dtype=DTYPE_t) # i THINK these need to be reversed..
	#first put even pixels, which are same as ones in a.
	print "even pixels"
	for j in range(initx):
		for k in range(inity):
			for i in range(3):
			#	ave=a[j][k][i]
			#	ave=128-(128-ave)*(1+enhance)
			#	if ave>255:
			#		ave=255
			#	if ave<0:
			#		ave=0
				b[j*2][k*2][i]=a[j][k][i]#<int>ave#a[j][k][i]
	#now fill in others.
	#ones around boundary are a special case.. do that bit later.
	#maybe better not to include outside pixels.. who cares.
	#although nice to have dimensions x2
	#they only use 3 dots....
	#now fill in the others from 
	print "the others"
	for k in range(1,endy-2,2):
		#do odd rows
		for j in range(2,endx-1,2):
			for i in range(3):
#				b[j][k][i]=(b[j-1][k][i]+b[j+1][k][i]+b[j][k-1][i]+b[j][k+1][i])/4
#				b[j][k][i]=(a1+a2+a3+a4)/4
				#a1=b[j-1][k][i]
				#a2=b[j+1][k][i]
				a3=b[j][k-1][i] #because these 2 are the orig pixels
				a4=b[j][k+1][i]
				tot=(a3+a4)/2
			#	ave=128-(128-ave)*(1+enhance)
			#	if ave>255:
			#		ave=255
			#	if ave<0:
			#		ave=0
				b[j][k][i]=tot#<int>(ave) #(a3+a4)/2
				#maybe add enhancement.. hmm. maybe.. make it 1/5 closer to 0 or 255? adjustable.
				
		#even rows - k+1th row
		for j in range(1,endx-1,2):
			for i in range(3):
#				b[j][k+1][i]=(b[j-1][k+1][i]+b[j+1][k+1][i]+b[j][k][i]+b[j][k+2][i])/4
				a1=b[j-1][k+1][i]
				a2=b[j+1][k+1][i]
				#a3=b[j][k][i] #ditto
				#a4=b[j][k+2][i]
				tot=(a1+a2)/2#.0
			#	ave=128-(128-ave)*(1+enhance)
			#	if ave>255:
			#	if ave<0:
			#		ave=0
				b[j][k+1][i]=tot#<int>(ave)#(a1+a2)/2
	#first the ones with x, y odd.
	#maybe do these last....
	cdef int b1,b2,b3,b4
	print "x,y odd"
	for j in range(initx-1):
		for k in range(inity-1):
			for i in range(3):
#				ave=(a[j][k][i]+a[j+1][k][i]+a[j][k+1][i]+a[j+1][k+1][i])/4
				a1=b[j*2][k*2][i]
				a2=b[(j+1)*2][k*2][i]
				a3=b[j*2][(k+1)*2][i]
				a4=b[(j+1)*2][(k+1)*2][i]
			#try add all its 8 neighbours... less checkerboardy then..
			#but this not necessary if only the orig pixels enhanced.. hmm
			
		#		b1=b[j*2+1][k*2][i] #top middle
		#		b2=b[j*2][k*2+1][i] #left middle
		#		b3=b[(j+1)*2][k*2+1][i] #right middle
		#		b4=b[j*2+1][(k+1)*2][i] #bottom middle
			
				tot=(a1+a2+a3+a4)/4#+b1+b2+b3+b4)/8#4.0
			#	ave=128-(128-ave)*(1+enhance)
			#	if ave>255:
			#		ave=255
			#	if ave<0:
			#		ave=0
				b[2*j+1][2*k+1][i]=tot#<int>(ave)#(a1+a2+a3+a4)/4 #ave
	#b2=np.rot90(b,3)
	#b2=np.fliplr(b2)
	name=na+"-%d+%d.png" % (endy,endx) #yes, its on its side 8|
	misc.imsave(name,b)
