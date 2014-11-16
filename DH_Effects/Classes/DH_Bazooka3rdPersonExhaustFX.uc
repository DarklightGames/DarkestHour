//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Bazooka3rdPersonExhaustFX extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseColorScale=true
         FadeOut=true
         RespawnDeadParticles=false
         SpinParticles=true
         UseSizeScale=true
         UseRegularSizeScale=false
         UniformSize=true
         AutomaticInitialSpawning=false
         Acceleration=(X=10.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         FadeOutStartTime=3.000000
         StartLocationOffset=(X=-70.000000)
         StartLocationShape=PTLS_Sphere
         UseRotationFrom=PTRS_Actor
         SpinsPerSecondRange=(X=(Min=0.050000,Max=0.100000))
         StartSpinRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=0.500000,Max=1.000000),Z=(Min=0.500000,Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=20.000000)
         StartSizeRange=(X=(Min=30.000000,Max=45.000000),Y=(Min=30.000000,Max=45.000000),Z=(Min=30.000000,Max=45.000000))
         InitialParticlesPerSecond=5000.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'Effects_Tex.explosions.DSmoke_2'
         LifetimeRange=(Min=8.000000,Max=12.000000)
         StartVelocityRange=(X=(Min=-100.000000,Max=-20.000000),Y=(Min=-2.000000,Max=-5.000000),Z=(Min=-2.000000,Max=5.000000))
     End Object
     Emitters(0)=SpriteEmitter'DH_Effects.DH_Bazooka3rdPersonExhaustFX.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseColorScale=true
         FadeOut=true
         RespawnDeadParticles=false
         SpinParticles=true
         UseSizeScale=true
         UseRegularSizeScale=false
         UniformSize=true
         AutomaticInitialSpawning=false
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         FadeOutStartTime=3.000000
         StartLocationOffset=(X=-40.000000)
         StartLocationShape=PTLS_Sphere
         UseRotationFrom=PTRS_Actor
         SpinsPerSecondRange=(X=(Min=0.050000,Max=0.100000))
         StartSpinRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=0.500000,Max=1.000000),Z=(Min=0.500000,Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=8.000000)
         StartSizeRange=(X=(Min=3.000000,Max=5.000000),Y=(Min=3.000000,Max=5.000000),Z=(Min=3.000000,Max=5.000000))
         InitialParticlesPerSecond=5000.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'Effects_Tex.explosions.DSmoke_2'
         LifetimeRange=(Min=0.500000,Max=1.000000)
         StartVelocityRange=(X=(Min=-300.000000,Max=-200.000000),Y=(Min=-2.000000,Max=-5.000000),Z=(Min=-2.000000,Max=5.000000))
     End Object
     Emitters(1)=SpriteEmitter'DH_Effects.DH_Bazooka3rdPersonExhaustFX.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         UseColorScale=true
         FadeOut=true
         RespawnDeadParticles=false
         SpinParticles=true
         UseSizeScale=true
         UseRegularSizeScale=false
         UniformSize=true
         AutomaticInitialSpawning=false
         Acceleration=(X=100.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         Opacity=0.500000
         FadeOutStartTime=0.098000
         FadeInEndTime=0.080000
         StartLocationOffset=(X=-40.000000)
         StartLocationShape=PTLS_Sphere
         UseRotationFrom=PTRS_Actor
         SpinsPerSecondRange=(X=(Min=0.050000,Max=0.100000))
         StartSpinRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=0.500000,Max=1.000000),Z=(Min=0.500000,Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=8.000000)
         StartSizeRange=(X=(Min=3.000000,Max=5.000000),Y=(Min=3.000000,Max=5.000000),Z=(Min=3.000000,Max=5.000000))
         InitialParticlesPerSecond=5000.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'Effects_Tex.explosions.impact_2frame'
         TextureUSubdivisions=2
         TextureVSubdivisions=1
         LifetimeRange=(Min=0.200000,Max=0.300000)
         StartVelocityRange=(X=(Min=-200.000000),Y=(Min=-20.000000,Max=20.000000),Z=(Min=-20.000000,Max=20.000000))
     End Object
     Emitters(2)=SpriteEmitter'DH_Effects.DH_Bazooka3rdPersonExhaustFX.SpriteEmitter2'

     AutoDestroy=true
     bLightChanged=true
     bNoDelete=false
     bNetTemporary=true
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=8.000000
     Style=STY_Masked
     bHardAttach=true
     bDirectional=true
     bSelected=true
}
