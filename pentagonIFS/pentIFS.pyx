from sage.functions.other import floor
from sage.misc.prandom import random

cpdef WAve(r,s,sw):
    return [(r[j]+s[j]*sw)/(1+sw) for j in range(2)]        
cpdef Do(p,v):
    pts=[]
    for j in range(200000):
        p=WAve(p,v[floor(random()*5)],1.618)
        pts.append(p)
    return pts