#timbre3.pyx This version has simpler looping. One main loop + other 'count' variables
import wave, struct
from sage.misc.functional import show
from sage.plot.graphics import Graphics
from sage.plot.line import line
from sage.functions.trig import cos
from sage.functions.other import floor
#NB not sure why, but freq is twice as high as it should be.
#so cos is *pi not *2*pi to compensate
DEF interps=10 #NB CHANGE THIS (see below) when number of ov[] arrays changes
DEF maxLev=10000.0 #loudest level of any harmonic. actual max allowed=+-32767
DEF pi=3.1415926535
DEF sampleRate = 44100.0 # hertz
DEF secsPerInterp=1.0
DEF f =  440.0 #A.. C clicked.261.6255653  # middle C
DEF noo=10 #number of overtones to use
DEF mult=f*pi/sampleRate
cdef int samPerInterp = floor(sampleRate*secsPerInterp)
cdef float fspi=samPerInterp #maybe this not needed now things are changed to floats.....
cpdef OK(): #NB call this function to run program
	wavef = wave.open("/Downloads-1/timbre-1.wav",'w')
	wavef.setnchannels(1) #1=mono. 2=stereo
	wavef.setsampwidth(2) 
	wavef.setframerate(sampleRate)
	cdef:
		int t, i,j, k, h, count=0 #number of sets of values to plot later
		float ii, ovSum, fund, currOv[noo], ov[interps+1][noo]
		float Pic[interps*46][noo] #um this is a guess
	ov[0][:]=[1,0,0,0,0,0,0,0,0,0]
	ov[1][:]=[1,0.5,0.333,0.25,0.2,0.166,0.142,0.125,0.111,0.1]
	ov[2][:]=[0.7,0,0.6,0,0.5,0,0.4,0,0.3,0]
	ov[3][:]=[0,0.5,0.333,0.25,0.2,0.166,0.142,0.125,0.1,0.1]
	ov[4][:]=[0,0.5,0.333,0.25,0.2,0.166,0.142,0.125,0.1,0.1]
	ov[5][:]=[0.7,0.7,0,0.7,0,0,0,0.7,0,0]
	ov[6][:]=[0.8,0.142,0.166,0.4,0.35,0.533,0.3,0.0,0,0.2]
	ov[7][:]=[0.6,0.542,0.166,0,0.25,0.433,0,0.4,0,0.2]
	ov[8][:]=[0.2,0,0.266,0.1,0.75,0.233,0.3,0,0.3,0.2]
	ov[9][:]=[1,0.5,0.333,0.25,0.2,0.166,0.142,0.125,0.111,0.1]
	ov[10][:]=[0.8,0.8,0,0,0,0,0,0,0.2,0.2]
#NB set DEF interps above to the highest val of ov[val][:] in the above line
#NB change it so "i" is the outside loop, so that the waves stay smooth. otherwise it may just cut off at start/end of interpolations. or maybe inaudible....
	k=0;i=0;ii=0;t=0
	#t = total num of data points to write. = total secs x 44100 = interps x secPerInterp x 44100
	#k = current interp. i.e. k=0 means currently interpolating between ov[0] to ov[1] array points..
	#ii = num of data written for current interp so far. 0 - samPerInterp (currently 44100)
	print "Interp ",k #first one
	while t<interps*samPerInterp:
		if t%1000==0: #take a snapshot for the picture every 1000 pts. =1/44th sec. but change to capture stat. wav.
			ovSum=0
			for h in range(noo): #these maybe dont need to be computed EVERY 1/44100 sec..
				#i think every 1/44th sec is plenty.
				currOv[h]=(ov[k][h]*(fspi-ii)+ov[k+1][h]*ii)/fspi
				ovSum+=currOv[h] #cumulative height
				Pic[count][h]=ovSum
			print floor(ii/1000)
			count+=1 #now is just every 1000, 'count' not needed.. but make it a multiple of wavelength
				# so picture is easier to make.
		lev=0
		for j in range(noo): 
			lev+=currOv[j]*maxLev*cos(mult*float(j*t))
		wavef.writeframesraw(struct.pack('<h',lev))
#		wavef.writeframesraw(struct.pack('<h',lev)) #to double length (and wavelength!)
		ii+=1
		t+=1
		if t%samPerInterp==0: #inc k every interp, reset i
			k+=1
			ii=0
			print "Interp ",k
	wavef.writeframes('')
	wavef.close()
	g=Graphics()
	for i in range(noo): #fundamental is ov[][0]
		g+=line([[j,Pic[j][i]] for j in range(count)])
	show(g)
	print "t=",t," Frames=",count	
#hmm or just draw triangles (filled-in) with the vertices at the data points..
#dont need so many points!! unless do non-linear interpolation later or something....