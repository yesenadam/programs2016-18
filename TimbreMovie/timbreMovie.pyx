#I think level is too high on latest ones.. (although not a problem before.. ) maybe change to 2.5 max vol or something?
# The more overtones the better! (or maybe this is the problem?) but turn down the max value of the higher ones.... maybe they can be max 3/(j+1) ie 1st = max one (fund), ov 16 = max 3/17.... hmm maybe. something like that
#================================== 
#timbreMovie.pyx This version has simpler looping. One main loop + other 'count' variables
#This version starts with just fundamental, then updates overtone levels randomly..
#Use this to make movie with sound:
#ffmpeg -i /Downloads-1/timbre-1.wav -f image2 -r 25 -i /Downloads-1/gif/00%d.png -vcodec h264 -crf 0 timbreMovie.mp4
import wave, struct
from sage.misc.functional import show
from sage.plot.polygon import polygon2d
from sage.functions.trig import sin
from sage.misc.prandom import random
#NB not sure why, but freq is twice as high as it should be.
#so sin is *pi not *2*pi to compensate <-- um i think its fixed now. change back.
DEF interps=240#480#8#30#3#5#60#3#10 #NB CHANGE THIS (see below) when number of ov[] arrays changes
DEF volMult=10000.0 #volume multiplier. must be -32767 < < 32767
DEF maxSum=3 # i.e. 3x10000=30,000 ... over +-32767 produces error.
DEF pi=3.1415926535
DEF sampleRate = 44100.0 # Hertz
DEF secsPerInterp=1.0
DEF f =  220.5# um to compensate for changing j to j+1??441.0 # Hz = A plus a bit
DEF noo=16#12 #number of overtones to use
DEF wid=2 #plot width of overtones bar chart
DEF mult=f*pi/sampleRate # unit = vibrations per sample x pi = pi/1000ish
DEF snapLength=4*441 #take a snapshot every this-long. This makes 25 frames/sec...but change this into words so it's flexible.
DEF numFrames=int((sampleRate*interps*secsPerInterp)/snapLength)
cdef int samPerInterp = int(sampleRate*secsPerInterp)
cdef float fspi=samPerInterp #maybe this not needed now things are changed to floats.....
cpdef OK(): #NB call this function to run program
	wavef = wave.open("/Downloads-1/timbre-1.wav",'w')
	wavef.setnchannels(1) #1=mono. 2=stereo
	wavef.setsampwidth(2) 
	wavef.setframerate(sampleRate)
	cdef:
		int wh, u, t, i,j, k, h, m, count=0 #number of sets of values to plot later
		float ii, ovSum, fund, levs[noo], ov[2][noo], maxheight=0, col[noo][3]
		float Pic[noo], flev
	#One of these for each harmonic: (=noo)
	col[0][:]=[0,0.7,0] #A - grn
	col[1][:]=[0,1,0] #A - lighter grn
	col[2][:]=[0.3,0.3,1] #E
	col[3][:]=[0.4,1,0.4] #A
	col[4][:]=[1,1,0] #C# - yellow.. sunlight
	col[5][:]=[0.5,0.5,1] #E
	col[6][:]=[1,0.3,0.3] #G
	col[7][:]=[0.6,1,0.6] #A
	col[8][:]=[1,0.6,0.6] #B
	col[9][:]=[1,1,0.4] #C#
	col[10][:]=[1,0.7,1]
	col[11][:]=[0.7,0.7,1] #E
	col[12][:]=[1,0.8,1] #
	col[13][:]=[1,0.7,0.7] #G
	col[14][:]=[1,0.9,1] #
	col[15][:]=[0.8,1,0.8] #A
	ov[0][:]=[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0] #the first frames interpolate between these two overtone-level sets.
	ov[1][:]=[0.5,0.4,0.3,0.2,0.1,0,0,0,0,0,0,0,0,0,0,0]
	k=0;i=0;ii=0;t=0
	cpdef name='' #does that help?!
#t = total num of data points to write. = total secs x 44100 = interps x secPerInterp x 44100
#k = current interp. i.e. k=0 means currently interpolating between ov[0] to ov[1] array points..
#ii = num of data written for current interp so far. 0 - samPerInterp (currently 44100)
	print "Interp ",k #first one
	while t<interps*samPerInterp: 
		if t%snapLength==0: #take a snapshot for the video every 1/25 sec #every 1764 loops
			ovSum=0
			for h in range(noo): #interpolate
				levs[h]=(ov[0][h]*(fspi-ii)+ov[1][h]*ii)/fspi
				ovSum+=levs[h] #cumulative height
				Pic[h]=ovSum
	#make image.
			print "Pic no",count
			for m in range(noo):
				print "[0] ",ov[0][m]," [1] ",ov[1][m]," curr ",levs[m]
			print "Total: ",ovSum
			g=polygon2d([[0,0],[wid,0],[wid,Pic[0]],[0,Pic[0]]],rgbcolor=(col[0][0],col[0][1],col[0][2]))
			for m in range(noo-1): 
				g+=polygon2d([[0,Pic[m]],[wid,Pic[m]],[wid,Pic[m+1]],[0,Pic[m+1]]],rgbcolor=(col[m+1][0],col[m+1][1],col[m+1][2]))	
			name='/Downloads-1/gif/00{}.png'.format(count)
			g.save(name,axes=False,xmin=0,xmax=wid,ymax=maxSum,ymin=0,aspect_ratio=1,figsize=[10,10])
			count+=1
	#write audio to wave file
		#levlist=[]
		#for u in range(snapLength): #1764
		flev=0
		for j in range(noo): 
			flev+=levs[j]*volMult*sin(mult*float((j+1)*t)) #<-- aha! not j but j+1.. of course.
		#levlist.append(flev)
		t+=1
		ii+=1#=snapLength #what is fastest way of writing this?! writing 1764 at a time seems no faster
		wavef.writeframesraw(struct.pack('<h',flev))#*len(levlist),*levlist))
# or use *len(levlist),*levlist)) and might need '<h' - '<h' means 'little endian short (-formatted string char)'
		if t%samPerInterp==0: #inc k every interp, reset i #every 44100 loops
			k+=1
			#make new interp here. first transfer old [1] to [0].
			ovSum=0
			wh=int(random()*noo) #i.e. 0 - (noo-1)
			for j in range(noo): 
				ov[0][j]=ov[1][j] #old=new
				if j==wh:
					ov[1][j]=0 #randomly reduce one of them to 0.
				else:
					ov[1][j]=ov[0][j]+(random()-0.4) #or some randomizing function
				if ov[1][j]<0:
					ov[1][j]=-ov[1][j]
				ovSum+=ov[1][j]
			while ovSum>maxSum: #reduce all except fundamental if too high (>3)
				#ov[1][0]=ov[1][0]*0.95 #decrease the fundamental less than others
				for j in range(noo):
					ov[1][j]=ov[1][j]*(1-float(j+5)/100)#0.9 #ie highest dec more
				ovSum=0
				for j in range(noo):
					ovSum+=ov[1][j]
			ii=0
			print "Interp ",k
	wavef.writeframes('')
	wavef.close()
	print "t=",t," Frames=",count	