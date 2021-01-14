import wave, struct
from sage.misc.functional import show
from sage.plot.graphics import Graphics
from sage.plot.line import line
from sage.functions.trig import cos
from sage.functions.other import floor
#NB not sure why, but freq is twice as high as it should be.
#so cos is *pi not *2*pi to compensate
DEF interps=10 #NB CHANGE THIS (see below) when number of ov[] arrays changes
DEF toplevel=10000.0 #loudest level of any harmonic. actual max allowed=+-32767
DEF pi=3.1415926535
DEF sampleRate = 44100 # hertz
DEF secsPerInterp=1.0
DEF lFreq =  440 #A.. C clicked.261.6255653  # middle C
DEF numOfOvertones=10
cdef:	
	int samPerInterp=44100 #change this!! floor(sampleRate*secsPerInterp) #samples per interpolation
	float fspi=float(samPerInterp)
cpdef OK():
	wavef = wave.open("/Downloads-1/timbre-1.wav",'w')
	wavef.setnchannels(1) #1=mono. 2=stereo
	wavef.setsampwidth(2) 
	wavef.setframerate(sampleRate)
	cdef:
		int i,j, k, h, count=0 #number of sets of values to plot later
		float fi, osum, fund, currov[numOfOvertones], ov[interps+1][numOfOvertones]
		float picov[interps*47][numOfOvertones] #um this is a guess
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
	for k in range(interps):
		print "Interp ",k+1
		for i in range(samPerInterp): 
			fi=float(i)
			for h in range(numOfOvertones):
				currov[h]=(ov[k][h]*(fspi-fi)+ov[k+1][h]*fi)/fspi
			if (i%1000==0): 
				print i
				osum=0
				for j in range(numOfOvertones):
					osum+=currov[j] #cumulative height
					picov[count][j]=osum
#				print i, j, currov[0], currov[1], currov[2], currov[3], currov[4], currov[5], currov[6], currov[7]
				count+=1
			lev=0
			for j in range(numOfOvertones): 
				lev+=currov[j]*toplevel*cos(pi*float(j*lFreq*(i+k*samPerInterp))/float(sampleRate))
			wavef.writeframesraw(struct.pack('<h',lev))
			wavef.writeframesraw(struct.pack('<h',lev)) #to double length (and wavelength!)
	wavef.writeframes('')
	wavef.close()
	f=Graphics()
	for i in range(numOfOvertones): #fundamental is ov[][0]
		f+=line([[j,picov[j][i]] for j in range(count)])
	show(f)
	print "Frames=",count	
#hmm or just draw triangles (filled-in) with the vertices at the data points..
#dont need so many points!! unless do non-linear interpolation later or something....