#ImageSquares3Rows.pyx bulk square programs.. transforms every png image in a folder.
#works only with pngs currently, and image sides <maxImageSize=322. resize to 320 with "sips -Z 320 *.*"
import numpy as np
import glob
from scipy import misc
from polygonedgecolor import polygon2d #my name for the updated 2014 version. in which 'edgecolor' works.
from sage.misc.functional import show
from sage.plot.graphics import Graphics
from libc.math cimport abs
DEF maxImageSize = 322 #**** NB THIS MUST BE LARGER THAN PIC Wid & Height !! resize pics with 'sips -Z 320 *.*'
DEF close=30 #i.e. a pixel with R, G AND B vals within +/-20 of current px is counted as close - put in same square
polygon2d.options['thickness']=0.5
polygon2d.options['edgecolor']='black'
cdef int pjk[3], xx, yy, p[maxImageSize][maxImageSize][3] 
cdef inline bint Similar(int xp, yp): #=1 if all 3 cols in p[xp][yp] are similar to cols of p[j][k]
	cdef int c
	for c in range(3): #ive no idea why using p[j][k][c] here doesnt work! pjk[c] seems the same to me.
		if abs(p[xp][yp][c]-pjk[c])>close: #not a match
			return 0
	return 1
def OK(): #closeness factor (bigger = larger squares, and fewer).20-80 best
	cdef int fail, q, j, k, m, n, side, wh, cc[3], temp, tally=0
	cdef bint found 
	fx=glob.glob("/Downloads-1/to-square/*.png") #folder of only the png images you want to transform.
	for fn in fx:
		tally=0  #IT SHOULD PUT THEM in a new folder, so can run the command again with different 'close'.
		ext=".png"
		na=fn[:fn.find('.')] #remove ext.
		a=misc.imread(fn)
		xx=a.shape[1]#/2-1 #beware - it loads pic sidewise, so correct for that
		yy=a.shape[0]#/2-1
		print fn#,"->",name
		print "New pic dimensions:",xx,"x",yy
		used=np.ones((xx,yy),dtype=int) 
#"used" array consists of 1s, plus larger squares of 0s, (up to side 255)
# with the upper left corner element in used[][] containing the size (side length) of the square. 
		for wh in range(3):
			for j in xrange(xx):
				for k in xrange(yy):	
					p[j][yy-1-k][wh]=a[k][j][wh]#temp/4 #average, also turn upside down
#find squares of similar colours          #for above, use ndarray swap?!
		for j in xrange(xx): #go across rows
			for k in xrange(yy):
#		print yy-k
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
#						if used[j+side-1][k]==0: 
						if not used[j][k+side-1]: # 'rows' version. swap back
#top right sq of new sq size already used in a square, so go back to smaller size
							found=1
							side-=1
							break
						for q in xrange(side+1):
							if not Similar(j+q,k+side-1): #<1: #not the same col
								found=1
								side-=1
								break 
						if not found: #this line to avoid deccing side twice
							for q in xrange(side):
								if not Similar(j+side-1,k+q): #<1:
									found=1
									side-=1
									break
				#so now side = edge of similar-coloured square
					for m in xrange(side):
						for n in xrange(side):
							used[j+m][k+n]=0 #tag as part of larger square
					used[j][k]=side #and label top left pixel of square
#so now it's all converted to squares...
		print "Building graphics.."
		f=Graphics()
		for j in xrange(xx-1): #-1 because mysteriously it does a row of 1x1 boxes at t and r edge
#		print xx-j
			for k in xrange(yy-1):
				if used[j][k]>0:
					side=used[j][k]
					sq=[[j,k],[j+side,k],[j+side,k+side],[j,k+side]]
					if side==1:
						f+=polygon2d(sq,color='#%02x%02x%02x' % (p[j][k][0],p[j][k][1],p[j][k][2]))
					else: #i.e. side > 1
						for i in xrange(3):
							cc[i]=0
							for m in xrange(side):
								for n in xrange(side):
									cc[i]+=p[j+m][k+n][i]
							cc[i]=cc[i]/(side*side)	
						f+=polygon2d(sq,color='#%02x%02x%02x' % (cc[0],cc[1],cc[2]))
					tally+=1
		print "Saving",tally,"squares: ......NOW! ... uh ... now! .. uh .. dammit.."
		name=na+"-cl%d-rows" % close+"-sq%d" % tally+ext #saves under this name, e.g. room-180-rows.png
		f.save(name,axes=False,figsize=12,aspect_ratio=1)
		print "Saved",name