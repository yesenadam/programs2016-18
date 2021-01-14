#PicRotate3
#with slow -> fast frames. 30,29,28,27 frames etc
import numpy as np
cimport numpy as np
from scipy import misc

cpdef OK():
	cdef int i,j,m,n,p,k,c,t,xx,yy,temp
	cdef np.ndarray[np.uint8_t, ndim=3] im, a #for image
#	cdef np.ndarray[np.uint8_t, ndim=3] a
	cdef int s[2][260][3] #to save shifted pixels temporarily
	fn="tiger9.png" 
	im=misc.imread(fn)
	xx=im.shape[0] 
	yy=im.shape[1]
	a=np.empty([yy,xx,3],dtype=np.uint8) 
	for j in range(xx):
		for k in range(yy):
			for i in range(3):
				a[j,k,i]=im[j,k,i] 			
	c=0
	t=30
	for i in range(t):
		fn='rotated-%05d.png' % c
		misc.imsave(fn,a)
		c+=1
	if t>1:
		t-=1
	for j in range(0,xx,2):
		for k in range(0,yy,2):
			for i in range(3):
				temp=a[j][k][i]
				a[j][k][i]=a[j+1][k][i]
				a[j+1][k][i]=a[j+1][k+1][i]
				a[j+1][k+1][i]=a[j][k+1][i]
				a[j][k+1][i]=temp
	for i in range(t):
		fn='rotated-%05d.png' % c
		misc.imsave(fn,a)
		c+=1
	if t>1:
		t-=1
	cdef int pw, pfull, phalf
	for pw in range(2,10):
		pfull=2**pw
		phalf=2**(pw-1)
		for p in range(phalf): 
			for i in range(3):
				for j in range(0,xx,pfull):
					for k in range(0,yy,pfull):
						#save the BL 16 px - phalf
						for m in range(phalf):
							s[0][m][i]=a[j][k+m][i]
						#save the UR phalf px
						for m in range(phalf):
							s[1][m][i]=a[j+(pfull-1)][k+(pfull-1)-m][i]
						#shift the 2 lots of 8x15-p across - 16x31-p - phalf x pfull-1
						for m in range(pfull-1-p): #0,1,2,3,4,5,6
							for n in range(phalf): #0,1,2,3
								a[j+m][k+n][i]=a[j+m+1][k+n][i]
								a[j+(pfull-1)-m][k+(pfull-1)-n][i]=a[j+(pfull-2)-m][k+(pfull-1)-n][i]
						for m in range(phalf):
							a[j+p][k+phalf+m][i]=s[0][m][i]
							a[j+(pfull-1)-p][k+(phalf-1)-m][i]=s[1][m][i]
							
			for i in range(t):
				fn='rotated-%05d.png' % c
				misc.imsave(fn,a)
				c+=1
			if t>1:
				t-=1
			print fn
	t=30
	for i in range(t):
		fn='rotated-%05d.png' % c
		c+=1
		misc.imsave(fn,a)
		print fn
