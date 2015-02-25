

LoadPlugin("plugins/MinMaxAudio.dll")
LoadPlugin("plugins/GScript.dll")

global WIDTH = 640
global HEIGHT = 360

clip1 = DirectShowSource("clips/inferno.avi",6).Trim(390,600).Loop().BilinearResize(WIDTH, HEIGHT).ConvertToRGB32().Loop()
clip2 = DirectShowSource("clips/4D_witch3.avi",8).Loop().Invert().BilinearResize(WIDTH, HEIGHT).ConvertToRGB32().Loop()
clip3 = DirectShowSource("clips/4D_witch1.avi",8).Loop().BilinearResize(WIDTH, HEIGHT).ConvertToRGB32().Loop()
clip4 = DirectShowSource("clips/Alice_3.avi",8).Loop().Tweak(0,0,10,10).BilinearResize(WIDTH, HEIGHT).ConvertToRGB32().Loop()

audio1 = WAVSource("audio/Heaven_Chautaqua_remix.wav")
audio2 = WAVSource("audio/Heaven_wahSound.wav")
audioClap = WAVSource("audio/Heaven_clap.wav")

audioMix = MixAudio(audio1, audio2, 0.75, 0.5)





combinedClip = audioDub( clip2 , audio2 )
mainOut  = combinedClip.ScriptClip(" A = AudioRMS(0) A<-26 ? clip1 :  multiplyClips(clip1,clip2)")

combinedClip2 = audioDub( clip2 , audioClap )
mainOut2  = combinedClip2.ScriptClip(" A = AudioRMS(0) A<-88 ? clip1 :  multiplyClips2(clip1,clip4)")

#mainOut2  = clip3.ScriptClip(" current_frame>1600 ? clip3 :  clip1")

function multiplyClips(clip _a,clip _b)
{
	return Overlay(_a, _b, mode="subtract", opacity=.3)
}

function multiplyClips2(clip _a,clip _b)
{
	return Overlay(_b, _a, mode="Difference", opacity=.7)
}

mainOut = Overlay(mainOut,mainOut2, mode="add", opacity=.4)
mainOut = audioDub( mainOut , audioMix )
 
mainOut = mainOut.Trim(0,2100)
return mainOut
