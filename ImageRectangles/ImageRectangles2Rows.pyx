#ImageRectangles2.pyx - Sept 2016
# the "2" means it works on single files, like ImageSquares2.
#v3 will convert whole folders.
import numpy as np
from scipy import misc
#from sage.plot.polygon import polygon2d
from polygonedgecolor import polygon2d
#NB! I downloaded the version of polygon.py with edgecolor fixed (2014) and put in my home folder as 'polygonedgecolor.py'
#otherwise use old polygon2d, and draw coloured square and black boundary separately.
#downloaded from https://git.sagemath.org/sage.git/tree/src/sage/plot/polygon.py?id=a1c72c36c80752f748036ac4f19008896118815f
from sage.misc.functional import show
from sage.plot.graphics import Graphics
from libc.math cimport abs
#test if importing abs actually makes it faster
DEF maxImageSize = 330 # change this, or use 'sips -Z 320 *.*' to resize pics. Height and width must be smaller than 330.
DEF close=30 #counted as close colour.
#puts pixels with all R,G,B closer than 30 in the same square. 80=bigger squares, less sensitive. 
cdef int pjk[3], xx, yy, close
fn="/Downloads-1/newpicssmall/Santorini-Greece-8-1.png"
na=fn[:fn.find('.')] #strip off the '.png' - does this work if the . is missing?! guess not
a=misc.imread(fn)
xx=a.shape[1]#/2-1 #beware - it loads pic sidewise, so correct for that
yy=a.shape[0]#/2-1
polygon2d.options['thickness']=0.5
polygon2d.options['edgecolor']='black'
cdef int p[maxImageSize][maxImageSize][3] 
cdef inline int Sim(int xp, yp): #=1 if all 3 cols in p[xp][yp] are similar to cols of p[j][k]
	cdef int c
	for c in range(3): #ive no idea why using p[j][k][c] here doesnt work! pjk[c] seems the same to me.
		if abs(p[xp][yp][c]-pjk[c])>close: #not a match
			return 0
	return 1
def OK(): #closeness factor (bigger = larger squares, and fewer).20-80 best
	cdef int fail, q, j, k, m, n, side, side2, wh, cc[3], temp, tally=0
	cdef bint found
	print fn
	print "Pic dimensions:",xx,"x",yy
	used=np.ones((xx,yy),dtype=int) 
	used2=np.ones((xx,yy),dtype=int) #for the second dimension of the 'squares'.. say.. the height. 
#"used" array consists of 1s, plus larger squares of 0s, (up to side 255)
# with the upper left corner element in used[][] containing the width of the rectangle.
#corresponding element in array used2[][] contains its height. 
	for wh in range(3):
		for j in xrange(xx):
			for k in xrange(yy):
				p[j][yy-1-k][wh]=a[k][j][wh] #average, also turn upside down
#find squares of similar colours          #for above, use ndarray swap?!
#originally I had "for j in" in the outer loop.. but that draws boxes in columns.. maybe horizontally in rows looks better..
#	for k in xrange(yy):
	for j in xrange(xx): #go across rows
#		print yy-k #use this to observe progress if it's running too slowly
		for k in xrange(yy):
#		for j in xrange(xx): #go across rows
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
#					if used[j+side-1][k]==0: #NB!! original version
					if used[j][k+side-1]==0: # 'rows' version. swap back
#top right sq of new sq size already used in a square, so go back to smaller size

#NB in Rectangles version: found=1 --> it was blocked in x-direction. so add more in y-direction.
#found=2 --> it was blocked in y-direction. so add more in x-direction.
#used[] array holds val of x-dimension of rect. used2[] array holds y-dimension. initially the same.
#so if found=1, add to used2. if found =2, add to used.. 
						found=2 #i.e. y side blocked
						side=side-1
						break
					for q in xrange(side+1):
						if Sim(j+q,k+side-1)<1: #not the same col
							found=1 #blocked in x-dir
							side=side-1
							break 
					if not found: #this line to avoid deccing side twice
						for q in xrange(side):
							if Sim(j+side-1,k+q)<1:
								found=2 #blocked in y-direction
								side=side-1
								break
				#so now side = edge of similar-coloured square
				#now add more if possible to make rectangle.
				side2=side #set y direction for used2 array
				#make found=3 to indicate totally finished.
				if found==1: #blocked in x-dir so add rows in y-direction if possible
					while found<3:
						if j+side>xx-2 or k+side2>yy-2: #right or bottom (top? hehe) edge 
							found=3
							continue
						else:
							side2+=1					
						if used[j][k+side2-1]==0: # maybe another square/rect already there
							found=3 #i.e. y side blocked
							side2-=1
							break
						#check added row in ydirection
						for q in xrange(side):
							if Sim(j+q,k+side2-1)<1:
								found=3 #blocked in y-direction
								side2-=1
								break
				if found==2: #blcked in y-dir so add columns in x-direction
					while found<3:
						if j+side>xx-2 or k+side2>yy-2: #right or bottom (top? hehe) edge 
							found=3
							continue
						else:
							side+=1					
						if used[j+side-1][k]==0: # maybe another square/rect already there
							found=3 #i.e. y side blocked
							side-=1
							break
						#check added column in x-rection
						for q in xrange(side2):
							if Sim(j+side-1,k+q)<1:
								found=3 #blocked in y-direction
								side-=-1
								break
				for m in xrange(side):
					for n in xrange(side2):
						used[j+m][k+n]=0 #tag as part of larger square
				used[j][k]=side #and label top left pixel of square
				used2[j][k]=side2 #and label top left pixel of square
#so now it's all converted to squares...
	print "Building graphics.."
	f=Graphics()
	cdef list sq
	for j in xrange(xx-1): #-1 because mysteriously it does a row of 1x1 boxes at t and r edge
#		print xx-j
		for k in xrange(yy-1):
			if used[j][k]>0:
				side=used[j][k]
				side2=used2[j][k]
				sq=[[j,k],[j+side,k],[j+side,k+side2],[j,k+side2]]
				if side==1 and side2==1: 
					f+=polygon2d(sq,color='#%02x%02x%02x' % (p[j][k][0],p[j][k][1],p[j][k][2]))
				else: #i.e. side > 1 or side2>0
					for i in xrange(3): #average colours
						cc[i]=0
						for m in xrange(side):
							for n in xrange(side2):
								cc[i]+=p[j+m][k+n][i]
						cc[i]=cc[i]/(side*side2)	
					f+=polygon2d(sq,color='#%02x%02x%02x' % (cc[0],cc[1],cc[2]))
				tally+=1
	print "Showing ",tally," squares: ......NOW! ... uh ... now! .. uh .. dammit.."
	name=na+"-%d" % close+"rows-"+"%drects.png" % tally #saves under this name, e.g. room-180.png ##NB put "rows" in name if it does rows first..
	f.save(name,axes=False,figsize=12,aspect_ratio=1)
	print "Saved",name
	#show(f,axes=False,figsize=12,aspect_ratio=1) #'show' is slower than just saving.