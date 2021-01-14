import numpy as np
cimport numpy as np
from scipy import misc
DEF size=512 #ie 512
cdef int i,j,m,n,p,k,c,xx,yy
cpdef OK():
	cdef np.ndarray[np.uint8_t, ndim=3] im #for image
	cdef np.ndarray[np.uint8_t, ndim=3] a
	cdef int s[2][260][3] #tosave shifted pixels temp
	fn="pictorotate.png"
	im=misc.imread(fn)
	#a=np.rot90(a)
	xx=im.shape[0] #arghh so its sideways? so should rot90 the array..
	yy=im.shape[1]
	a=np.empty([yy,xx,3],dtype=np.uint8) 
	for j in range(xx):
		for k in range(yy):
			for i in range(3):
				a[j,k,i]=im[j,k,i] #flip			
	c=0
	fn='rotated-%05d.png' % c
	misc.imsave(fn,a)
	for j in range(0,xx,2):
		for k in range(0,yy,2):
			for i in range(3):
				temp=a[j][k][i]
				a[j][k][i]=a[j+1][k][i]
				a[j+1][k][i]=a[j+1][k+1][i]
				a[j+1][k+1][i]=a[j][k+1][i]
				a[j][k+1][i]=temp
	c+=1
	fn='rotated-%05d.png' % c
	misc.imsave(fn,a)
	#do 4x4 boxes
	for p in range(2): #2 frames
		for i in range(3):
			for j in range(0,xx,4):
				for k in range(0,yy,4):
					#save the BL 2 px
					s[0][0][i]=a[j][k][i]
					s[0][1][i]=a[j][k+1][i]
					#save the UR 2 px
					s[1][0][i]=a[j+3][k+3][i]
					s[1][1][i]=a[j+3][k+2][i]
					#shift the 2 lots of 6 across
					for m in range(3): #0,1,2
						for n in range(2): #0,1
							a[j+m][k+n][i]=a[j+m+1][k+n][i]
							a[j+3-m][k+3-n][i]=a[j+2-m][k+3-n][i]
					a[j][k+2][i]=s[0][0][i]
					a[j][k+3][i]=s[0][1][i]
					a[j+3][k+1][i]=s[1][0][i]
					a[j+3][k][i]=s[1][1][i]
		
		c+=1
		fn='rotated-%05d.png' % c
		print fn
		misc.imsave(fn,a)
	#8x8 boxes
	for p in range(4): #4 frames
		for i in range(3):
			for j in range(0,xx,8):
				for k in range(0,yy,8):
					#save the BL 4 px
					for m in range(4):
						s[0][m][i]=a[j][k+m][i]
					#save the UR 4 px
					for m in range(4):
						s[1][m][i]=a[j+7][k+7-m][i]
					#shift the 2 lots of 4x7 across
					for m in range(7): #0,1,2,3,4,5,6
						for n in range(4): #0,1,2,3
							a[j+m][k+n][i]=a[j+m+1][k+n][i]
							a[j+7-m][k+7-n][i]=a[j+6-m][k+7-n][i]
					for m in range(4):
						a[j][k+4+m][i]=s[0][m][i]
						a[j+7][k+3-m][i]=s[1][m][i]
						
		c+=1
		fn='rotated-%05d.png' % c
		print fn
		misc.imsave(fn,a)
	#16x16 boxes
	for p in range(8): #8 frames
		for i in range(3):
			for j in range(0,xx,16):
				for k in range(0,yy,16):
					#save the BL 8 px
					for m in range(8):
						s[0][m][i]=a[j][k+m][i]
					#save the UR 8 px
					for m in range(8):
						s[1][m][i]=a[j+15][k+15-m][i]
					#shift the 2 lots of 8x15 across
					for m in range(15): #0,1,2,3,4,5,6
						for n in range(8): #0,1,2,3
							a[j+m][k+n][i]=a[j+m+1][k+n][i]
							a[j+15-m][k+15-n][i]=a[j+14-m][k+15-n][i]
					for m in range(8):
						a[j][k+8+m][i]=s[0][m][i]
						a[j+15][k+7-m][i]=s[1][m][i]
						
		c+=1
		fn='rotated-%05d.png' % c
		print fn
		misc.imsave(fn,a)
	#32x32 boxes
	cdef int pw, pfull, phalf, pquar
	pw=5 #power of 2
	for pw in range(5,10):
		pfull=2**pw
		phalf=2**(pw-1)
		pquar=2**(pw-2)
		for p in range(phalf): #16 frames
			for i in range(3):
				for j in range(0,xx,pfull):
					for k in range(0,yy,pfull):
						#save the BL 16 px - phalf
						for m in range(phalf):
							s[0][m][i]=a[j][k+m][i]
						#save the UR phalf px
						for m in range(phalf):
							s[1][m][i]=a[j+(pfull-1)][k+(pfull-1)-m][i]
						#shift the 2 lots of 8x15 across - 16x31 - phalf x pfull-1
						for m in range(pfull-1): #0,1,2,3,4,5,6
							for n in range(phalf): #0,1,2,3
								a[j+m][k+n][i]=a[j+m+1][k+n][i]
								a[j+(pfull-1)-m][k+(pfull-1)-n][i]=a[j+(pfull-2)-m][k+(pfull-1)-n][i]
						for m in range(phalf):
							a[j][k+phalf+m][i]=s[0][m][i]
							a[j+(pfull-1)][k+(phalf-1)-m][i]=s[1][m][i]
							
			c+=1
			fn='rotated-%05d.png' % c
			print fn
			misc.imsave(fn,a)
							
	
						
						
				#put saved pixels back
				#save image
		#repeat
				
				
	
	
