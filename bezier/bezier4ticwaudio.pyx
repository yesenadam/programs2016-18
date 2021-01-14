#bezier4ticwaudio.pyx

#ffmpeg -f image2 -r 30 -i /Users/admin/bezier/bezier-%05d.png -i /Users/admin/bezier4ticwaudio-1.wav -vcodec h264 -crf 23 bezaud.mp4
DEF MAXPTS = 5
DEF WID=1280
DEF HEI = 720
DEF STEPS=500+1 #1 for final finished frame
DEF SAMPLERATE=44100.0 #Hz
DEF FRAMES=500 +60#in 1 bezier scene, plus 2 extra secs
DEF FPS=30 #frames per sec in animation
DEF TOTALSAMPLES=735000+2*44100 #SAMPLERATE*(FRAMES/FPS)
DEF NUMPTS=5
DEF PI=3.14159265358979
DEF OCTAVERANGE=2 #was 1 - difference between highest and lowest control point on screen
import numpy as np
cimport numpy as np
from scipy import misc
from libc.math cimport fabs,round,pow
from libc.stdlib cimport rand
from libc.math cimport round, sin,pow,log2 #is in range -pi/2 -> pi/2
import wave, struct
cdef float rootNote=220.0
cdef float s[TOTALSAMPLES+10] #avoid overstepping

cdef struct pt:
	float x,y
cdef struct rgb:
	int col[3]
cdef pt P[MAXPTS]
cdef int cimg[WID][HEI][3]
cdef rgb white,green, blue, red, rg, gb
white.col[:]=[255,255,255]
green.col[:]=[0,255,20]
red.col[:]=[255,60,60]
blue.col[:]=[60,60,255]
rg.col[:]=[255,255,0]
gb.col[:]=[0,255,255]


cdef void Set(int x,int y, rgb r) nogil:
	cdef int c
	if x<0 or x>WID-1 or y<0 or y>HEI-1:
		return
	for c in xrange(3):
		cimg[x][HEI-1-y][c]=r.col[c] #upside down!! (y=0 is the top)
		
cdef void fSet(pt P, rgb r) nogil: #draw nearest pixel to floating point
	cdef int c, x=rnd(P.x),y=rnd(P.y)
	if x<0 or x>WID-1 or y<0 or y>HEI-1:
		return
	for c in xrange(3):
		cimg[x][HEI-1-y][c]=r.col[c] #upside down!! (y=0 is the top)

cdef void SetMore(int x,int y, rgb r) nogil: #blends with existing colour, makes lighter..
#but how to draw dark!
	cdef int c,lev
	if x<0 or x>WID-1 or y<0 or y>HEI-1:
		return
	for c in xrange(3):
		lev=cimg[x][HEI-1-y][c]+r.col[c]
		if lev>255:
			lev=255
		cimg[x][HEI-1-y][c]=lev #upside down!! (y=0 is the top)

cdef int rnd(float f) nogil:
	return int(round(f))

cdef rgb colourFract(float f,rgb c):
	#where 0<=f<=1
	cdef rgb r
	cdef int i
	cdef float fc
	if f<0 or f>1:
		print "ERROR!"
		return r
	for i in xrange(3):
		fc=f*float(c.col[i])
		r.col[i]=rnd(fc)
	return r
	
cdef void Plot(pt M, pt N, rgb colour):#int a, int b, int c, int d):
	cdef int i, inc, lower, higher
	cdef float a=M.x, b=M.y, c=N.x, d=N.y
	cdef float ratio,finc, ldist, hdist
	if a==c:
		if b==d:
			return
		if d>b:
			inc=1
		else:
			inc=-1
		for i in xrange(rnd(b),rnd(d+1),inc): #uh this might work if b and d are very close!
			SetMore(rnd(a),i,colour)
	if b==d:
		if c>a:
			inc=1
		else:
			inc=-1
		for i in xrange(rnd(a),rnd(c+1),inc): #mut. mut.
			SetMore(i,rnd(b),colour)
	if fabs(d-b)>=fabs(a-c):
		if d>b:
			inc=1
		else:
			inc=-1
		ratio=(c-a)/(d-b)
		for i in xrange(rnd(b),rnd(d+1),inc):
			finc=ratio*(i-b)
			lower=int(a+finc)
			higher=lower+1
			ldist=fabs(a+finc-lower)
			hdist=fabs(a+finc-higher) #are not these always adding to 1?!
			#so the smaller dist gets larger fract : swap
			SetMore(lower,i,colourFract(hdist,colour))
			SetMore(higher,i,colourFract(ldist,colour))
			
	else:
		if c>a:
			inc=1
		else:
			inc=-1
		ratio=(d-b)/(c-a)
		for i in xrange(rnd(a),rnd(c+1),inc):
#			finc=ratio*(i-a)
#			Set(i,rnd(b+finc),colour)
			finc=ratio*(i-a)
			lower=int(b+finc)
			higher=lower+1
			ldist=fabs(b+finc-lower)
			hdist=fabs(b+finc-higher) #are not these always adding to 1?!
			#so the smaller dist gets larger fract : swap
			SetMore(i,lower,colourFract(hdist,colour))
			SetMore(i,higher,colourFract(ldist,colour))

cdef pt deCast(float t,pt A, pt B):
	return [(1-t)*A.x+t*B.x,(1-t)*A.y+t*B.y]	

cdef ChoosePts():
	cdef int i,fi
	#***change this so it chooses better than random. 
	#-make sure wide spread. use top and bottom pitches
	#-no points too close, widely spread in x and y.......
	#mainly y, since that determines pitch...
	#maybe, dont use any note 1 or 2 semitones from an existing note.
	
	#-especially adjacent control points
	
	#x=random 50-1230
	#y=between 50-670, but highest is octave above lowest??
	#or just choose all piano notes... hmm yeah
	#NO, make it 2 octaves I think... sounds more exciting :-)
	#so get freqs to choose from
	cdef float q,notes[OCTAVERANGE*12+1] #note[0]=y50, notes[12]=notes yHEI-50
	#so freq ratio 1 --> 2  ======> 50 -> HEI-50
	for i in xrange(OCTAVERANGE*12+1): #0 to 12*octaves = 24 if octs=2
		fr= rootNote*pow(2.0,float(i)/12.0)
		print i,fr
		notes[i]=fr
	for i in xrange(MAXPTS):
		q=notes[rand()%(OCTAVERANGE*12+1)] # rand 0 - 12
		P[i].y=convertHzToY(q)
		P[i].x=rand()%(WID-100)+50
		print i,q,P[i]
		
cdef float convertYToHz(float y): #NB!!!!! invert Y here and in next function!!
	cdef float h=y-50 #0 -> HEI-100
	cdef float fract,range=HEI-100.0
	#0 goes to 1x root ,2^0, HEI goes to 2xOCTAVERANGE x root,2^OCTAVERANGE
	fract=float(OCTAVERANGE)*h/range #0 -> OCTAVERANGE (1 or 2)
	return pow(2,fract)*rootNote

cdef float convertHzToY(float f):
	cdef float rootmult=f/rootNote #1 --> 2^OCTAVERANGE (2 or 4)
	cdef float range= log2(rootmult) #0 -> 2
	return (range/float(OCTAVERANGE))*(HEI-100)+50
	

cdef AddWave(pt w[],float pitchMultiplier,float volumeMultiplier):
	#pass P01[] array etc.. STEPS long..
	#interpolate 1470 samples for each data point....
	cdef int samplesPerFrame=1470 #44100/30
	cdef:
		int count=0,i, j,k,w0,w1#initial & final wavelength
		float flev #-32767 -> 32767, audio data sample
		float multiplier=1000.0*volumeMultiplier #for 10 waves, can be 3200?
		float angle=0.0
		float freq
		float fInit,fFinal,ratio
		float revsPerSample=2*PI/SAMPLERATE
	#loop over P[i],P[i+1] frqs
	for i in xrange(STEPS+1): #but need 1 extra frame for finished curves, missing until now
		fInit=convertYToHz(w[i].y)*pitchMultiplier
		fFinal=convertYToHz(w[i+1].y)*pitchMultiplier
		for k in xrange(samplesPerFrame):
		#calc freq needed, ratio:1 of the way from f[i] to f[j] Hz
			ratio=float(k)/float(samplesPerFrame)
			#freq=ratio*fInit+(1-ratio)*fFinal
			freq=ratio*fFinal+(1-ratio)*fInit
			angle+=freq*revsPerSample
			if angle>2*PI:
				angle-=2*PI
			flev=multiplier*sin(angle)
			s[count]+=flev
			count+=1
	#now 2 seconds more of final note
#freq stays what it last was..
#	freq=fFinal #WHY DOESNT IT WORKL?? VERY STRANGE
	for i in xrange(60): #60 frame lengths
		#freq is what fFinal was/is..
		for k in xrange(samplesPerFrame):
		#calc freq needed, ratio:1 of the way from f[i] to f[j] Hz
			#ratio=float(k)/float(samplesPerFrame)
 			angle+=freq*revsPerSample
 			if angle>2*PI:
 				angle-=2*PI
 			flev=multiplier*sin(angle)
			s[count]+=flev
			count+=1
		
	
cpdef OK():
	cdef int i,j,k,col,loops,tally=0
	cdef float t, paraminc=1/float(STEPS)
	cdef np.ndarray[np.uint8_t, ndim = 3] img
	cdef pt P01[STEPS],P12[STEPS],P23[STEPS], P34[STEPS], pp
	cdef pt P012[STEPS],P123[STEPS], P234[STEPS]
	cdef pt P0123[STEPS],P1234[STEPS],B[STEPS]
	cdef int extraSeconds=2
	for i in xrange(TOTALSAMPLES):
		s[i]=0
	wavef = wave.open("bezier4ticwaudio-1.wav",'w')
	wavef.setnchannels(1) #1=mono. 2=stereo
	wavef.setsampwidth(2) 
	wavef.setframerate(SAMPLERATE)#sampleRate)
	ChoosePts()

	for loops in xrange(STEPS):#+extraSeconds*30):
		for i in xrange(WID):
			for j in xrange(HEI):
				for col in xrange(3):
					cimg[i][j][col]=0
		img = np.zeros([HEI,WID,3],dtype=np.uint8)
		t=float(loops)/float(STEPS)
		for i in xrange(MAXPTS-1):
			Plot(P[i],P[i+1],white)
		P01[loops]=deCast(t,P[0],P[1])
		P12[loops]=deCast(t,P[1],P[2])
		P23[loops]=deCast(t,P[2],P[3])
		P34[loops]=deCast(t,P[3],P[4])
		
		P012[loops]=deCast(t,P01[loops],P12[loops])
		P123[loops]=deCast(t,P12[loops],P23[loops])
		P234[loops]=deCast(t,P23[loops],P34[loops])

		P0123[loops]=deCast(t,P012[loops],P123[loops])
		P1234[loops]=deCast(t,P123[loops],P234[loops])

		B[loops]=deCast(t,P0123[loops],P1234[loops])
		Plot(P01[loops],P12[loops],red)
		Plot(P12[loops],P23[loops],green)
		Plot(P23[loops],P34[loops],blue)
		Plot(P012[loops],P123[loops],rg)
		Plot(P123[loops],P234[loops],gb)
		Plot(P0123[loops],P1234[loops],white)
		#bottom-level line ends
		for i in xrange(-2,3):
			for j in xrange(-2,3):
				fSet([P01[loops].x+i,P01[loops].y+j],red)
				fSet([P12[loops].x+i,P12[loops].y+j],green)
				fSet([P23[loops].x+i,P23[loops].y+j],green)
				fSet([P34[loops].x+i,P34[loops].y+j],blue)

		#draw all the curve points
		for k in xrange(loops):
			for i in xrange(0,2):
				for j in xrange(0,2):
					fSet([P012[k].x+i,P012[k].y+j],red)
					fSet([P123[k].x+i,P123[k].y+j],green)
					fSet([P234[k].x+i,P234[k].y+j],blue)
		for k in xrange(loops):
			for i in xrange(-1,3):
				for j in xrange(-1,3):
					fSet([P0123[k].x+i,P0123[k].y+j],rg)
					fSet([P1234[k].x+i,P1234[k].y+j],gb)
		for k in xrange(loops):
			for i in xrange(-2,4):
				for j in xrange(-2,4):
					fSet([B[k].x+i,B[k].y+j],white)
		#current bigger
		for i in xrange(-3,4):
			for j in xrange(-3,4):
				fSet([P012[loops].x+i,P012[loops].y+j],red)
				fSet([P123[loops].x+i,P123[loops].y+j],green)
				fSet([P234[loops].x+i,P234[loops].y+j],blue)
				fSet([P0123[loops].x+i,P0123[loops].y+j],rg)
				fSet([P1234[loops].x+i,P1234[loops].y+j],gb)
				fSet([B[loops].x+i,B[loops].y+j],white)
		for i in xrange(WID):
			for j in xrange(HEI):
				for col in xrange(3):
					img[j,i,col]=cimg[i][j][col]
		print loops
		fn="/Users/admin/bezier/bezier-%05d.png" % loops			
		misc.imsave(fn,img)
		tally+=1
	for i in xrange(60):
		fn="/Users/admin/bezier/bezier-%05d.png" % tally			
		misc.imsave(fn,img)
		tally+=1

	print "calculating audio"
	#array, pitchMultiplier, volMultiplier
	AddWave(B,2,10) #which adds on wave to s array...
	AddWave(P0123,1,3) 
	AddWave(P1234,1,3) 
	AddWave(P012,0.5,3) 
	AddWave(P123,0.5,3) 
	AddWave(P234,0.5,3) 
# 	AddWave(P01,4,0.5) 
# 	AddWave(P12,4,0.5) 
# 	AddWave(P23,4,0.5) 
# 	AddWave(P34,4,0.5) 
	print "writing file"
	cdef float min=100000,max=-100000
	for i in xrange(TOTALSAMPLES):
		if s[i]<min:
			min=s[i]
		if s[i]>max:
			max=s[i]
		wavef.writeframesraw(struct.pack('<h',s[i])) #'<h' means 'little endian short
	print "min:",min
	print "max:",max
	wavef.writeframes('')
	wavef.close()
