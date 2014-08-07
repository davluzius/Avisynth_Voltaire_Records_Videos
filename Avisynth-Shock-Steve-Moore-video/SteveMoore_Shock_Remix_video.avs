

LoadPlugin("plugins/MinMaxAudio.dll")
LoadPlugin("plugins/GScript.dll")

global WIDTH = 640
global HEIGHT = 320

clip4 = DirectShowSource("clips/cloud_clips_converted/Fly-through_movie_showing_southern_Kermadec_Arc_bathymetry.avi")
clip4 = clip4.BilinearResize(WIDTH, HEIGHT).ConvertToRGB32()
clip4 = clip4.Loop()
clip5 = DirectShowSource("clips/cloud_clips_converted/Tour_of_the_Galapagos.avi").Tweak(0,6,-100,2)
clip5 = clip5.BilinearResize(WIDTH, HEIGHT).ConvertToRGB32().Loop()

circleMask = ImageSource("images/circle.bmp").BilinearResize(WIDTH, HEIGHT).Blur(1.0).Loop()

audio1 = WAVSource("audio/Heaven_Steve_Moore.wav")
audioClickTrack = WAVSource("audio/Heaven_Steve_Moore_Click.wav")
 
 
flipClip = BlankClip(3600,WIDTH,HEIGHT,"RGB32").Loop()
flipClip = audioDub( flipClip , audioClickTrack )
flipClip  = flipClip.ScriptClip(" A = AudioRMS(0) A<-88 ? clip5 :  multiplyClips(clip5,clip4)")
 

function multiplyClips(clip _a,clip _b)
{
	return Overlay(_a, _b, mode="subtract", opacity=.3)
}
 


 


GScript("""
  function splitLines(clip src,clip B) 
  {
		out = src.Crop(0,1,src.width,2) 
		line = out
        for (i=1, src.height-1, 3) 
		{
			if(i%8==0)
			{
				line=src.Crop(0,i,src.width,4)
			}
			else
			{
				line=B.Crop(0,src.height-i,src.width,1)
				#line = Overlay(line, B, mode="subtract", opacity=.34)
			}
            
            out=StackVertical(out,line)
        }
	return out
  } 
""") 




 
mainOut = splitLines( clip5,flipClip ).BilinearResize(WIDTH, HEIGHT)
 

 mainOut = audioDub( mainOut , audio1 ).Trim(0,8000)

return mainOut

