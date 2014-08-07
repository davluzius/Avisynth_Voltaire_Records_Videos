

LoadPlugin("plugins/MinMaxAudio.dll")
LoadPlugin("plugins/GScript.dll")




global WIDTH = 640
global HEIGHT = 320


clipMoodWhisp = DirectShowSource("clips/cloud_clips_converted/mood_tapes.avi",24).BilinearResize(WIDTH, HEIGHT).ConvertToRGB32().Trim(5904,6744).KillAudio()
 


clipMoodClouds = DirectShowSource("clips/cloud_clips_converted/mood_tapes.avi",24).BilinearResize(WIDTH, HEIGHT).ConvertToRGB32().Trim(300,940).KillAudio()

clipMoodSun = DirectShowSource("clips/cloud_clips_converted/mood_tapes.avi",24).BilinearResize(WIDTH, HEIGHT).ConvertToRGB32().Trim(1944,2044).KillAudio()

clipSpace = DirectShowSource("clips/cloud_clips_converted/Northwest_coast_of_United_States_to_Central_South_America_at_Night.avi",24).Tweak(0,0,-200,9).BilinearResize(WIDTH, 540).ConvertToRGB32().Trim(400,4776).KillAudio().FlipVertical().Crop(0,0,WIDTH,HEIGHT).Invert().Loop()
 
clipTigers = DirectShowSource("clips/animals/tigers.avi").Tweak(0,5,0,.6).BilinearResize(WIDTH, HEIGHT).ConvertToRGB32().Trim(440,540).KillAudio().ConvertFPS(572).FlipHorizontal()
 
 
  clipDarkBird = DirectShowSource("clips/animals/darkBird.avi").BilinearResize(WIDTH, HEIGHT).ConvertToRGB32().Trim(0,890).KillAudio().ConvertFPS(172)
  
   clipParrot = DirectShowSource("clips/animals/parrot.avi",24).Tweak(0,5,-100,.6).BilinearResize(WIDTH, HEIGHT).ConvertToRGB32().Trim(3000,3840).KillAudio().Invert()
  
clipCloud = DirectShowSource("clips/cloud_clips_converted/Cloud_time_lapse_1280.avi").BilinearResize(WIDTH, HEIGHT).ConvertToRGB32().Trim(0,2886).KillAudio().Loop().Invert()

clipTime = DirectShowSource("clips/cloud_clips_converted/Hdr_time_lapse_montage.avi").BilinearResize(WIDTH, HEIGHT).ConvertToRGB32().Trim(100,840).KillAudio().Invert().Loop()


clipSunset = DirectShowSource("clips/cloud_clips_converted/Sunset_Time_Lapse_31-12-2009.avi").Tweak(0,3).BilinearResize(WIDTH, HEIGHT).ConvertToRGB32().KillAudio().Trim(0,840)

clipSunset2 = DirectShowSource("clips/cloud_clips_converted/Sunset_Time_Lapse_31-12-2009.avi").Tweak(0,3).BilinearResize(WIDTH, HEIGHT).ConvertToRGB32().KillAudio().Trim(0,840).FlipVertical()
 

# ---- bg sequence

 

cloudsOverlay = Overlay( clipSunset2.Loop(), clipCloud.FadeIn(300), mode="multiply", opacity=.8).Trim(0,1010)
 
clipDarkBird = Overlay( clipDarkBird , clipSunset2.Loop() , mode = "softlight" , opacity = 1).Trim(0,840)
 
spaceOverlay = Overlay(  clipSunset2.Loop() ,clipSpace.Trim(0,1140).FadeIn(400) , mode = "luma" , opacity = 1).Trim(0,640)
 
cloudTimeElapseLoop =     Dissolve(clipMoodClouds.Trim(0,260),clipMoodClouds.Trim(0,260),clipMoodClouds.Trim(0,260),clipMoodClouds.Trim(0,260) ,clipMoodClouds.Trim(0,260),clipMoodClouds.Trim(0,260),80 ).Trim(0,1140)
 
 
 
 colorBars = ColorBars().BilinearResize(WIDTH, HEIGHT).ConvertToRGB32().Trim(0,840).KillAudio().FlipVertical()

 
 
bgSequence = Dissolve(  clipMoodClouds,clipSunset,clipMoodWhisp,cloudsOverlay, clipSunset.Loop().Trim(0,1340),spaceOverlay,clipSunset2.Loop().Trim(0,940),clipTigers,clipSunset2,clipDarkBird,clipSunset2,clipSunset,clipSunset2, cloudTimeElapseLoop  ,clipSunset,clipSunset2,clipSunset,clipSunset2,clipSunset,300)


# ---- foreground sequence

clipBeach = DirectShowSource("clips/cloud_clips_converted/Maldives_beach.avi").BilinearResize(WIDTH, HEIGHT).ConvertToRGB32().Loop().KillAudio()

clipRopeway = DirectShowSource("clips/cloud_clips_converted/Miyajima_ropeway.avi").Tweak(0,1,0,1.7).BilinearResize(WIDTH, HEIGHT).ConvertToRGB32()
clipRopeway = clipRopeway.Trim(100,1040).FlipHorizontal().Reverse()

clipRopeway2 = DirectShowSource("clips/cloud_clips_converted/Miyajima_ropeway.avi").Tweak(0,1,0,1.7).BilinearResize(WIDTH, HEIGHT).ConvertToRGB32()
clipRopeway2 = clipRopeway2.Trim(100,1040)

ropeway  = Dissolve(clipRopeway2,clipRopeway,clipRopeway2,clipRopeway,clipRopeway2,clipRopeway,clipRopeway2,clipRopeway,clipRopeway2,clipRopeway,clipRopeway2,clipRopeway,60,$ffffff)
 


 
 
 blankClip = BlankClip(8000).BilinearResize(WIDTH, HEIGHT).ConvertToRGB32()
 
audio1 = WAVSource("audio/Heaven_Hatchback.wav")

 
 

 

function multiplyClips(clip _a,clip _b)
{
	return Overlay(_a, _b, mode="subtract", opacity=.3)
}
 


 






 
 mainOut = Overlay(ropeway, bgSequence, mode="darken", opacity=1)
 
 

 mainOut = Overlay( mainOut, clipBeach, mode="darken", opacity=1)
 

 
 
 
 mainOut = audioDub( mainOut , audio1 ).Trim(0,10400).FadeIn(128,$000000).FadeOut(1200,$FF4500)

return mainOut

