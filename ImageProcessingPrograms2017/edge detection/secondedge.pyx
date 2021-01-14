#secondedge.pyx
#simple edge-detection.
#BUT uses 2nd difference...

#for each pixel, measure x-1,y-1 - x+1,y+1 etc.. all 4 directions. then use the abs(largest)
#of those differences, (LD+255)/2 to convert -255->+255 to 0-255. yup.
import numpy as np
cimport numpy as np
from scipy import misc
DEF ABS=1 #1=just use pos values, abs() of second difference. white on black
#0= white and black on grey.
DEF NEG=0 #0=normal, 1=negative image
#fn="sydney1" #.png only
cdef int SecDiff(int a, int b, int c):
	return (a-b)-(b-c)

cpdef OK(fn):
	cdef int val,ad,col,i,j,max,hei, wid, diff[4], bigmax=-1000#immax[3],immin[3]#=-100,immin=1000, 
	cdef np.ndarray[np.uint8_t, ndim = 3] img, img2
	img = misc.imread(fn+".png")
#	immax[:]=[-100,-100,-100]
#	immin[:]=[1000,1000,1000]
	hei = img.shape[0]
	wid=img.shape[1]
	img2=np.zeros([hei, wid,3],dtype=np.uint8)
	#mono or colour?!?! maybe try colour first...
	print hei,wid
	for col in xrange(3):
		for j in xrange(1,hei-1): #dont do very edge....
			for i in xrange(1,wid-1):
				diff[0]=SecDiff(img[j+1,i+1,col],img[j,i,col],img[j-1,i-1,col])
				diff[1]=SecDiff(img[j,i+1,col],img[j,i,col],img[j,i-1,col])
				diff[2]=SecDiff(img[j+1,i,col],img[j,i,col],img[j-1,i,col])
				diff[3]=SecDiff(img[j-1,i+1,col],img[j,i,col],img[j+1,i-1,col])
				max=-2000
				for k in xrange(4):
					ad=abs(diff[k])
					if ad>max:
						max=ad
						wh=k
				if ABS==0:
					val=(diff[wh]+2*255)/4
				else:
					val=abs(diff[wh])/2
				if NEG==1:
					val=255-val
				img2[j,i,col]=val
#this bit from here to end tried to increase the distance between vals and 128, 
#by storing the min and max for each colour and multiplying by max ratio.. but looked awful..
# 				if img2[j,i,col]>immax[col]:
# 					immax[col]=img2[j,i,col]
# 				if img2[j,i,col]<immin[col]:
# 					immin[col]=img2[j,i,col]
# 	cdef float maxratio[3],minratio[3]
# 	for col in xrange(3):
# 		maxratio[col]=(255-128)/(float(immax[col])-128.0)
# 		minratio[col]=(128-0)/(128.0-float(immin[col]))
# 		print immax[col],maxratio[col],immin[col],minratio[col]
# 	for col in xrange(3):
# 		for j in xrange(1,hei-1): #dont do very edge....
# 			for i in xrange(1,wid-1):
# 				if img2[j,i,col]>128:
# 					img2[j,i,col]=int(float(img2[j,i,col]-128)*maxratio[col])+128
# 				if img2[j,i,col]<128:
# 					img2[j,i,col]=128-int(128-float(img2[j,i,col])*minratio[col])
	misc.imsave(fn+"-secondedge.png",img2)