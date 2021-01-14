from polygonedgecolor import polygon2d
from sage.plot.graphics import Graphics
DEF fract=0.2#0.7
DEF limit=5
cdef:
    int colour[5][3]
    float cv[5][2]
    float wave(float p, q, pw, qw): 
        return (p*pw+q*qw)/(pw+qw)
colour[0][:]=[51,102,0] #rich green
colour[1][:]=[0,102,253] #light blue
colour[2][:]=[255,153,0] #golden
colour[3][:]=[153,102,51] #brown
colour[4][:]=[45,134,45] #bluey green

cpdef subdiv(list v, float level, list areas):
    cdef:
        int j,k, jj, ar[5], nar[5]
        float COL[3], dx, dy, mid1[5][2], mid2[5][2], newp1[5][2], newp2[5][2], cen[2]
    for j in range(5):
        ar[j]=areas[j]
    if level==limit:
        for j in range(3):
            COL[j]=0
            for k in range(5):
                COL[j]+=ar[k]*colour[k][j]
            COL[j]/=limit*255  
        return polygon2d(v,rgbcolor=(COL[0],COL[1],COL[2]),fill=True,zorder=2)+polygon2d(v,rgbcolor=(0,0,0),fill=False,zorder=3)

    for k in range(2):
        cen[k]=0
        for j in range(5):
            cv[j][k]=v[j][k] #turns pyth list into c array
            cen[k]+=cv[j][k]
        cen[k]=cen[k]/5
# this moves mid1 and mid2 1/fract the length of the side off it.
    for j in range(5):
        jj=(j+1)%5
        for k in range(2):
            mid1[j][k]=wave(cv[j][k],cv[jj][k],2,1)
            mid2[j][k]=wave(cv[j][k],cv[jj][k],1,2)
        dx=mid1[j][0]-cv[j][0]
        dy=cv[j][1]-mid1[j][1]
        newp1[j][0]=mid1[j][0]-fract*dy
        newp1[j][1]=mid1[j][1]-fract*dx
        dx=cv[jj][0]-mid2[j][0]
        dy=mid2[j][1]-cv[jj][1]
        newp2[j][0]=mid2[j][0]+fract*dy
        newp2[j][1]=mid2[j][1]+fract*dx
    a=Graphics()
    for j in range(5):
        areas[j]+=1
        a+=subdiv([v[j],[newp1[j][0],newp1[j][1]],[newp2[j][0],newp2[j][1]],[cen[0],cen[1]],[newp2[(j+4)%5][0],newp2[(j+4)%5][1]]],level+1,areas)
        areas[j]-=1
    return a