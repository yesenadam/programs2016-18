#PicRotatev2a
#hopefully, all in 1 go!
import numpy as np
cimport numpy as np
from scipy import misc
cdef:
	struct pix: #1
		int x,y #loc of pixels relative to bottom left corner of its enclosing 2x2 box (a box1 struct)
	struct box1: #2x2 #name refers to box side in 2^num
		pix px[4] #box1=4 pixels, 2x2
		int x,y #loc in its 
	struct box2: 
		box1 b1[4] #=4x4 pixels 4x(2x2)
		int x,y
	struct box3: 
		box2 b2[4] #=4x(4x4) pixels 
		int x,y
	struct box4: 
		box3 b3[4] #=4x(8x8) pixels 
		int x,y
	struct box5: 
		box4 b4[4] #=4x(16x16) pixels 
		int x,y
	struct box6: 
		box5 b5[4] #=4x(32x32) pixels 
		int x,y
	struct box7: 
		box6 b6[4] #=4x(64x64) pixels 
		int x,y
	struct box8:
		box7 b7[4] #=4x(128x128)
		int x,y
	box8 b[4] #=4x(256x256) = the whole 512x512 image
	int x0,x1,x2,x3,x4,x5,x6,x7,x8,y0,y1,y2,y3,y4,y5,y6,y7,y8,t0,t1,t2,t3,t4,t5,t6,t7,t8
DEF p1=2
DEF p2=4
DEF p3=8
DEF p4=16
DEF p5=32
DEF p6=64
DEF p7=128
DEF p8=256
DEF p9=512
for x8 in xrange(2): #loc of each of A,B,C,D (quarters of 512x512 image)
	for y8 in xrange(2):
		t8=y8+x8*2
		b[t8].x=x8*p8
		b[t8].y=y8*p8
		for x7 in xrange(2): # for each of A,B,C,D its 4 quarters ie a,b,c,d etc
			for y7 in xrange(2):
				t7=y7+x7*2
				b[t8].b7[t7].x=x7*p7
				b[t8].b7[t7].y=y7*p7
				for x6 in xrange(2): # for each of its 4 quarters 
					for y6 in xrange(2):
						t6=y6+x6*2
						b[t8].b7[t7].b6[t6].x=x6*p6
						b[t8].b7[t7].b6[t6].y=y6*p6
						for x5 in xrange(2): 
							for y5 in xrange(2):
								t5=y5+x5*2
								b[t8].b7[t7].b6[t6].b5[t5].x=x5*p5
								b[t8].b7[t7].b6[t6].b5[t5].y=y5*p5
								for x4 in xrange(2): 
									for y4 in xrange(2):
										t4=y4+x4*2
										b[t8].b7[t7].b6[t6].b5[t5].b4[t4].x=x4*p4
										b[t8].b7[t7].b6[t6].b5[t5].b4[t4].y=y4*p4
										for x3 in xrange(2): 
											for y3 in xrange(2):
												t3=y3+x3*2
												b[t8].b7[t7].b6[t6].b5[t5].b4[t4].b3[t3].x=x3*p3
												b[t8].b7[t7].b6[t6].b5[t5].b4[t4].b3[t3].y=y3*p3
												for x2 in xrange(2): 
													for y2 in xrange(2):
														t2=y2+x2*2
														b[t8].b7[t7].b6[t6].b5[t5].b4[t4].b3[t3].b2[t2].x=x2*p2
														b[t8].b7[t7].b6[t6].b5[t5].b4[t4].b3[t3].b2[t2].y=y2*p2
														for x1 in xrange(2): 
															for y1 in xrange(2):
																t1=y1+x1*2
																b[t8].b7[t7].b6[t6].b5[t5].b4[t4].b3[t3].b2[t2].b1[t1].x=x1*p1
																b[t8].b7[t7].b6[t6].b5[t5].b4[t4].b3[t3].b2[t2].b1[t1].y=y1*p1
																for x0 in xrange(2): 
																	for y0 in xrange(2):
																		t0=y0+x0*2
																		b[t8].b7[t7].b6[t6].b5[t5].b4[t4].b3[t3].b2[t2].b1[t1].px[t0].x=x0
																		b[t8].b7[t7].b6[t6].b5[t5].b4[t4].b3[t3].b2[t2].b1[t1].px[t0].y=y0
#original pic. dont change it, so reference pix's are available.
#updated pic to save
#array/struct that stores points......
cpdef OK():
	cdef int xx,yy,w,v,U
	cdef np.ndarray[np.uint8_t, ndim=3] pic
	cdef np.ndarray[np.uint8_t, ndim=3] ar
	cdef int i,j,k,picx,picy
	cdef int x0,x1,x2,x3,x4,x5,x6,x7,x8
	cdef int y0,y1,y2,y3,y4,y5,y6,y7,y8
	cdef int t0,t1,t2,t3,t4,t5,t6,t7,t8
	cdef int k0,k1,k2,k3,k4,k5,k6,k7,k8
	fn="tiger-09.png" 
	pic=misc.imread(fn)
	xx=pic.shape[0] #beware - it loads pic sidewise, so correct for that
	yy=pic.shape[1]
	ar=np.empty((xx,yy,3),dtype=np.uint8)
	cdef int xo0,xo1,xo2,xo3,xo4,xo5,xo6,xo7,xo8
	cdef int yo0,yo1,yo2,yo3,yo4,yo5,yo6,yo7,yo8
	#DONT FORGET to do the rotation bit first!!!!
	for i in xrange(p7+1): #513
		for x8 in xrange(2): #loc of each of A,B,C,D (quarters of 512x512 image)
			for y8 in xrange(2):
				t8=y8+x8*2
				xo8=b[t8].x
				yo8=b[t8].y
				for x7 in xrange(2): # for each of A,B,C,D its 4 quarters ie a,b,c,d etc
					for y7 in xrange(2):
						t7=y7+x7*2
						xo7=xo8+b[t8].b7[t7].x
						yo7=yo8+b[t8].b7[t7].y
						for x6 in xrange(2): # for each of its 4 quarters 
							for y6 in xrange(2):
								t6=y6+x6*2
								xo6=xo7+b[t8].b7[t7].b6[t6].x
								yo6=yo7+b[t8].b7[t7].b6[t6].y
								for x5 in xrange(2):
									for y5 in xrange(2):
										t5=y5+x5*2
										xo5=xo6+b[t8].b7[t7].b6[t6].b5[t5].x
										yo5=yo6+b[t8].b7[t7].b6[t6].b5[t5].y
										for x4 in xrange(2):
											for y4 in xrange(2):
												t4=y4+x4*2
												xo4=xo5+b[t8].b7[t7].b6[t6].b5[t5].b4[t4].x
												yo4=yo5+b[t8].b7[t7].b6[t6].b5[t5].b4[t4].y
												for x3 in xrange(2): 
													for y3 in xrange(2):
														t3=y3+x3*2
														xo3=xo4+b[t8].b7[t7].b6[t6].b5[t5].b4[t4].b3[t3].x
														yo3=yo4+b[t8].b7[t7].b6[t6].b5[t5].b4[t4].b3[t3].y
														for x2 in xrange(2):
															for y2 in xrange(2):
																t2=y2+x2*2
																xo2=xo3+b[t8].b7[t7].b6[t6].b5[t5].b4[t4].b3[t3].b2[t2].x
																yo2=yo3+b[t8].b7[t7].b6[t6].b5[t5].b4[t4].b3[t3].b2[t2].y
																for x1 in xrange(2): 
																	for y1 in xrange(2):
																		t1=y1+x1*2
																		xo1=xo2+b[t8].b7[t7].b6[t6].b5[t5].b4[t4].b3[t3].b2[t2].b1[t1].x
																		yo1=yo2+b[t8].b7[t7].b6[t6].b5[t5].b4[t4].b3[t3].b2[t2].b1[t1].y
																		for x0 in xrange(2): 
																			for y0 in xrange(2):
																				t0=y0+x0*2
																				xo=xo1+b[t8].b7[t7].b6[t6].b5[t5].b4[t4].b3[t3].b2[t2].b1[t1].px[t0].x
																				yo=yo1+b[t8].b7[t7].b6[t6].b5[t5].b4[t4].b3[t3].b2[t2].b1[t1].px[t0].y
																				picx=x8*p8+x7*p7+x6*p6+x5*p5+x4*p4+x3*p3+x2*p2+x1*p1+x0
																				picy=y8*p8+y7*p7+y6*p6+y5*p5+y4*p4+y3*p3+y2*p2+y1*p1+y0
																				ar[xo,yo]=pic[picx,picy]
		print i
		misc.imsave('tpics/%05d.png' % i,ar)
	#clean canvas
		for w in xrange(512):
			for v in xrange(512):
				for u in xrange(3):
					ar[w,v,u]=0
#hmm... could actually draw pixels 'in between' pixels by
#averaging the contributions from nearby/ 1/2-on-pixel points.... hmmmm....
#how to get smooth motion without doing that?!?!
		for w in xrange(2):#if i<256: #==1:  ##NB was 1 --> maybe do xes on even num, y on odds, or something/ TRY.
			b[0].x+=1
			b[1].y-=1
			b[2].y+=1
			b[3].x-=1
		if i<128:#%4==2:
			for k8 in xrange(4):
				b[k8].b7[0].x+=1
				b[k8].b7[1].y-=1
				b[k8].b7[2].y+=1
				b[k8].b7[3].x-=1
		if i<64:#%8==4:
			for k8 in xrange(4):
				for k7 in xrange(4):
					b[k8].b7[k7].b6[0].x+=1
					b[k8].b7[k7].b6[1].y-=1
					b[k8].b7[k7].b6[2].y+=1
					b[k8].b7[k7].b6[3].x-=1
		if i<32:#%16==8:
			for k8 in xrange(4):
				for k7 in xrange(4):
					for k6 in xrange(4):
						b[k8].b7[k7].b6[k6].b5[0].x+=1
						b[k8].b7[k7].b6[k6].b5[1].y-=1
						b[k8].b7[k7].b6[k6].b5[2].y+=1
						b[k8].b7[k7].b6[k6].b5[3].x-=1
		if i>60 and i<77:#5:#%32==16:
			for k8 in xrange(4):
				for k7 in xrange(4):
					for k6 in xrange(4):
						for k5 in xrange(4):
							b[k8].b7[k7].b6[k6].b5[k5].b4[0].x+=1
							b[k8].b7[k7].b6[k6].b5[k5].b4[1].y-=1
							b[k8].b7[k7].b6[k6].b5[k5].b4[2].y+=1
							b[k8].b7[k7].b6[k6].b5[k5].b4[3].x-=1
		if i>60 and i<69:#%64==32:
			for k8 in xrange(4):
				for k7 in xrange(4):
					for k6 in xrange(4):
						for k5 in xrange(4):
							for k4 in xrange(4):
								b[k8].b7[k7].b6[k6].b5[k5].b4[k4].b3[0].x+=1
								b[k8].b7[k7].b6[k6].b5[k5].b4[k4].b3[1].y-=1
								b[k8].b7[k7].b6[k6].b5[k5].b4[k4].b3[2].y+=1
								b[k8].b7[k7].b6[k6].b5[k5].b4[k4].b3[3].x-=1
		if i>60 and i<65:
			for k8 in xrange(4):
				for k7 in xrange(4):
					for k6 in xrange(4):
						for k5 in xrange(4):
							for k4 in xrange(4):
								for k3 in xrange(4):
									b[k8].b7[k7].b6[k6].b5[k5].b4[k4].b3[k3].b2[0].x+=1
									b[k8].b7[k7].b6[k6].b5[k5].b4[k4].b3[k3].b2[1].y-=1
									b[k8].b7[k7].b6[k6].b5[k5].b4[k4].b3[k3].b2[2].y+=1
									b[k8].b7[k7].b6[k6].b5[k5].b4[k4].b3[k3].b2[3].x-=1
		if i==32 or i==64:#<2:
			for k8 in xrange(4):
				for k7 in xrange(4):
					for k6 in xrange(4):
						for k5 in xrange(4):
							for k4 in xrange(4):
								for k3 in xrange(4):
									for k2 in xrange(4):
										b[k8].b7[k7].b6[k6].b5[k5].b4[k4].b3[k3].b2[k2].b1[0].x+=1
										b[k8].b7[k7].b6[k6].b5[k5].b4[k4].b3[k3].b2[k2].b1[1].y-=1
										b[k8].b7[k7].b6[k6].b5[k5].b4[k4].b3[k3].b2[k2].b1[2].y+=1
										b[k8].b7[k7].b6[k6].b5[k5].b4[k4].b3[k3].b2[k2].b1[3].x-=1
		if i==32:#<1: #the actual rotation
			for k8 in xrange(4):
				for k7 in xrange(4):
					for k6 in xrange(4):
						for k5 in xrange(4):
							for k4 in xrange(4):
								for k3 in xrange(4):
									for k2 in xrange(4):
										for k1 in xrange(4):
											b[k8].b7[k7].b6[k6].b5[k5].b4[k4].b3[k3].b2[k2].b1[k1].px[0].x+=1
											b[k8].b7[k7].b6[k6].b5[k5].b4[k4].b3[k3].b2[k2].b1[k1].px[1].y-=1
											b[k8].b7[k7].b6[k6].b5[k5].b4[k4].b3[k3].b2[k2].b1[k1].px[2].y+=1
											b[k8].b7[k7].b6[k6].b5[k5].b4[k4].b3[k3].b2[k2].b1[k1].px[3].x-=1
											