#bezieraudio.pyx

#this version works with bezier4tic.pyx

#so... with 5 points... I guess automate what pitches etc..
#so have f[5].... f[0] and f[4] are endpoints... each combination of 2 is used, no?
#my first idea is - make pitch an octave lower for each extra point spanned..
#so actual bezier is the lowest pitch.. try that anyway.
#and have points .y corresspond to piano notes, maybe white notes?
#more chance of it sounding ok.
#(maybe: do this with .x also - but then each point will have 2 freqs, might sound ok or not.
#but I dont like ignoring the .x value of points.
DEF SAMPLERATE=44100.0 #Hz
DEF FRAMES=500 #in 1 bezier scene
DEF FPS=30 #frames per sec in animation
DEF TOTALSAMPLES=735000 #SAMPLERATE*(FRAMES/FPS)
DEF NUMPTS=5
DEF PI=3.14159265358979
from libc.math cimport round, sin,pow #is in range -pi/2 -> pi/2
import wave, struct
cdef:
	float pitches[5],f[5] #frequencies of notes in Hz
	float wl[5] #wavelengths of those notes in samples
	float buckets[1300]
	#each stores the number of waves of that length to draw
	float fTotalSamples=float(TOTALSAMPLES)
# P[0]=[400,620]
# P[1]=[50,130]
# P[2]=[600,50]
# P[3]=[880,670]
# P[4]=[1230,120]
pitches[:]=[10,3,0,12,2] #0=root,12-8ve.
#f[:]=[620,130,50,670,120]
cdef int rnd(float f) nogil:
	return int(round(f))
	
cpdef OK():
	cdef:
		float wsum=0 #for testing
		int i, j,k,w0,w1#initial & final wavelength
		float flev #-32767 -> 32767, audio data sample
#		int numOfWaveSizes #number of different wavelengths needed
#		float freqSectionLength #needed length in samples of each exact frequency pitch
		float s[TOTALSAMPLES+10] #avoid overstepping
		float multiplier=1000.0 #for 10 waves, can be 3200?
		float angle=0.0
		float freq
		float ratio
		float revsPerSample=2*PI/SAMPLERATE
	#convert pitches to freqs.
	for i in xrange(NUMPTS):
		f[i]=220.0*pow(2.0,(pitches[i]/12.0))
		print pitches[i],f[i]
	wavef = wave.open("bezier4tic-1.wav",'w')
	wavef.setnchannels(1) #1=mono. 2=stereo
	wavef.setsampwidth(2) 
	wavef.setframerate(SAMPLERATE)#sampleRate)
	#loop over init point
#		loop over final point
#			loop over all samples
	for i in xrange(TOTALSAMPLES):
		s[i]=0
	for i in xrange(NUMPTS):
		for j in xrange(i+1,NUMPTS):
			print i,j
			for k in xrange(TOTALSAMPLES):
				#calc freq needed, ratio:1 of the way from f[i] to f[j] Hz
				ratio=float(k)/float(TOTALSAMPLES)
				freq=ratio*f[i]+(1-ratio)*f[j]
				angle+=freq*revsPerSample
				if angle>2*PI:
					angle-=2*PI
				flev=multiplier*sin(angle)
				s[k]+=flev
# 				if s[k]>32767:
# 					print "HIGH"
# 				if s[k]<-32767:
# 					print "LOW"
	print "writing file"
	for i in xrange(TOTALSAMPLES):
#		print i,s[i]
		wavef.writeframesraw(struct.pack('<h',s[i])) #'<h' means 'little endian short
	
	wavef.writeframes('')
	wavef.close()
