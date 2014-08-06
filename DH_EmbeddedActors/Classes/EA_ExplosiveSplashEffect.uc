class EA_ExplosiveSplashEffect extends emitter;

defaultproperties
{
	Begin Object Class=SpriteEmitter Name=SpriteEmitter0
		UseDirectionAs=PTDU_Normal
		ProjectionNormal=(X=1.000000,Z=0.000000)
		FadeOut=True
		FadeIn=True
		RespawnDeadParticles=False
		SpinParticles=True
		DampRotation=True
		UseSizeScale=True
		UseRegularSizeScale=False
		AutomaticInitialSpawning=False
		BlendBetweenSubdivisions=True
		UseSubdivisionScale=True
		ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
		ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
		MaxParticles=1
		StartLocationOffset=(X=10.000000)
		UseRotationFrom=PTRS_Actor
		SpinCCWorCW=(X=0.000000,Y=0.000000,Z=0.000000)
		SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
		SizeScale(0)=(RelativeSize=1.000000)
		SizeScale(1)=(RelativeTime=0.500000,RelativeSize=2.500000)
		SizeScale(2)=(RelativeTime=1.000000,RelativeSize=6.000000)
		StartSizeRange=(X=(Min=35.000000,Max=45.000000),Y=(Min=35.000000,Max=45.000000),Z=(Min=35.000000,Max=45.000000))
		InitialParticlesPerSecond=100.000000
		DrawStyle=PTDS_Brighten
		Texture=Texture'Effects_Tex.BulletHits.waterring_2frame'
		TextureUSubdivisions=2
		TextureVSubdivisions=1
		SubdivisionScale(0)=0.500000
		LifetimeRange=(Min=1.000000,Max=1.500000)
	End Object
	Emitters(0)=SpriteEmitter'SpriteEmitter0'

	Begin Object Class=SpriteEmitter Name=SpriteEmitter1
		FadeOut=True
		FadeIn=True
		RespawnDeadParticles=False
		SpinParticles=True
		UseSizeScale=True
		UseRegularSizeScale=False
		UniformSize=True
		AutomaticInitialSpawning=False
		BlendBetweenSubdivisions=True
		UseRandomSubdivision=True
		UseVelocityScale=True
		Acceleration=(Z=-600.000000)
		ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
		ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
		FadeOutStartTime=0.500000
		MaxParticles=6
		UseRotationFrom=PTRS_Actor
		StartSpinRange=(X=(Min=0.500000,Max=0.500000))
		SizeScale(0)=(RelativeSize=1.000000)
		SizeScale(1)=(RelativeTime=1.000000,RelativeSize=5.000000)
		StartSizeRange=(X=(Min=12.000000,Max=12.000000),Y=(Min=8.000000,Max=10.000000),Z=(Min=8.000000,Max=10.000000))
		Sounds(0)=(Sound=SoundGroup'ProjectileSounds.cannon_rounds.AP_Impact_Water',Radius=(Min=256.000000,Max=312.000000),Pitch=(Min=1.000000,Max=1.400000),Volume=(Min=0.700000,Max=0.900000),Probability=(Min=1.000000,Max=1.000000))
		SpawningSound=PTSC_LinearLocal
		SpawningSoundProbability=(Min=1.0000,Max=1.0000)
		InitialParticlesPerSecond=500.000000
		DrawStyle=PTDS_AlphaBlend
		Texture=Texture'Effects_Tex.BulletHits.watersplashcloud'
		LifetimeRange=(Min=1.500000,Max=1.500000)
		StartVelocityRange=(X=(Min=450.000000,Max=700.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Min=-5.000000,Max=5.000000))
		VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
		VelocityScale(1)=(RelativeTime=0.200000,RelativeVelocity=(X=0.100000,Y=0.500000,Z=0.500000))
		VelocityScale(2)=(RelativeTime=1.000000,RelativeVelocity=(X=0.100000,Y=0.100000,Z=0.100000))
	End Object
	Emitters(1)=SpriteEmitter'SpriteEmitter1'

	Begin Object Class=SpriteEmitter Name=SpriteEmitter2
		FadeOut=True
		FadeIn=True
		RespawnDeadParticles=False
		UniformSize=True
		AutomaticInitialSpawning=False
		UseRandomSubdivision=True
		Acceleration=(Z=-500.000000)
		ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
		ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=100))
		Opacity=0.200000
		FadeOutStartTime=0.600000
		MaxParticles=16
		UseRotationFrom=PTRS_Actor
		StartSizeRange=(X=(Min=3.000000,Max=5.000000))
		InitialParticlesPerSecond=300.000000
		DrawStyle=PTDS_Brighten
		Texture=Texture'Effects_Tex.Smoke.Sparks'
		TextureUSubdivisions=2
		TextureVSubdivisions=2
		LifetimeRange=(Min=2.000000,Max=2.000000)
		StartVelocityRange=(X=(Min=200.000000,Max=400.000000),Y=(Min=-75.000000,Max=75.000000),Z=(Min=-75.000000,Max=75.000000))
	End Object
	Emitters(2)=SpriteEmitter'SpriteEmitter2'

	Begin Object Class=SpriteEmitter Name=SpriteEmitter3
		FadeOut=True
		FadeIn=True
		RespawnDeadParticles=False
		UseSizeScale=True
		UseRegularSizeScale=False
		UniformSize=True
		AutomaticInitialSpawning=False
		BlendBetweenSubdivisions=True
		UseRandomSubdivision=True
		ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
		ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
		MaxParticles=2
		UseRotationFrom=PTRS_Actor
		SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
		StartSizeRange=(X=(Min=50.000000,Max=60.000000))
		InitialParticlesPerSecond=100.000000
		DrawStyle=PTDS_AlphaBlend
		Texture=Texture'Effects_Tex.BulletHits.watersplatter2'
		TextureUSubdivisions=2
		TextureVSubdivisions=2
		LifetimeRange=(Min=1.000000,Max=1.000000)
	End Object
	Emitters(3)=SpriteEmitter'SpriteEmitter3'

	Begin Object Class=SpriteEmitter Name=SpriteEmitter4
		FadeOut=True
		FadeIn=True
		RespawnDeadParticles=False
		SpinParticles=True
		UseSizeScale=True
		UseRegularSizeScale=False
		UniformSize=True
		AutomaticInitialSpawning=False
		BlendBetweenSubdivisions=True
		UseRandomSubdivision=True
		UseVelocityScale=True
		Acceleration=(Z=-700.000000)
		ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
		ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
		FadeOutStartTime=0.500000
		MaxParticles=3
		StartLocationRange=(X=(Min=-10.000000,Max=10.000000))
		UseRotationFrom=PTRS_Actor
		StartSpinRange=(X=(Min=0.500000,Max=0.500000))
		SizeScale(0)=(RelativeSize=2.000000)
		SizeScale(1)=(RelativeTime=1.000000,RelativeSize=5.000000)
		StartSizeRange=(X=(Min=12.000000,Max=16.000000))
		InitialParticlesPerSecond=500.000000
		DrawStyle=PTDS_AlphaBlend
		Texture=Texture'Effects_Tex.BulletHits.watersplashcloud'
		LifetimeRange=(Min=1.500000,Max=1.500000)
		StartVelocityRange=(X=(Min=250.000000,Max=300.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-10.000000,Max=10.000000))
		VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
		VelocityScale(1)=(RelativeTime=0.205000,RelativeVelocity=(X=0.100000,Y=0.500000,Z=0.500000))
		VelocityScale(2)=(RelativeTime=1.000000,RelativeVelocity=(X=0.150000,Y=0.100000,Z=0.100000))
	End Object
	Emitters(4)=SpriteEmitter'SpriteEmitter4'

	Begin Object Class=SpriteEmitter Name=SpriteEmitter5
		FadeOut=True
		FadeIn=True
		RespawnDeadParticles=False
		SpinParticles=True
		UseSizeScale=True
		UseRegularSizeScale=False
		UniformSize=True
		AutomaticInitialSpawning=False
		BlendBetweenSubdivisions=True
		UseRandomSubdivision=True
		UseVelocityScale=True
		ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
		ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
		MaxParticles=6
		UseRotationFrom=PTRS_Actor
		SpinsPerSecondRange=(X=(Min=0.150000,Max=0.150000))
		SizeScale(0)=(RelativeSize=0.500000)
		SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.500000)
		StartSizeRange=(X=(Min=24.000000,Max=32.000000))
		InitialParticlesPerSecond=100.000000
		DrawStyle=PTDS_AlphaBlend
		Texture=Texture'Effects_Tex.BulletHits.watersplatter2'
		TextureUSubdivisions=2
		TextureVSubdivisions=2
		LifetimeRange=(Min=0.750000,Max=0.750000)
		StartVelocityRange=(X=(Min=50.000000,Max=100.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-10.000000,Max=10.000000))
		VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
		VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
		VelocityScale(2)=(RelativeTime=1.000000)
	End Object
	Emitters(5)=SpriteEmitter'SpriteEmitter5'

	Begin Object Class=SpriteEmitter Name=SpriteEmitter6
		FadeOut=True
		RespawnDeadParticles=False
		SpinParticles=True
		UseSizeScale=True
		UseRegularSizeScale=False
		UniformSize=True
		AutomaticInitialSpawning=False
		Acceleration=(X=-30.000000,Y=-30.000000,Z=-1000.000000)
		ColorScale(0)=(Color=(B=61,G=82,R=84,A=255))
		ColorScale(1)=(RelativeTime=1.000000,Color=(B=96,G=111,R=115,A=255))
		FadeOutStartTime=1.000000
		MaxParticles=12
		SpinsPerSecondRange=(X=(Min=0.050000,Max=0.050000))
		StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
		SizeScale(0)=(RelativeTime=1.000000,RelativeSize=25.000000)
		StartSizeRange=(X=(Min=5.000000,Max=10.000000),Y=(Min=5.000000,Max=10.000000),Z=(Min=5.000000,Max=10.000000))
		InitialParticlesPerSecond=100.000000
		DrawStyle=PTDS_AlphaBlend
		Texture=Texture'Effects_Tex.BulletHits.watersplatter2'
		LifetimeRange=(Min=2.000000,Max=2.000000)
		StartVelocityRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=500.000000,Max=800.000000))
	End Object
	Emitters(6)=SpriteEmitter'SpriteEmitter6'

/*
	Begin Object Class=SpriteEmitter Name=SpriteEmitter6
		FadeOut=True
		FadeIn=True
		RespawnDeadParticles=False
		SpinParticles=True
		UseSizeScale=True
		UseRegularSizeScale=False
		UniformSize=True
		AutomaticInitialSpawning=False
		BlendBetweenSubdivisions=True
		UseRandomSubdivision=True
		UseVelocityScale=True
		ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
		ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
		MaxParticles=3
		Name="SpriteEmitter79"
		UseRotationFrom=PTRS_Actor
		SpinsPerSecondRange=(X=(Min=0.050000,Max=0.050000))
		SizeScale(0)=(RelativeSize=0.500000)
		SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
		StartSizeRange=(X=(Min=50.000000,Max=60.000000))
		InitialParticlesPerSecond=100.000000
		DrawStyle=PTDS_AlphaBlend
		Texture=Texture'Effects_Tex.BulletHits.watersplatter2'
		TextureUSubdivisions=2
		TextureVSubdivisions=2
		LifetimeRange=(Min=0.750000,Max=0.750000)
		StartVelocityRange=(X=(Min=50.000000,Max=200.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-10.000000,Max=10.000000))
		VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
		VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
		VelocityScale(2)=(RelativeTime=1.000000)
	End Object
	Emitters(6)=SpriteEmitter'SpriteEmitter6'
*/

	Autodestroy=true
	bnodelete=false
	bhighdetail=true
	remoterole=role_none
}

/*
	Begin Object Class=SpriteEmitter Name=SpriteEmitter7
		FadeOut=True
		RespawnDeadParticles=False
		SpinParticles=True
		UseSizeScale=True
		UseRegularSizeScale=False
		UniformSize=True
		AutomaticInitialSpawning=False
		Acceleration=(X=-30.000000,Y=-30.000000,Z=-1000.000000)
		ColorScale(0)=(Color=(B=61,G=82,R=84,A=255))
		ColorScale(1)=(RelativeTime=1.000000,Color=(B=96,G=111,R=115,A=255))
		Name="SpriteEmitter92"
		SpinsPerSecondRange=(X=(Min=0.050000,Max=0.050000))
		StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
		SizeScale(0)=(RelativeTime=1.000000,RelativeSize=75.000000)
		StartSizeRange=(X=(Min=5.000000,Max=10.000000),Y=(Min=5.000000,Max=10.000000),Z=(Min=5.000000,Max=10.000000))
		InitialParticlesPerSecond=100.000000
		DrawStyle=PTDS_AlphaBlend
		Texture=Texture'Effects_Tex.BulletHits.watersplatter2'
		LifetimeRange=(Max=5.000000)
		StartVelocityRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-200.000000,Max=200.000000),Z=(Min=1000.000000,Max=1200.000000))
	End Object
	Emitters(7)=SpriteEmitter'SpriteEmitter7'
*/
