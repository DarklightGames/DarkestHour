//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMuzzleFlash3rdPanzerfaust extends Emitter;

defaultproperties
{
    bLightChanged=True
    AutoDestroy=True
    Style=STY_Masked
    bUnlit=true
    bDirectional=True
    bNoDelete=false
    RemoteRole=ROLE_SimulatedProxy
    bNetTemporary=true
    bHardAttach=true
    LifeSpan = 8

    bSelected=True

    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(X=50.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=1.000000
        Name="SpriteEmitter0"
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
    Emitters(0)=SpriteEmitter'SpriteEmitter0'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
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
        Opacity=0.500000
        FadeOutStartTime=0.102500
        FadeInEndTime=0.050000
        MaxParticles=2
        Name="SpriteEmitter14"
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
    Emitters(1)=SpriteEmitter'SpriteEmitter1'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter3
      UseDirectionAs=PTDU_Up
      FadeOut=True
      RespawnDeadParticles=False
      SpinParticles=True
      AutomaticInitialSpawning=False
      UseRotationFrom=PTRS_Actor
      StartLocationShape=PTLS_Sphere
      Acceleration=(Z=-100.000000)
      ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
      ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
      FadeOutStartTime=0.09000
      MaxParticles=15
      //StartLocationOffset=(X=10.000000) //40
      SphereRadiusRange=(Max=5.000000) //20
      StartSizeRange=(X=(Min=1.000000,Max=2.000000),Y=(Min=2.000000,Max=4.000000))
      InitialParticlesPerSecond=100.000000
      Texture=Texture'DH_FX_tex.Effects.dhweaponspark' //verticle tracer particle
      LifetimeRange=(Min=0.20000,Max=0.400000)
      StartVelocityRange=(X=(Min=150.000000,Max=250.000000),Y=(Min=-80.000000,Max=80.000000),Z=(Min=-30.000000,Max=30.000000))
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter3'
}

