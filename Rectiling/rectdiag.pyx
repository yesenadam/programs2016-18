from sage.misc.functional import show
from sage.plot.graphics import Graphics
from sage.plot.line import line2d
from sage.plot.text import text
from polygonedgecolor import polygon2d as p
#from sage.plot.polygon import polygon2d as p
#NB edgecolor has only worked since 2014;download the new polygon.py if needed
from sage.misc.latex import latex
from libc.math cimport abs
f=Graphics()
rect=[]
cdef draw(int T,int R,int B,int L):
	global rect,f
	rect=[[L,B],[R,B],[R,T],[L,T]]
	f+=p(rect,color="black",fill=False)
	cdef int w=R-L
	cdef int h=T-B
	
	f+=text("${}$ x ${}$".format(w,h),((L+R)/2.0,(T+B)/2.0),color="black")
draw(9,8,0,0)
draw(10,11,0,8)
draw(23,8,9,-1)
draw(23,21,10,8)
draw(43,9,23,-1)
draw(39,21,23,9)
show(f,aspect_ratio=1,figsize=10,axes=False)