#PixelSum.pyx - 31 aug 2017
#go along pixel rows, adding R,G,B totals separately, dump a 255 pixel when sum>255... 
#maybe do boustrophedon so pixel is nearer where it came from...... hmm
#maybe 2x2 blocks or 3x3 will look better..........
import numpy as np
cimport numpy as np
from scipy import misc
cpdef OK():
	cdef int sum, row, column, colour, HEIGHT, WIDTH
	cdef np.ndarray[np.uint8_t, ndim=3] inpic, outpic
	infile='/Users/admin/Tara200sq.png'
	outfile='/Users/admin/Tara200sq-pixsum.png'
	inpic=misc.imread(infile)
	HEIGHT=inpic.shape[0] 
	WIDTH=inpic.shape[1]
	print HEIGHT,WIDTH
	outpic=np.zeros([HEIGHT,WIDTH,3],dtype=np.uint8)
	for colour in xrange(3): #R,G,B 
		sum=0
		for row in xrange(0,HEIGHT-1,2):
			for column in xrange(WIDTH):
				sum+=inpic[row,column,colour]
				if sum>255:
					outpic[row,column,colour]=255
					sum-=255
			for column in xrange(WIDTH-1,0,-1):
				sum+=inpic[row+1,column,colour]
				if sum>255:
					outpic[row+1,column,colour]=255
					sum-=255
	misc.imsave(outfile,outpic)