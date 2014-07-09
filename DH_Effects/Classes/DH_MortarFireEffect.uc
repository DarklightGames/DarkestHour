//=============================================================================
// DH_MortarFireEffect
//=============================================================================
// Firing effect for mortars.
//=============================================================================
// Darkest Hour Source
// Copyright (C) 2011 Darklight Games
// Created by: Colin Basnett
//=============================================================================

class DH_MortarFireEffect extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter21
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255))
         ColorScale(1)=(RelativeTime=1.000000)
         MaxParticles=1
         DetailMode=DM_SuperHigh
         StartLocationShape=PTLS_Sphere
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=0.150000)
         SizeScale(1)=(RelativeTime=0.750000,RelativeSize=0.500000)
         StartSizeRange=(X=(Max=60.000000))
         InitialParticlesPerSecond=5000.000000
         Texture=Texture'Effects_Tex.BulletHits.glowfinal'
         LifetimeRange=(Min=0.250000,Max=0.350000)
     End Object
     Emitters(0)=SpriteEmitter'DH_Effects.DH_MortarFireEffect.SpriteEmitter21'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter31
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=174,G=228,R=255,A=255))
         ColorScale(1)=(RelativeTime=0.200000,Color=(B=255,G=255,R=255,A=255))
         ColorScale(2)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorScale(3)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorScale(4)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         FadeOutStartTime=0.102500
         FadeInEndTime=0.050000
         MaxParticles=1
         SizeScale(1)=(RelativeTime=0.250000,RelativeSize=0.250000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=0.500000)
         InitialParticlesPerSecond=30.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'Effects_Tex.explosions.radialexplosion_1frame'
         LifetimeRange=(Min=0.250000,Max=0.250000)
     End Object
     Emitters(1)=SpriteEmitter'DH_Effects.DH_MortarFireEffect.SpriteEmitter31'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter37
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseRandomSubdivision=True
         Acceleration=(X=25.000000,Y=25.000000)
         ColorScale(0)=(Color=(B=95,G=95,R=95,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=150,G=150,R=150))
         Opacity=0.750000
         FadeOutStartTime=0.780000
         MaxParticles=16
         UseRotationFrom=PTRS_Actor
         SpinsPerSecondRange=(X=(Max=0.125000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=32.000000,Max=64.000000),Y=(Min=32.000000,Max=64.000000),Z=(Min=32.000000,Max=64.000000))
         InitialParticlesPerSecond=62500.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'Effects_Tex.explosions.DSmoke_2'
         LifetimeRange=(Min=1.000000,Max=3.000000)
         StartVelocityRange=(X=(Min=32.000000,Max=320.000000))
         VelocityLossRange=(X=(Max=5.000000),Y=(Max=5.000000),Z=(Max=5.000000))
         VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
         VelocityScale(1)=(RelativeTime=0.125000,RelativeVelocity=(X=0.200000,Y=0.200000,Z=0.200000))
         VelocityScale(2)=(RelativeTime=1.000000)
     End Object
     Emitters(2)=SpriteEmitter'DH_Effects.DH_MortarFireEffect.SpriteEmitter37'

     AutoDestroy=True
     bNoDelete=False
}
