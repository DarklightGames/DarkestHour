//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_HorizonArtillery extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseColorScale=true
         RespawnDeadParticles=false
         SpinParticles=true
         UseSizeScale=true
         UseRegularSizeScale=false
         UniformSize=true
         AutomaticInitialSpawning=false
         ColorScale(0)=(Color=(B=255,G=255,R=255))
         ColorScale(1)=(RelativeTime=1.000000)
         Opacity=0.700000
         MaxParticles=1
         DetailMode=DM_SuperHigh
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=16.000000,Max=32.000000)
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=0.750000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.750000)
         StartSizeRange=(X=(Max=150.000000))
         InitialParticlesPerSecond=5000.000000
         Texture=Texture'Effects_Tex.BulletHits.glowfinal'
         LifetimeRange=(Min=0.250000,Max=0.350000)
     End Object
     Emitters(0)=SpriteEmitter'DH_Effects.DH_HorizonArtillery.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseColorScale=true
         FadeOut=true
         FadeIn=true
         RespawnDeadParticles=false
         UseSizeScale=true
         UseRegularSizeScale=false
         UniformSize=true
         AutomaticInitialSpawning=false
         ColorScale(0)=(Color=(B=174,G=228,R=255,A=255))
         ColorScale(1)=(RelativeTime=0.200000,Color=(B=255,G=255,R=255,A=255))
         ColorScale(2)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorScale(3)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorScale(4)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         FadeOutStartTime=0.102500
         FadeInEndTime=0.050000
         MaxParticles=3
         SizeScale(1)=(RelativeTime=0.250000,RelativeSize=1.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=50.000000,Max=50.000000),Y=(Min=50.000000,Max=50.000000),Z=(Min=50.000000,Max=50.000000))
         InitialParticlesPerSecond=30.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'Effects_Tex.explosions.radialexplosion_1frame'
         LifetimeRange=(Min=0.250000,Max=0.250000)
     End Object
     Emitters(1)=SpriteEmitter'DH_Effects.DH_HorizonArtillery.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         UseColorScale=true
         RespawnDeadParticles=false
         SpinParticles=true
         UseSizeScale=true
         UseRegularSizeScale=false
         UniformSize=true
         AutomaticInitialSpawning=false
         UseRandomSubdivision=true
         ColorScale(0)=(Color=(B=255,G=255,R=255))
         ColorScale(1)=(RelativeTime=1.000000)
         MaxParticles=2
         UseRotationFrom=PTRS_Actor
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000))
         InitialParticlesPerSecond=5000.000000
         Texture=Texture'Effects_Tex.Weapons.muzzle_4frame3rd'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         LifetimeRange=(Min=0.100000,Max=0.200000)
         StartVelocityRange=(X=(Min=20.000000,Max=25.000000))
     End Object
     Emitters(2)=SpriteEmitter'DH_Effects.DH_HorizonArtillery.SpriteEmitter2'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         UseColorScale=true
         RespawnDeadParticles=false
         SpinParticles=true
         UseSizeScale=true
         UseRegularSizeScale=false
         UniformSize=true
         AutomaticInitialSpawning=false
         UseRandomSubdivision=true
         ColorScale(0)=(Color=(B=255,G=255,R=255))
         ColorScale(1)=(RelativeTime=1.000000)
         MaxParticles=1
         StartLocationOffset=(X=10.000000)
         StartLocationRange=(X=(Max=10.000000))
         UseRotationFrom=PTRS_Actor
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000))
         InitialParticlesPerSecond=5000.000000
         Texture=Texture'Effects_Tex.Weapons.muzzle_4frame3rd'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         LifetimeRange=(Min=0.200000,Max=0.200000)
         StartVelocityRange=(X=(Min=60.000000,Max=75.000000))
     End Object
     Emitters(3)=SpriteEmitter'DH_Effects.DH_HorizonArtillery.SpriteEmitter3'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter4
         UseColorScale=true
         RespawnDeadParticles=false
         SpinParticles=true
         UseSizeScale=true
         UseRegularSizeScale=false
         UniformSize=true
         AutomaticInitialSpawning=false
         UseRandomSubdivision=true
         ColorScale(0)=(Color=(B=255,G=255,R=255))
         ColorScale(1)=(RelativeTime=1.000000)
         MaxParticles=1
         StartLocationOffset=(X=30.000000)
         StartLocationRange=(X=(Max=10.000000))
         UseRotationFrom=PTRS_Actor
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=5.000000,Max=5.000000))
         InitialParticlesPerSecond=5000.000000
         Texture=Texture'Effects_Tex.Weapons.muzzle_4frame3rd'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         LifetimeRange=(Min=0.100000,Max=0.200000)
         StartVelocityRange=(X=(Min=20.000000,Max=25.000000))
     End Object
     Emitters(4)=SpriteEmitter'DH_Effects.DH_HorizonArtillery.SpriteEmitter4'

     AutoDestroy=true
     bNoDelete=false
     bNetTemporary=true
     RemoteRole=ROLE_SimulatedProxy
}
