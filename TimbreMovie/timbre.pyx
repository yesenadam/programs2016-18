import wave, struct
from sage.misc.functional import show
from sage.plot.graphics import Graphics
from sage.plot.line import line
from sage.functions.trig import cos
from sage.functions.other import floor
#NB not sure why, but freq is twice as high as it should be.
#so cos is *pi not *2*pi to compensate
DEF interps=10 #NB CHANGE THIS (see below) when number of ov[] arrays changes
DEF toplevel=10000 #loudest level of any harmonic. actual max allowed=+-32767
DEF pi=3.1415926535
DEF sampleRate = 44100 # hertz
DEF secsPerInterp=1.0
DEF lFreq =  441 #A.. C clicked.261.6255653  # middle C
cdef:	
	int spi=44100 #change this!! floor(sampleRate*secsPerInterp) #samples per interpolation
	float fspi=float(spi)
cpdef OK():
	wavef = wave.open("/Downloads-1/timbre-1.wav",'w')
	wavef.setnchannels(1) #1=mono. 2=stereo
	wavef.setsampwidth(2) 
	wavef.setframerate(sampleRate)
	cdef:
		int i,j, k, h, count=0 #number of sets of values to plot later
		float fi, osum, fund, currov[9], ov[interps+1][9], #ov[1]=fundamental
		float picov[interps*47][9] #um this is a guess
	ov[0][:]=[0,1,0,0,0,0,0,0,0]
	ov[1][:]=[0,1,0.5,0.333,0.25,0.2,0.166,0.142,0.125]
	ov[2][:]=[0,0.7,0,0.6,0,0.5,0,0.4,0]
	ov[3][:]=[0,0,0.5,0.333,0.25,0.2,0.166,0.142,0.125]
	ov[4][:]=[0,0,0.5,0.333,0.25,0.2,0.166,0.142,0.125]
	ov[5][:]=[0,0.7,0.7,0,0.7,0,0,0,0.7]
	ov[6][:]=[0,0.8,0.142,0.166,0.4,0.35,0.533,0.3,0.2]
	ov[7][:]=[0,0.6,0.542,0.166,0,0.25,0.433,0,0.4]
	ov[8][:]=[0,0.2,0,0.266,0.1,0.75,0.233,0.3,0]
	ov[9][:]=[0,1,0.5,0.333,0.25,0.2,0.166,0.142,0.125]
	ov[10][:]=[0,0.8,0.8,0,0,0,0,0,0]
#NB set DEF interps above to the highest val of ov[val][:] in the above line
#NB change it so "i" is the outside loop, so that the waves stay smooth. otherwise it may just cut off at start/end of interpolations. or maybe inaudible....
	for k in range(interps):
		print "Interp ",k+1
		for i in range(spi): 
			fi=float(i)
			for h in range(9):
				currov[h]=(ov[k][h]*(fspi-fi)+ov[k+1][h]*fi)/fspi
			if (i%1000==0): 
				print i
				j=1; osum=0
				while j<9:
					osum+=currov[j] #cumulative height
					picov[count][j]=osum
					j+=1
				count+=1
			j=1;lev=0
			while j<9:
				lev+=currov[j]*toplevel*cos(j*lFreq*pi*i/sampleRate)
				j+=1
				if lev>32000:
					print "DANGER!",lev,i,j,currov[1],currov[2],currov[3],currov[4],currov[5],currov[6],currov[7],currov[8],currov[9]
			wavef.writeframesraw(struct.pack('<h',lev))
	wavef.writeframes('')
	wavef.close()
	f=Graphics()
	i=1 #fundamental is ov[][1]
	while i<9:
		f+=line([[j,picov[j][i]] for j in range(count)])
		i+=1
	show(f)
	print "Frames=",count	
#hmm or just draw triangles (filled-in) with the vertices at the data points..
#dont need so many points!! unless do non-linear interpolation later or something....