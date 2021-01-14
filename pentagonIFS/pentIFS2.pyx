from libc.stdlib cimport rand
DEF phi=1.618  
cdef float cv[5][2], cp[2]
cdef Update():
    cdef int wh
    wh=rand()%5
    cp[0]=(cp[0]+cv[wh][0]*phi)/(phi+1)
    cp[1]=(cp[1]+cv[wh][1]*phi)/(phi+1)
cpdef Do(list p,list v):
    cdef int k,j
    for k in range(2):
        cp[k]=p[k]
        for j in range(5):
            cv[j][k]=v[j][k]        
    pts=[]
    for j in range(200000):
        Update()
        pts.append([cp[0],cp[1]])
    return pts