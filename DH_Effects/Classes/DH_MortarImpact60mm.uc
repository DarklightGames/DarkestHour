//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_MortarImpact60mm extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter40
         FadeOut=true
         FadeIn=true
         RespawnDeadParticles=false
         SpinParticles=true
         UseSizeScale=true
         UseRegularSizeScale=false
         UniformSize=true
         AutomaticInitialSpawning=false
         TriggerDisabled=false
         ResetOnTrigger=true
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         FadeOutStartTime=0.500000
         FadeInEndTime=0.200000
         MaxParticles=2
         StartLocationRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000))
         SpinCCWorCW=(X=1.000000)
         SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
         StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
         SizeScale(1)=(RelativeTime=0.250000,RelativeSize=12.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=16.000000)
         StartSizeRange=(X=(Min=30.000000,Max=60.000000),Y=(Min=30.000000,Max=60.000000),Z=(Min=45.000000,Max=50.000000))
         InitialParticlesPerSecond=500.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'Effects_Tex.explosions.LSmoke3'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Max=6.000000)
         StartVelocityRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=50.000000,Max=50.000000))
         VelocityLossRange=(Z=(Min=3.000000,Max=3.000000))
     End Object
     Emitters(0)=SpriteEmitter'DH_Effects.DH_MortarImpact60mm.SpriteEmitter40'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter41
         FadeOut=true
         FadeIn=true
         RespawnDeadParticles=false
         SpinParticles=true
         UseSizeScale=true
         UseRegularSizeScale=false
         UniformSize=true
         AutomaticInitialSpawning=false
         TriggerDisabled=false
         ResetOnTrigger=true
         Acceleration=(X=32.000000,Y=32.000000,Z=-16.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         Opacity=0.750000
         FadeOutStartTime=1.020000
         FadeInEndTime=0.510000
         MaxParticles=5
         StartLocationOffset=(Z=64.000000)
         StartLocationRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000))
         SpinCCWorCW=(X=1.000000)
         SpinsPerSecondRange=(X=(Min=0.100000,Max=0.100000))
         StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
         SizeScale(0)=(RelativeSize=2.000000)
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=4.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=8.000000)
         StartSizeRange=(X=(Min=30.000000,Max=80.000000),Y=(Min=30.000000,Max=80.000000),Z=(Min=45.000000,Max=50.000000))
         InitialParticlesPerSecond=15.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'Effects_Tex.explosions.LSmoke3'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=2.000000,Max=3.000000)
         StartVelocityRange=(X=(Min=-122.472000,Max=122.472000),Y=(Min=-122.472000,Max=122.472000),Z=(Min=90.000000,Max=90.000000))
     End Object
     Emitters(1)=SpriteEmitter'DH_Effects.DH_MortarImpact60mm.SpriteEmitter41'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter42
         UseColorScale=true
         FadeOut=true
         RespawnDeadParticles=false
         UseSizeScale=true
         UseRegularSizeScale=false
         UniformSize=true
         AutomaticInitialSpawning=false
         BlendBetweenSubdivisions=true
         Acceleration=(Z=50.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.250000,Max=0.250000),Y=(Min=0.250000,Max=0.250000),Z=(Min=0.250000,Max=0.250000))
         FadeOutFactor=(X=0.500000,Y=0.500000,Z=0.500000)
         FadeOutStartTime=0.055000
         MaxParticles=3
         SizeScale(1)=(RelativeTime=0.140000,RelativeSize=2.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=3.000000)
         StartSizeRange=(X=(Min=75.000000,Max=75.000000),Y=(Min=75.000000,Max=75.000000),Z=(Min=75.000000,Max=75.000000))
         InitialParticlesPerSecond=30.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'Effects_Tex.explosions.impact_2frame'
         TextureUSubdivisions=2
         TextureVSubdivisions=1
         LifetimeRange=(Min=0.250000,Max=0.250000)
         StartVelocityRange=(Z=(Min=10.000000,Max=10.000000))
     End Object
     Emitters(2)=SpriteEmitter'DH_Effects.DH_MortarImpact60mm.SpriteEmitter42'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter43
         FadeOut=true
         FadeIn=true
         RespawnDeadParticles=false
         SpinParticles=true
         UseSizeScale=true
         UseRegularSizeScale=false
         UniformSize=true
         AutomaticInitialSpawning=false
         TriggerDisabled=false
         ResetOnTrigger=true
         Acceleration=(Y=50.000000,Z=50.000000)
         ColorScale(0)=(Color=(B=129,G=129,R=129,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         Opacity=0.500000
         MaxParticles=16
         StartLocationRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000))
         SpinCCWorCW=(X=1.000000)
         SpinsPerSecondRange=(X=(Max=0.250000))
         StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
         SizeScale(0)=(RelativeSize=2.000000)
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=4.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=6.000000)
         StartSizeRange=(X=(Min=25.000000,Max=75.000000),Y=(Min=25.000000,Max=75.000000),Z=(Min=45.000000,Max=50.000000))
         InitialParticlesPerSecond=5000.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'Effects_Tex.explosions.LSmoke1'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=7.000000,Max=8.000000)
         StartVelocityRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=256.000000,Max=1600.000000))
         VelocityLossRange=(Z=(Min=1.000000,Max=1.000000))
     End Object
     Emitters(3)=SpriteEmitter'DH_Effects.DH_MortarImpact60mm.SpriteEmitter43'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter44
         FadeOut=true
         FadeIn=true
         RespawnDeadParticles=false
         SpinParticles=true
         UseSizeScale=true
         UseRegularSizeScale=false
         UniformSize=true
         AutomaticInitialSpawning=false
         TriggerDisabled=false
         ResetOnTrigger=true
         Acceleration=(Y=50.000000,Z=50.000000)
         ColorScale(0)=(Color=(B=96,G=96,R=96,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=121,G=121,R=121,A=255))
         Opacity=0.500000
         FadeOutStartTime=1.020000
         FadeInEndTime=0.210000
         StartLocationRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000))
         AddLocationFromOtherEmitter=3
         SpinCCWorCW=(X=1.000000)
         SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
         StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
         SizeScale(0)=(RelativeSize=2.000000)
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=4.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=6.000000)
         StartSizeRange=(X=(Min=20.000000),Y=(Min=20.000000),Z=(Min=45.000000,Max=50.000000))
         InitialParticlesPerSecond=20.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'Effects_Tex.explosions.DSmoke_1'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=7.000000,Max=8.000000)
         InitialDelayRange=(Min=0.200000,Max=0.200000)
         StartVelocityRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=10.000000,Max=10.000000))
         VelocityLossRange=(Z=(Min=3.000000,Max=3.000000))
     End Object
     Emitters(4)=SpriteEmitter'DH_Effects.DH_MortarImpact60mm.SpriteEmitter44'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter45
         UseColorScale=true
         FadeOut=true
         FadeIn=true
         RespawnDeadParticles=false
         AlphaTest=false
         SpinParticles=true
         UseSizeScale=true
         UseRegularSizeScale=false
         UniformSize=true
         AutomaticInitialSpawning=false
         ColorScale(0)=(Color=(B=53,G=66,R=74,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=53,G=66,R=74,A=255))
         FadeOutStartTime=0.300000
         FadeInEndTime=0.105000
         MaxParticles=1
         StartLocationOffset=(Z=64.000000)
         StartSpinRange=(X=(Min=0.500000,Max=0.500000))
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=8.000000)
         StartSizeRange=(X=(Min=64.000000,Max=64.000000),Y=(Min=64.000000,Max=64.000000),Z=(Min=0.000000,Max=0.000000))
         InitialParticlesPerSecond=30.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'Effects_Tex.explosions.artilleryblast_1frame'
         LifetimeRange=(Min=1.000000,Max=1.250000)
         StartVelocityRange=(Z=(Min=386.000000,Max=386.000000))
         VelocityLossRange=(Z=(Min=0.500000,Max=0.500000))
     End Object
     Emitters(5)=SpriteEmitter'DH_Effects.DH_MortarImpact60mm.SpriteEmitter45'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter46
         FadeOut=true
         RespawnDeadParticles=false
         SpinParticles=true
         UseSizeScale=true
         UseRegularSizeScale=false
         UniformSize=true
         AutomaticInitialSpawning=false
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         FadeOutStartTime=0.130000
         MaxParticles=2
         StartLocationOffset=(Z=32.000000)
         StartSpinRange=(X=(Min=0.500000,Max=0.500000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=16.000000)
         StartSizeRange=(X=(Min=48.000000,Max=48.000000),Y=(Min=48.000000,Max=48.000000),Z=(Min=48.000000,Max=48.000000))
         InitialParticlesPerSecond=100.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'Effects_Tex.explosions.explosion_1frame'
         LifetimeRange=(Min=1.000000,Max=1.500000)
         StartVelocityRange=(Z=(Min=120.000000,Max=120.000000))
     End Object
     Emitters(6)=SpriteEmitter'DH_Effects.DH_MortarImpact60mm.SpriteEmitter46'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter47
         ProjectionNormal=(Y=1.000000)
         UseColorScale=true
         FadeOut=true
         RespawnDeadParticles=false
         SpinParticles=true
         UseSizeScale=true
         UseRegularSizeScale=false
         UniformSize=true
         AutomaticInitialSpawning=false
         Acceleration=(X=-10.000000,Y=-10.000000,Z=-1000.000000)
         ColorScale(0)=(Color=(B=61,G=82,R=84,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=96,G=111,R=115,A=255))
         MaxParticles=8
         SpinCCWorCW=(X=0.170000)
         SpinsPerSecondRange=(X=(Min=0.125000,Max=0.250000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=32.000000)
         StartSizeRange=(X=(Min=5.000000,Max=10.000000),Y=(Min=5.000000,Max=10.000000),Z=(Min=5.000000,Max=10.000000))
         InitialParticlesPerSecond=100.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'Effects_Tex.explosions.exp_dirt'
         LifetimeRange=(Max=5.000000)
         StartVelocityRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-200.000000,Max=200.000000),Z=(Max=768.000000))
     End Object
     Emitters(7)=SpriteEmitter'DH_Effects.DH_MortarImpact60mm.SpriteEmitter47'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter48
         UseColorScale=true
         FadeOut=true
         RespawnDeadParticles=false
         SpinParticles=true
         UseSizeScale=true
         UseRegularSizeScale=false
         UniformSize=true
         AutomaticInitialSpawning=false
         ColorScale(0)=(Color=(B=104,G=123,R=132,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=176,G=182,R=181,A=255))
         FadeOutStartTime=1.140000
         MaxParticles=16
         StartLocationOffset=(Z=32.000000)
         StartLocationRange=(X=(Min=-25.000000,Max=25.000000),Y=(Min=-25.000000,Max=25.000000))
         StartLocationShape=PTLS_Sphere
         SpinsPerSecondRange=(X=(Min=0.050000,Max=0.100000))
         StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=7.000000)
         StartSizeRange=(X=(Min=25.000000),Y=(Min=25.000000),Z=(Min=20.000000,Max=20.000000))
         InitialParticlesPerSecond=100.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'Effects_Tex.explosions.DSmoke_2'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=3.000000,Max=3.000000)
         StartVelocityRange=(X=(Min=-1331.407959,Max=1331.407959),Y=(Min=-1331.407959,Max=1331.407959))
         VelocityLossRange=(X=(Min=3.000000,Max=3.000000),Y=(Min=3.000000,Max=3.000000))
     End Object
     Emitters(8)=SpriteEmitter'DH_Effects.DH_MortarImpact60mm.SpriteEmitter48'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter67
         UseDirectionAs=PTDU_Normal
         ProjectionNormal=(Y=1.000000)
         UseColorScale=true
         FadeOut=true
         RespawnDeadParticles=false
         SpinParticles=true
         UseSizeScale=true
         UseRegularSizeScale=false
         UniformSize=true
         AutomaticInitialSpawning=false
         Acceleration=(X=-10.000000,Y=-10.000000,Z=-512.000000)
         ColorScale(0)=(Color=(B=61,G=82,R=84,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=96,G=111,R=115,A=255))
         MaxParticles=16
         SpinsPerSecondRange=(X=(Min=0.125000,Max=0.250000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=32.000000)
         StartSizeRange=(X=(Min=5.000000,Max=10.000000),Y=(Min=5.000000,Max=10.000000),Z=(Min=5.000000,Max=10.000000))
         InitialParticlesPerSecond=128.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'Effects_Tex.explosions.exp_dirt'
         LifetimeRange=(Min=1.960000,Max=2.280000)
         StartVelocityRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-200.000000,Max=200.000000),Z=(Max=1024.000000))
     End Object
     Emitters(9)=SpriteEmitter'DH_Effects.DH_MortarImpact60mm.SpriteEmitter67'

     AutoDestroy=true
     bNoDelete=false
}
