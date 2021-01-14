#PixelShiftv2.pyx - v1 Sept 2016
#NB get rid of the ndarray type-ing and this will work.
#I have to put the array declarations inside the OK() method for it to work apparently.
#So will do that and call that v2.

#Tries to move pixels around, sorting them..
#Compares 4 pixels, if 1&3 are closer (either in RGB ave or do colours separately!) maybe in v2 - then 2 and 3 are swapped. Test each pixel in all 4 directions, move it in the 'best' direction, if there is one better.
#Limit the allowable distance from home.
import numpy as np
#cimport numpy as np
#DTYPE=np.int
#ctypedef np.int_t DTYPE_t
from scipy import misc
#from sage.plot.polygon import polygon2d
#from polygonedgecolor import polygon2d
#from sage.misc.functional import show
#from sage.plot.graphics import Graphics
DEF maxImageSize = 800 #make sure image is no bigger.
DEF DIST = 1 #distance pixels are allowed to move from home.
cdef int xx, yy, sum, temp[2], i, j, k, h[maxImageSize][maxImageSize][2]
cdef int maxoff[2]#=[0,0]
cdef int minoff[2]#=[0,0]
maxoff[:]=[0,0]
minoff[:]=[0,0]
#h keeps a record of where in the a-array to find the point(s) currently
#being considered.
#*****h[][][0]=x val, [1]=y val
#function to find original pos of curr pix
#cdef int Orig(int x,y,w):
## returns orig coord (w=0->x,w=1->y) of current point x,y.
#	return h[x][y][w]
cpdef int Offset(int x,y,w): #gives dist from home, w=0 x coord, =1 y coord
#NB (Manh.) distance would be the sum of the abs of these x and y diffs
#use un-absolute value to be able to see effect of swapping, whether
#it will increase DIST too much ...
	if w==0: #want x coord
		return x-h[x][y][0]
	else:
		return y-h[x][y][1]
fn="/Downloads-1/point-reyes-398+342-7331.png"#"/Downloads-1/newpicssmall/sumatran-tiger_crop_0.png"
na=fn[:fn.find('.')] #strip off the '.png' - does this work if the . is missing?! guess not
#name=na+"-%d" % close+"rows.png" 
def OK():
	def CurrCol(int x,y,c):
		#returns colour num. c (R=0 etc) of curr point.
		return a[h[x][y][0]][h[x][y][1]][c]
	#sigh. maybe just copy array a into a C array if this doesnt work.
	def Diff(int x1,y1,x2,y2):
		#returns sum of R,G,B differences of 2 points.
		sum=0
		for i in range(3):
			sum+=abs(CurrCol(x1,y1,i)-CurrCol(x2,y2,i))
		return sum
	cdef int m, sum1, sum2, changed=0
#	cdef np.ndarray[DTYPE_t, ndim=3] a
	a=misc.imread(fn)
	#a=np.rot90(a)
	xx=a.shape[0] #arghh so its sideways? so should rot90 the array..
	yy=a.shape[1]
	#cdef np.ndarray[DTYPE_t,ndim=3] 
	b=np.empty([yy,xx,3],int)#dtype=DTYPE_t) # i THINK these need to be reversed..
	#now initialize h array
	for j in range(xx):
		for k in range(yy):
			h[j][k][0]=j #original x-location of point now at x,y
			h[j][k][1]=k #original y-loc of etc
	#polygon2d.options['thickness']=0.5
	#polygon2d.options['edgecolor']='black'
	#:-) Unintentionally, I made it so it can be run again and again,
	#swapping more pixels..

#	for m in range(DIST): #not sure if that's enough or too much.. 
# uncomment m loop later. just do picture once in first version.
#but needs more than 1 loop of everything if dist>1. maybe if dist=1 also. no se lo que pasara
	print "Pixel Shift v1"
	for k in range(1,yy-1):
		for j in range(1,xx-1): #from 1 after start to 2 before end of ary.
			#test effect of swapping middle 2 points of a,b,c,d in a row
			#first, horiz test. points from x=j-1 to j+2, y=k.
			sum1=Diff(j-1,k,j,k)+Diff(j+1,k,j+2,k) #diff(a-b)+diff(c-d)
			sum2=Diff(j-1,k,j+1,k)+Diff(j,k,j+2,k) #diff(a-c)+diff(b-d)
#so, if sum1>sum2 then swap points. UNLESS doing that makes
#points b or c too far from original home.
#I guess in 1st version, just swap (unless it goes nuts) and dont
#check how far the pixels move. may work, may not - i.e. improve image
			if sum1>sum2: # so swap points b (j,k) and c (j+1,k)
				for i in range(2):
					temp[i]=h[j][k][i]
					h[j][k][i]=h[j+1][k][i]
					h[j+1][k][i]=temp[i]
				changed+=1 #count the changes made
#				print "H-swap. j={} k={}. sum1={} sum2={} new xoffset={} yoffset={}".format(j,k,sum1,sum2,Offset(j+1,k,0),Offset(j+1,k,1)) #new c, was old b
				#just record max offset.
				for i in range(2):
					if Offset(j+1,k,i)>maxoff[i]:
						maxoff[i]=Offset(j+1,k,i)
				for i in range(2):
					if Offset(j+1,k,i)<minoff[i]:
						minoff[i]=Offset(j+1,k,i)
			#now vertical test. points from y=k-1 to k+2, x=j.
			sum1=Diff(j,k-1,j,k)+Diff(j,k+1,j,k+2) #diff(a-b)+diff(c-d)
			sum2=Diff(j,k-1,j,k+1)+Diff(j,k,j,k+2) #diff(a-c)+diff(b-d)
#so, if sum1>sum2 then swap points. UNLESS doing that makes
#points b or c too far from original home.
#I guess in 1st version, just swap (unless it goes nuts) and dont
#check how far the pixels move. may work, may not - i.e. improve image
			if sum1>sum2: # so swap points b (j,k) and c (j+1,k)
				for i in range(2):
					temp[i]=h[j][k][i]
					h[j][k][i]=h[j][k+1][i]
					h[j][k+1][i]=temp[i]
				changed+=1 #count the changes made
				#print "V-swap. j={} k={}. sum1={} sum2={} 
				#new xoffset={} yoffset={}"
				#.format(j,k,sum1,sum2,Offset(j,k+1,0),Offset(j,k+1,1)) #new c, was old b
				#just record max offset.
				for i in range(2):
					if Offset(j,k+1,i)>maxoff[i]:
						maxoff[i]=Offset(j,k+1,i)
				for i in range(2):
					if Offset(j,k+1,i)<minoff[i]:
						minoff[i]=Offset(j,k+1,i)
	#copy vals from h to b array
	for j in range(xx):
		for k in range(yy):
		#write the y to the x-val of b.....
			for i in range(3): #um, i think need to swap j and k here..
				#and maybe invert! 
				b[k][j][i]=a[h[j][k][0]][h[j][k][1]][i]
	b2=np.rot90(b,3)
	b2=np.fliplr(b2)
	misc.imsave('point-reyes-398+342-7331-pixshifted.png',b2)
	print changed,"changes made."
	print "Max x offset = ",maxoff[0]
	print "Max y offset = ",maxoff[1]
	print "Min x offset = ",minoff[0]
	print "Min y offset = ",minoff[1]
