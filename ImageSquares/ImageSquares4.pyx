#ImageSquares4.pyx bulk square programs..
#Does the 3 colours separately. Do 2 versions
#1. draws black boxes outline (ie wont be squares, but overlapping squares...)
#-this is that one. Im not sure it will work! have to use semi-transparent colours, which ive not used. alpha=.5? 0.33? hmm

#2. doesnt - then dont use plotting at all, just write the 3 'used' arrays onto
#RGB layers and save as image. 
import numpy as np
cimport numpy as np
from scipy import misc
from sage.plot.polygon import polygon2d
from sage.misc.functional import show
from sage.plot.graphics import Graphics
from libc.math cimport abs
#import cProfile 

DEF maxImageSize = 330
DEF close=30 #counted as close colour. maybe make more sensitive!!
cdef int pjk[3], xx, yy, close
cdef int p[maxImageSize][maxImageSize][3] #**** NB THIS MUST BE BIGGER SIZE THAN 1/2 PIC W & Height !!
cdef inline int Sim(int xp, yp): #=1 if all 3 cols in p[xp][yp] are similar to cols of p[j][k]
	cdef int c
	for c in range(3): #ive no idea why using p[j][k][c] here doesnt work! pjk[c] seems the same to me.
		if abs(p[xp][yp][c]-pjk[c])>close: #not a match
			return 0
	return 1
def OK(): #short filename .png, closeness factor (bigger = larger squares, and fewer).20-80 best
	cdef int fail, q, j, k, m, n, side, wh, cc[3], temp, tally=0
	cdef bint found #"Amazon-Rainforest-1",
	fx=["Amazon-Rainforest-4","Amazon-Rainforest-5","Amazon-Rainforest-6","Amazon-Rainforest-7","fantastic_china-wallpaper-1280x720","feel_the_moment-wallpaper-1280x720","fishers_in_the_boat-wallpaper-1280x720","forest_stream_2-wallpaper-1280x720","grace-wallpaper-1280x720","rainforest-t2","rainforest-wallpaper-1600x1200"]
	for na in fx:#just change this one
		tally=0
		ext=".png"
		fn="/Downloads-1/newpicssmall/"+na+ext
		name="/Downloads-1/IS4RGBpics/"+na+"-%d" % close+ext #saves under this name, e.g. room-180.png
		a=misc.imread(fn)#tara-morelos-1f9b6.png")
		xx=a.shape[1]#/2-1 #beware - it loads pic sidewise, so correct for that
		yy=a.shape[0]#/2-1
		print fn,"->",name
		print "New pic dimensions:",xx,yy
		used=np.ones((xx,yy),dtype=int) 
#"used" array consists of 1s, plus larger squares of 0s, (up to side 255)
# with the upper left corner element in used[][] containing the size (side length) of the square. 
#make p array from pic. 1/4 size <-- no, not any more
		for wh in range(3):
			for j in xrange(xx):
				for k in xrange(yy):	#for each 2x2 pixel block, average this block of 4 pixels <-- No
					p[j][yy-1-k][wh]=a[k][j][wh]#temp/4 #average, also turn upside down
#find squares of similar colours          #for above, use ndarray swap?!
		for k in xrange(yy):
#		print yy-k
			for j in xrange(xx): #go across rows
				if used[j][k]==1: #hasn't been assigned yet, so assign.. find squares etc
					for q in range(3): #I have no idea why this is need. but p[j][k][q] dont work.
						pjk[q]=p[j][k][q]
					found=0 #=1 when found precise square size
					side=1
					while not found: #while found==0
						if j+side>xx-2 or k+side>yy-2: #right or bottom (top? hehe) edge 
							found=1
							continue
						else:
							side+=1					
#check if new top rh square is already used.. maybe another square already there
						if used[j+side-1][k]==0: 
#top right sq of new sq size already used in a square, so go back to smaller size
							found=1
							side=side-1
							break
						for q in xrange(side+1):
							if Sim(j+q,k+side-1)<1: #not the same col
								found=1
								side=side-1
								break 
						if not found: #this line to avoid deccing side twice
							for q in xrange(side):
								if Sim(j+side-1,k+q)<1:
									found=1
									side=side-1
									break
				#so now side = edge of similar-coloured square
					for m in xrange(side):
						for n in xrange(side):
							used[j+m][k+n]=0 #tag as part of larger square
					used[j][k]=side #and label top left pixel of square
#so now it's all converted to squares...
		print "Building graphics.."
		f=Graphics()
		#cdef list sq
		for j in xrange(xx-1): #-1 because mysteriously it does a row of 1x1 boxes at t and r edge
#		print xx-j
			for k in xrange(yy-1):
				if used[j][k]>0:
					side=used[j][k]
					sq=[[j,k],[j+side,k],[j+side,k+side],[j,k+side]]
					if side==1:
						f+=polygon2d(sq,color='#%02x%02x%02x' % (p[j][k][0],p[j][k][1],p[j][k][2]))+polygon2d(sq,color='black',fill=False,thickness=0.5)
					else: #i.e. side > 1
						for i in xrange(3):
							cc[i]=0
							for m in xrange(side):
								for n in xrange(side):
									cc[i]+=p[j+m][k+n][i]
							cc[i]=cc[i]/(side*side)	
						f+=polygon2d(sq,color='#%02x%02x%02x' % (cc[0],cc[1],cc[2]))+polygon2d(sq,color='black',fill=False,thickness=0.5)
					tally+=1
		print "Showing ",tally," squares: ......NOW! ... uh ... now! .. uh .. dammit.."
		f.save(name,axes=False,figsize=12,aspect_ratio=1)
	#print "Saved."
	#show(f,axes=False,figsize=12,aspect_ratio=1)