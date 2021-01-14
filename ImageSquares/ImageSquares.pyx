#ImageSquares.pyx
import numpy as np
from scipy import misc
from sage.plot.polygon import polygon2d
from sage.misc.functional import show
from sage.plot.graphics import Graphics
#import matplotlib.pyplot as plt 
#maybe test with small images!! hand-made, so i can see what its doing...
DEF close=30#0.1 #counted as close colour. maybe make more sensitive!!
cpdef int Sim(list pts, list pt):  #px,p[j][k]) 
	#I think! are of form [[R,G,B],[R,G,B]..] and [R,G,B]
	cdef int i, c
	#=1 true if all points in 'pts' are of similar colour to 'pt' - all 3 R, G, B are close
	for i in pts:
		for c in range(3):
			if abs(pt[c]-pts[i][c])>close: #not a match
				return 0
	return 1		
def OK():
	a=misc.imread("/Downloads-1/tara-morelos-1f9b6.png")
	cdef int i,j,k,m, n, look, side, px, xx, yy, wh, col[3], temp
	xx=a.shape[0]/2-1
	yy=a.shape[1]/2-1
	p =np.empty((xx,yy,3))
	used=np.ones((xx,yy),dtype=int) #consists of 1s, plus larger squares of 0s,
# with the upper left corner containing the size (side length) of the square. 
#(when this is come across, draw the square)
#make p array from pic. 1/4 size
	for j in range(xx):
		for k in range(yy):
			#for each 2x2 pixel block
			#average this block of 4 pixels
			for wh in range(3):
				temp=0
				for m in range(2):
					for n in range(2):
						temp+=a[j*2+m][k*2+n][wh]
				p[j][k][wh]=temp/4
#findsquares of similar colours
	for k in range(yy):
		for j in range(xx): #go across rows
			if used[j][k]==1:
				look=0
				side=1
				while look==0:
					side+=1
					#search bottom and right edge
		#check if new top rh square is already used.. maybe another square already there
					if p[j+side-1][k]==0: #already used
						look=1
						side=side-1
						continue
					bEdge=p[j:j+side-1][k+side-1]
					rEdge=p[j+side-1][k:k+side-2]
					for px in bEdge:
						if Sim(px,p[j][k])<1: #not the same col
							look=1
							side=side-1
							break #does that work?
					for px in rEdge:
						if Sim(px,p[j][k])<1:
							look=1
							side=side-1
							break
					#look=1
				#so now side=edge of sim col square
				for m in range(side):
					for n in range(side):
						used[j+m][k+n]=0
				used[j][k]=side #and label top left pixel of square
	#so now it's converted to squares...
	f=Graphics()
	for j in range(xx):
		for k in range(yy):
			if used[j][k]>0:
				side=used[j][k]
				f+=polygon2d([[j,k],[j+side,k],[j+side,k+side],[j,k+side]],rgbcolor=(p[j][k][0],p[j][k][1],p[j][k][2]),fill=True)
				f+=polygon2d([[j,k],[j+side,k],[j+side,k+side],[j,k+side]],color='black',fill=False,thickness=0.5)#rgbcolor=(p[j][k][0],p[j][k][1],p[j][k][2]))
	show(f,axes=False)