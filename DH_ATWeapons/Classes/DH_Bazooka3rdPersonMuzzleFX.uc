//=============================================================================
// DH_Bazooka3rdPersonMuzzleFX
//=============================================================================
// 3rd person panzerfaust fire effect
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2005 Tripwire Interactive LLC
// - David Hensley & John "Ramm-Jaeger" Gibson
//=============================================================================

class DH_Bazooka3rdPersonMuzzleFX extends Emitter;

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
         Acceleration=(X=50.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         FadeOutStartTime=1.000000
         StartLocationOffset=(X=25.000000)
         StartLocationShape=PTLS_Sphere
         UseRotationFrom=PTRS_Actor
         SpinsPerSecondRange=(X=(Min=0.050000,Max=0.100000))
         StartSpinRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=0.500000,Max=1.000000),Z=(Min=0.500000,Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=20.000000)
         StartSizeRange=(X=(Min=3.000000,Max=5.000000),Y=(Min=3.000000,Max=5.000000),Z=(Min=3.000000,Max=5.000000))
         InitialParticlesPerSecond=5000.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'Effects_Tex.explosions.DSmoke_2'
         LifetimeRange=(Min=1.750000,Max=2.000000)
         StartVelocityRange=(X=(Max=400.000000),Y=(Min=-20.000000,Max=20.000000),Z=(Min=-20.000000,Max=20.000000))
     End Object
     Emitters(0)=SpriteEmitter'DH_ATWeapons.DH_Bazooka3rdPersonMuzzleFX.SpriteEmitter0'

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
         Opacity=0.500000
         FadeOutStartTime=0.102500
         FadeInEndTime=0.050000
         MaxParticles=2
         StartLocationOffset=(X=25.000000)
         UseRotationFrom=PTRS_Actor
         SizeScale(1)=(RelativeTime=0.250000,RelativeSize=1.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=50.000000,Max=50.000000),Y=(Min=50.000000,Max=50.000000),Z=(Min=50.000000,Max=50.000000))
         InitialParticlesPerSecond=60.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'Effects_Tex.explosions.radialexplosion_1frame'
         LifetimeRange=(Min=0.250000,Max=0.250000)
     End Object
     Emitters(1)=SpriteEmitter'DH_ATWeapons.DH_Bazooka3rdPersonMuzzleFX.SpriteEmitter1'

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
