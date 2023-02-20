//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHMortarExplosion60mmSand extends Emitter;

defaultproperties
{
    AutoDestroy=True
    Style=STY_Masked
    bUnlit=true
    bDirectional=True
    bNoDelete=false
    RemoteRole=ROLE_SimulatedProxy
    bNetTemporary=true
    bHardAttach=true

    Begin Object Class=SpriteEmitter Name=SpriteEmitter37
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(Z=500.000000)
        ColorScale(0)=(Color=(B=84,G=96,R=101,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=115,G=136,R=145,A=255))
        MaxParticles=1
      
        StartLocationOffset=(Z=-50.000000)
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.500000)
        StartSizeRange=(X=(Min=30.000000,Max=40.000000))
        InitialParticlesPerSecond=100.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.Weapons.muzzle_4frame3rd'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.250000,Max=0.350000)
        StartVelocityRange=(Z=(Min=100.000000,Max=350.000000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter37'

    Begin Object Class=SparkEmitter Name=SparkEmitter6
        LineSegmentsRange=(Min=1.000000,Max=2.000000)
        TimeBeforeVisibleRange=(Min=0.100000,Max=0.500000)
        TimeBetweenSegmentsRange=(Min=0.020000,Max=0.050000)
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        AutomaticInitialSpawning=False
        Acceleration=(Z=-250.000000)
        ColorScale(0)=(Color=(B=128,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(R=128,A=255))
        MaxParticles=50
      
        InitialParticlesPerSecond=500.000000
        Texture=Texture'Effects_Tex.explosions.fire_quad'
        LifetimeRange=(Min=0.200000,Max=0.750000)
        StartVelocityRange=(X=(Min=-1550.000000,Max=1700.000000),Y=(Min=-1625.000000,Max=1750.000000),Z=(Min=-100.000000,Max=800.000000))
        VelocityLossRange=(Z=(Min=1.000000,Max=3.000000))
    End Object
    Emitters(1)=SparkEmitter'SparkEmitter6'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter43
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(G=128,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(G=128,R=255,A=255))
        MaxParticles=1
      
        StartLocationOffset=(Z=-50.000000)
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.500000)
        StartSizeRange=(X=(Min=90.000000,Max=180.000000))
        InitialParticlesPerSecond=100.000000
        Texture=Texture'SpecialEffects.Flares.SoftFlare'
        LifetimeRange=(Min=0.250000,Max=0.350000)
        StartVelocityRange=(Z=(Min=100.000000,Max=350.000000))
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter43'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter44
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(X=-10.000000,Y=-10.000000,Z=-600.000000)
        ColorScale(0)=(Color=(B=61,G=82,R=84,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=96,G=111,R=115,A=255))
        MaxParticles=16
      
        SpinsPerSecondRange=(X=(Min=0.010000,Max=0.050000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=25.000000)
        StartSizeRange=(X=(Min=10.000000,Max=15.000000),Y=(Min=10.000000,Max=15.000000),Z=(Min=10.000000,Max=15.000000))
        InitialParticlesPerSecond=100.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.exp_dirt'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Max=5.000000)
        StartVelocityRange=(X=(Min=-250.000000,Max=250.000000),Y=(Min=-250.000000,Max=250.000000),Z=(Min=400.000000,Max=700.000000))
        AddVelocityFromOtherEmitter=7
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter44'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter53
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        TriggerDisabled=False
        ResetOnTrigger=True
        ColorScale(0)=(Color=(B=98,G=132,R=162,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=146,G=164,R=184,A=255))
        FadeOutStartTime=1.860000
        FadeInEndTime=0.180000
        MaxParticles=6
      
        StartLocationRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000))
        SpinCCWorCW=(X=1.000000)
        SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=2.000000)
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=6.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=14.000000)
        StartSizeRange=(X=(Min=60.000000,Max=90.000000),Y=(Min=60.000000,Max=90.000000),Z=(Min=60.000000,Max=90.000000))
        InitialParticlesPerSecond=500.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.dirtcloud'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Max=6.000000)
        InitialDelayRange=(Min=0.250000,Max=0.350000)
        StartVelocityRange=(X=(Min=-150.000000,Max=150.000000),Y=(Min=-150.000000,Max=150.000000),Z=(Min=50.000000,Max=50.000000))
        VelocityLossRange=(Z=(Min=3.000000,Max=3.000000))
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter53'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter54
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(X=-10.000000,Y=-40.000000,Z=-400.000000)
        ColorScale(0)=(Color=(B=98,G=132,R=162,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=146,G=164,R=184,A=255))
        Opacity=0.600000
        FadeOutStartTime=1.325000
        MaxParticles=4
      
        StartLocationRange=(X=(Min=-150.000000,Max=175.000000))
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.050000,Max=0.075000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=5.000000)
        StartSizeRange=(X=(Min=120.000000,Max=150.000000),Y=(Min=120.000000,Max=150.000000),Z=(Min=120.000000,Max=150.000000))
        InitialParticlesPerSecond=500.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.LSmoke1'
        LifetimeRange=(Min=3.000000,Max=3.500000)
        InitialDelayRange=(Max=0.100000)
        StartVelocityRange=(X=(Min=-100.000000,Max=125.000000),Y=(Min=-115.000000,Max=100.000000),Z=(Min=300.000000,Max=700.000000))
    End Object
    Emitters(5)=SpriteEmitter'SpriteEmitter54'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter55
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(G=128,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(G=128,R=255,A=255))
        MaxParticles=1
      
        StartLocationOffset=(Z=-50.000000)
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.500000)
        StartSizeRange=(X=(Min=120.000000,Max=150.000000))
        InitialParticlesPerSecond=100.000000
        Texture=Texture'Effects_Tex.explosions.radialexplosion_1frame'
        LifetimeRange=(Min=0.350000,Max=0.500000)
    End Object
    Emitters(6)=SpriteEmitter'SpriteEmitter55'

    Begin Object Class=BeamEmitter Name=BeamEmitter11
        RotatingSheets=2
        UseColorScale=True
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=63,G=102,R=129,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=166,G=180,R=189,A=255))
        Opacity=0.720000
        FadeOutStartTime=0.870000
        FadeInEndTime=0.210000
      
        StartLocationOffset=(Z=-50.000000)
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=1.500000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.800000)
        StartSizeRange=(X=(Min=150.000000,Max=150.000000),Y=(Min=200.000000,Max=200.000000),Z=(Min=250.000000,Max=300.000000))
        InitialParticlesPerSecond=50.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.Impact01'
        LifetimeRange=(Min=2.500000,Max=3.000000)
        InitialDelayRange=(Max=0.150000)
        StartVelocityRange=(X=(Min=-200.000000,Max=250.000000),Y=(Min=-225.000000,Max=200.000000),Z=(Min=150.000000,Max=225.000000))
    End Object
    Emitters(7)=BeamEmitter'BeamEmitter11'

    Begin Object Class=BeamEmitter Name=BeamEmitter12
        RotatingSheets=2
        UseColorScale=True
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=34,G=46,R=51,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=44,G=56,R=61,A=255))
        Opacity=0.400000
        FadeOutStartTime=0.870000
        FadeInEndTime=0.120000
        MaxParticles=4
      
        StartLocationOffset=(Z=-100.000000)
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=1.500000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.800000)
        StartSizeRange=(X=(Min=200.000000,Max=250.000000),Y=(Min=200.000000,Max=250.000000),Z=(Min=500.000000,Max=500.000000))
        InitialParticlesPerSecond=25.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.Impact03'
        LifetimeRange=(Min=2.500000,Max=3.000000)
        InitialDelayRange=(Min=0.150000,Max=0.250000)
        StartVelocityRange=(X=(Min=-250.000000,Max=250.000000),Y=(Min=-200.000000,Max=150.000000),Z=(Min=350.000000,Max=350.000000))
    End Object
    Emitters(8)=BeamEmitter'BeamEmitter12'
}
