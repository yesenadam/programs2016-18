#ColourSeparate.pyx - 29 aug 2017
#split colour image into large R,G,B squares, each offset by (0,0),(1,1),(2,2)..
#(or multiples of that by making MULT>1)
import numpy as np
cimport numpy as np
from scipy import misc
DEF MULT=1 #size of colour blocks is MULTx3
cpdef OK():
	cdef int sum, m, n, j, i, k, HEI, WID
	cdef np.ndarray[np.uint8_t, ndim=3] a, b
	fn='/Users/admin/Tara200sq.png'#tiger9new.png'
	name='/Users/admin/Tara200sq-CSep.png'#tiger9new-colsep.png'
	a=misc.imread(fn)
	#a=np.rot90(a)
	HEI=a.shape[0] #arghh so its sideways? so should rot90 the array..
	WID=a.shape[1]
	print HEI,WID
	b=np.empty([HEI,WID,3],dtype=np.uint8)
	#rough version first
	HEI=HEI-HEI%(3*MULT)-3*MULT #so theyre div 3..
	WID=WID-WID%(3*MULT)-3*MULT
	for k in xrange(3): #R,G,B
		for i in xrange(k*MULT,WID+k*MULT,3*MULT):
			for j in xrange(k*MULT,HEI+k*MULT,3*MULT):
				sum=0
				for m in xrange(3*MULT):
					for n in xrange(3*MULT):
						sum+=a[j+n,i+m,k]
				sum=sum/((3*MULT)**2)
				for m in xrange(3*MULT):
					for n in xrange(3*MULT):
						b[j+n,i+m,k]=sum		
	
	misc.imsave(name,b)