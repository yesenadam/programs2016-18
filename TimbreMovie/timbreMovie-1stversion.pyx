#timbre3.pyx This version has simpler looping. One main loop + other 'count' variables
#Use this to make movie with sound:
#ffmpeg -i /Downloads-1/timbre-1.wav -f image2 -r 25 -i /Downloads-1/gif/00%d.png -vcodec h264 -crf 0 timbre2.mp4
import wave, struct
from sage.misc.functional import show
from sage.plot.polygon import polygon2d
from sage.plot.graphics import Graphics
#from sage.plot.line import line
from sage.functions.trig import cos
from sage.functions.other import floor
#NB not sure why, but freq is twice as high as it should be.
#so cos is *pi not *2*pi to compensate <-- um i think its fixed now. change back.
DEF interps=10 #NB CHANGE THIS (see below) when number of ov[] arrays changes
DEF maxLev=10000.0 #loudest level allowed of any harmonic. actual max allowed=+-32767
DEF pi=3.1415926535
DEF sampleRate = 44100.0 # Hertz
DEF secsPerInterp=1.0
DEF f =  440.0 # Hz = A
DEF noo=10 #number of overtones to use
DEF mult=f*pi/sampleRate # unit = vibrations per sample x pi = pi/1000ish
DEF snapLength=4*440 #take a snapshot every this-long. This makes 25 frames/sec...but change this into words so it's flexible.
DEF numFrames=int((sampleRate*interps*secsPerInterp)/snapLength)
cdef int samPerInterp = floor(sampleRate*secsPerInterp)
cdef float fspi=samPerInterp #maybe this not needed now things are changed to floats.....
cpdef OK(): #NB call this function to run program
	wavef = wave.open("/Downloads-1/timbre-1.wav",'w')
	wavef.setnchannels(1) #1=mono. 2=stereo
	wavef.setsampwidth(2) 
	wavef.setframerate(sampleRate)
	cdef:
		int t, i,j, k, h, count=0 #number of sets of values to plot later
		float ii, ovSum, fund, currOv[noo], ov[interps+1][noo], maxheight=0, col[noo][3]
		float Pic[numFrames+1][noo]
	#One of these for each harmonic: (=noo)
	col[0][:]=[0,0.7,0] #A - grn
	col[1][:]=[0,1,0] #A - lighter grn
	col[2][:]=[0,0,1] #E
	col[3][:]=[0.4,1,0.4] #A
	col[4][:]=[1,1,0] #C# - yellow.. sunlight
	col[5][:]=[0.2,0.2,1] #E
	col[6][:]=[1,0,0] #G
	col[7][:]=[0.6,1,0.6] #A
	col[8][:]=[0.8,1,0.4] #B
	col[9][:]=[1,1,0.2] #C#
#	col[10][:]=[0.6,0.6,0.6] #D
	#One of these for each interpolation: (=interps)
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
#NB set "DEF interps=" at top to the val of ov[val][:] in the previous line
	k=0;i=0;ii=0;t=0
#t = total num of data points to write. = total secs x 44100 = interps x secPerInterp x 44100
#k = current interp. i.e. k=0 means currently interpolating between ov[0] to ov[1] array points..
#ii = num of data written for current interp so far. 0 - samPerInterp (currently 44100)
#======= write to sound file ===========
	print "Interp ",k #first one
	while t<interps*samPerInterp: #next line was t%1000. i think %440 will be right for pics of wave?!
		if t%snapLength==0: #take a snapshot for the picture every 1000 pts. =1/44th sec. but change to capture stat. wav.
			ovSum=0
			for h in range(noo): #these maybe dont need to be computed EVERY 1/44100 sec..	#i think every 1/44th sec is plenty.
				currOv[h]=(ov[k][h]*(fspi-ii)+ov[k+1][h]*ii)/fspi
				ovSum+=currOv[h] #cumulative height
				Pic[count][h]=ovSum
			if ovSum>maxheight: #store max height for movie later
				maxheight=ovSum
			print floor(ii/snapLength)
			count+=1
		lev=0
		for j in range(noo): 
			lev+=currOv[j]*maxLev*cos(mult*float(j*t))
		wavef.writeframesraw(struct.pack('<h',lev))
		ii+=1
		t+=1
		if t%samPerInterp==0: #inc k every interp, reset i
			k+=1
			ii=0
			print "Interp ",k
	wavef.writeframes('')
	wavef.close()
#========== make frames for movie ===============
	cdef int wid=2
	cpdef name='' #does that help?!
	for i in range(count):
		print "Pic no",i
		for k in range(9):
			print Pic[i][k]," col= ",col[k][0],col[k][1],col[k][2]
		g=polygon2d([[0,0],[wid,0],[wid,Pic[i][0]],[0,Pic[i][0]]],rgbcolor=(col[0][0],col[0][1],col[0][2]))
		for j in range(noo-1): 
			g+=polygon2d([[0,Pic[i][j]],[wid,Pic[i][j]],[wid,Pic[i][j+1]],[0,Pic[i][j+1]]],rgbcolor=(col[j+1][0],col[j+1][1],col[j+1][2]))#,fill=True)	
		name='/Downloads-1/gif/00{}.png'.format(i)
		g.save(name,axes=False,xmin=0,xmax=wid,ymax=maxheight,ymin=0,aspect_ratio=1,figsize=[16,16])
	print "t=",t," Frames=",count	