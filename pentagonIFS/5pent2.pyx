from sage.plot.polygon import polygon2d
from sage.plot.graphics import Graphics
#'mid2' means the point on each pentagon edge, 2/3 towards the next vertex. (i.e. mid1 is 1/3 along)
cdef:
    float colour[5][3]
    float cv[5][2],p[12][2]
    float wave(float p, float q,float qw):
        return (p+q*qw)/(1+qw)
    float ave(float p, float q):
        return (p+q)/2
colour[0][:]=[51,102,0] #rich green
colour[1][:]=[0,102,253] #light blue
colour[2][:]=[255,153,0] #golden
colour[3][:]=[153,102,51] #brown
colour[4][:]=[45,134,45] #bluey green
#these two functions will alternate calling each other...
#but test 'level' before calling
#----------------------------------------------
cpdef firstsubdiv(list v, float level, int a0, int a1, int a2, int a3, int a4):
#input: 1 pentagon (5 points) output: 5 x (11 pts + centres) i.e. 5 altered pentagons
    cdef:
        float tot, mid2[5][2], newcen[5][2], pt1[5][2],pt2[5][2],pt10[5][2], cen[2], P[5][2],Q[5][2],M[2],N[2]
        int j
    cen[:]=[0,0]
    for j in range(5): #turns pyth list into c array
        for k in range(2):
            cv[j][k]=v[j][k]
    for j in range(4):
        for k in range(2):
            cen[k]+=cv[j][k]
            mid2[j][k]=wave(cv[j][k],cv[j+1][k],1.5)
    for k in range(2):
        mid2[4][k]=wave(cv[4][k],cv[0][k],1.5) #3/5 from v0->1
        cen[k]=(cen[k]+cv[4][k])/5
    pcen=[cen[0],cen[1]]
    pmid2=[];ppt1=[];ppt2=[];ppt10=[];pP=[];pQ=[];pnewcen=[]
    for j in range(5):
        pmid2.append([mid2[j][0],mid2[j][1]])
#find new centres - use v0,mid2[0],cen,mid2[4]
    for j in range(5):
        for k in range(2):
            newcen[j][k]=(cv[j][k]+mid2[j][k]+cen[k]+mid2[(j-1+5)%5][k])/4
#now calculate new points to pass
    for j in range(5):
        #on the line between cen and mid2
        for k in range(2):
            M[k]=ave(cen[k],mid2[j][k])
            N[k]=ave(M[k],mid2[j][k])
        #then move M 1/4 nearer centre of new pent 0
        #to get Q
            Q[j][k]=wave(newcen[j][k],M[k],3)
        #move N 1/4 nearer centre of new pent 1
        #to get P
            P[j][k]=wave(newcen[(j+1)%5][k],N[k],3)
         #(then p2 and p3 will be the p1 and p0 from the previous pent.)
#now only to find points 10,1 and 2.
            pt10[j][k]=wave(cv[(j-1+5)%5][k],cv[j][k],4)
            pt1[j][k]=wave(cv[(j+1)%5][k],cv[j][k],4)
            pt2[j][k]=wave(cv[(j+1)%5][k],cv[j][k],1.5)
        ppt2.append([pt2[j][0],pt2[j][1]])
        pQ.append([Q[j][0],Q[j][1]])
        pP.append([P[j][0],P[j][1]])
        ppt10.append([pt10[j][0],pt10[j][1]])
        ppt1.append([pt1[j][0],pt1[j][1]])
        pnewcen.append([newcen[j][0],newcen[j][1]])
#so make a list with the 11 points +centre
    cdef int jm1, s[5]
    s[:]=[0,0,0,0,0]
    a=Graphics()
    for j in range(5):
        if j==0: jm1=4
        else: jm1=j-1
        s[j]=1
        a+=subdiv([v[j],ppt1[j],ppt2[j],pmid2[j],pP[j],pQ[j],pcen,pQ[jm1],pP[jm1],pmid2[jm1],ppt10[j]],pnewcen[j],level+1,a0+s[0],a1+s[1],a2+s[2],a3+s[3],a4+s[4])
        s[j]=0 
    return a
#---------------------------------------------------
#Subdiv - called by the (initial) sub-pentagons..
#aka 11-sided shapes 8|
cpdef subdiv(list v, list centre, float level, int a0, int a1, int a2, int a3, int a4):
    cdef:
        float tot, COL[3], p9m10[2], p1m2[2], p1mc[2]
        int j=0
        float mid1[5][2], mid2[5][2],c[2], cen[2]
    cen[:]=[0,0]
    for j in range(11): #turns pyth list into c array
        for k in range(2):
            p[j][k]=v[j][k]
    for k in range(2):
        c[k]=centre[k]
#******* then just add the 3 new points here
    for k in range(2):
        p9m10[k]=ave(p[9][k],p[10][k])
        p1m2[k]=ave(p[1][k],p[2][k])
        p1mc[k]=ave(p[1][k],c[k])
    pp9m10=[];pp1m2=[];pp1mc=[];pent=[]
    pp9m10=[p9m10[0],p9m10[1]]
    pp1m2=[p1m2[0],p1m2[1]]
    pp1mc=[p1mc[0],p1mc[1]]
#NB! no need to increase level here - or it will increase by 2 each level. <-- ?? is tht right?!
#work out pentagons
    pent.append([[v[0],v[1],pp1mc,centre,v[10]],level,a0+1,a1,a2,a3,a4])
    pent.append([[v[1],pp1m2,v[2],centre,pp1mc],level,a0,a1+1,a2,a3,a4])
    pent.append([[v[3],v[4],v[5],centre,v[2]],level,a0,a1,a2+1,a3,a4])
    pent.append([[v[6],v[7],v[8],centre,v[5]],level,a0,a1,a2,a3+1,a4])
    pent.append([[v[9],pp9m10,v[10],centre,v[8]],level,a0,a1,a2,a3,a4+1])
    if level>1:
        #print pent
        a=Graphics()
        tot=a0+a1+a2+a3+a4
        for k in range(5):
            for j in range(3): #NB pent[][2]=a0 etc
                COL[j]=(pent[k][2]*colour[0][j]+pent[k][3]*colour[1][j]+pent[k][4]*colour[2][j]+pent[k][5]*colour[3][j]+pent[k][6]*colour[4][j])/(tot*255)
            a+= polygon2d(pent[k][0],rgbcolor=(COL[0],COL[1],COL[2]),fill=True,zorder=2)+polygon2d(pent[k][0],rgbcolor=(0,0,0),fill=False,zorder=3)
        return a
    #(else)
    a=Graphics()
    for j in range(5):
        a+=firstsubdiv(pent[j][0],pent[j][1],pent[j][2],pent[j][3],pent[j][4],pent[j][5],pent[j][6])
    return a