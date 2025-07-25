//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMortarExplosion60mmWater extends DHMortarExplosion;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter95
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
        Texture=Texture'Effects_Tex.muzzle_4frame3rd'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.250000,Max=0.350000)
        StartVelocityRange=(Z=(Min=100.000000,Max=350.000000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter95'

    Begin Object Class=SparkEmitter Name=SparkEmitter14
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
        MaxParticles=25
      
        InitialParticlesPerSecond=500.000000
        Texture=Texture'Effects_Tex.fire_quad'
        LifetimeRange=(Min=0.200000,Max=0.750000)
        StartVelocityRange=(X=(Min=-1550.000000,Max=1700.000000),Y=(Min=-1625.000000,Max=1750.000000),Z=(Min=-100.000000,Max=350.000000))
        VelocityLossRange=(Z=(Min=1.000000,Max=3.000000))
    End Object
    Emitters(1)=SparkEmitter'SparkEmitter14'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter97
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
        StartSizeRange=(X=(Min=120.000000,Max=180.000000))
        InitialParticlesPerSecond=100.000000
        Texture=Texture'SpecialEffects.SoftFlare'
        LifetimeRange=(Min=0.250000,Max=0.350000)
        StartVelocityRange=(Z=(Min=100.000000,Max=350.000000))
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter97'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter98
        FadeOut=True
        RespawnDeadParticles=False
        Disabled=True
        Backup_Disabled=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(X=-10.000000,Y=-10.000000,Z=-600.000000)
        ColorScale(0)=(Color=(B=61,G=82,R=84,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=96,G=111,R=115,A=255))
        MaxParticles=5
      
        SpinsPerSecondRange=(X=(Min=0.010000,Max=0.050000))
        SizeScale(0)=(RelativeTime=1.000000,RelativeSize=60.000000)
        StartSizeRange=(X=(Min=10.000000,Max=15.000000),Y=(Min=10.000000,Max=15.000000),Z=(Min=10.000000,Max=15.000000))
        InitialParticlesPerSecond=100.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.watersplatter2'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Max=5.000000)
        StartVelocityRange=(X=(Min=-250.000000,Max=250.000000),Y=(Min=-250.000000,Max=250.000000),Z=(Min=400.000000,Max=600.000000))
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter98'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter99
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(X=-10.000000,Y=-10.000000,Z=-600.000000)
        ColorScale(0)=(Color=(B=115,G=136,R=145,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=115,G=136,R=145,A=255))
        FadeOutStartTime=0.700000
        FadeInEndTime=0.200000
        MaxParticles=4
      
        StartLocationRange=(X=(Min=50.000000,Max=75.000000))
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.150000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=5.000000)
        StartSizeRange=(X=(Min=40.000000,Max=80.000000),Y=(Min=40.000000,Max=80.000000),Z=(Min=40.000000,Max=80.000000))
        InitialParticlesPerSecond=500.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.blood_spatter1'
        LifetimeRange=(Min=2.000000,Max=2.500000)
        InitialDelayRange=(Min=0.250000,Max=0.350000)
        StartVelocityRange=(X=(Min=-150.000000,Max=125.000000),Y=(Min=-150.000000,Max=150.000000),Z=(Min=350.000000,Max=450.000000))
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter99'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter100
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(X=-10.000000,Y=-10.000000,Z=-600.000000)
        ColorScale(0)=(Color=(B=148,G=169,R=180,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=96,G=111,R=115,A=255))
        Opacity=0.600000
        MaxParticles=8
      
        SpinsPerSecondRange=(X=(Min=0.010000,Max=0.050000))
        SizeScale(0)=(RelativeTime=1.000000,RelativeSize=50.000000)
        StartSizeRange=(X=(Min=10.000000,Max=15.000000),Y=(Min=10.000000,Max=15.000000),Z=(Min=10.000000,Max=15.000000))
        InitialParticlesPerSecond=100.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.blood_spatter1'
        TextureUSubdivisions=1
        TextureVSubdivisions=1
        LifetimeRange=(Max=5.000000)
        StartVelocityRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=400.000000,Max=700.000000))
    End Object
    Emitters(5)=SpriteEmitter'SpriteEmitter100'

    Begin Object Class=BeamEmitter Name=BeamEmitter17
        RotatingSheets=2
        UseColorScale=True
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=192,G=192,R=192,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.870000
        FadeInEndTime=0.210000
        MaxParticles=4
      
        StartLocationOffset=(Z=-100.000000)
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=1.500000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.800000)
        StartSizeRange=(X=(Min=300.000000,Max=300.000000),Y=(Min=300.000000,Max=300.000000),Z=(Min=200.000000,Max=200.000000))
        InitialParticlesPerSecond=50.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Impact03'
        LifetimeRange=(Min=2.500000,Max=3.000000)
        InitialDelayRange=(Min=0.150000,Max=0.200000)
        StartVelocityRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=150.000000,Max=225.000000))
    End Object
    Emitters(6)=BeamEmitter'BeamEmitter17'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter101
        UseDirectionAs=PTDU_Normal
        ProjectionNormal=(X=1.000000,Z=0.000000)
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        DampRotation=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        UseSubdivisionScale=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        MaxParticles=1
      
        UseRotationFrom=PTRS_Actor
        SpinCCWorCW=(X=0.000000,Y=0.000000,Z=0.000000)
        SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=2.500000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=4.000000)
        StartSizeRange=(X=(Min=50.000000,Max=75.000000),Y=(Min=50.000000,Max=75.000000),Z=(Min=50.000000,Max=75.000000))
        InitialParticlesPerSecond=100.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.waterring_2frame'
        TextureUSubdivisions=2
        TextureVSubdivisions=1
        SubdivisionScale(0)=0.500000
        LifetimeRange=(Min=1.000000,Max=1.500000)
    End Object
    Emitters(7)=SpriteEmitter'SpriteEmitter101'

    Begin Object Class=BeamEmitter Name=BeamEmitter18
        RotatingSheets=2
        UseColorScale=True
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=192,G=192,R=192,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.400000
        FadeOutStartTime=0.870000
        FadeInEndTime=0.210000
        MaxParticles=1
      
        StartLocationOffset=(Z=-50.000000)
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=2.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=4.000000)
        StartSizeRange=(X=(Min=35.000000,Max=35.000000),Y=(Min=35.000000,Max=35.000000),Z=(Min=150.000000,Max=250.000000))
        InitialParticlesPerSecond=50.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Impact01'
        LifetimeRange=(Min=1.700000,Max=2.500000)
        InitialDelayRange=(Min=0.350000,Max=0.500000)
        StartVelocityRange=(X=(Min=-20.000000,Max=20.000000),Y=(Min=-20.000000,Max=20.000000),Z=(Min=250.000000,Max=350.000000))
    End Object
    Emitters(8)=BeamEmitter'BeamEmitter18'
}
