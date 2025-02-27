//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMortarExplosion60mm extends DHMortarExplosion;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter23
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
    Emitters(0)=SpriteEmitter'SpriteEmitter23'

    Begin Object Class=SparkEmitter Name=SparkEmitter3
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
        Texture=Texture'Effects_Tex.explosions.fire_quad'
        LifetimeRange=(Min=0.200000,Max=0.750000)
        StartVelocityRange=(X=(Min=-1550.000000,Max=1700.000000),Y=(Min=-1625.000000,Max=1750.000000),Z=(Min=-100.000000,Max=350.000000))
        VelocityLossRange=(Z=(Min=1.000000,Max=3.000000))
    End Object
    Emitters(1)=SparkEmitter'SparkEmitter3'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter24
        UseDirectionAs=PTDU_UpAndNormal
        ProjectionNormal=(X=1.000000,Y=0.500000)
        UseCollision=True
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(Y=10.000000,Z=-100.000000)
        DampingFactorRange=(X=(Min=0.000000,Max=0.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=64,G=128,R=255,A=255))
        ColorScaleRepeats=4.000000
        MaxParticles=20

        StartLocationOffset=(Z=20.000000)
        AddLocationFromOtherEmitter=1
        SphereRadiusRange=(Min=20.000000,Max=50.000000)
        SpinsPerSecondRange=(X=(Min=0.500000,Max=4.000000))
        StartSpinRange=(X=(Min=-0.500000,Max=1.000000))
        StartSizeRange=(X=(Min=1.500000,Max=3.000000))
        InitialParticlesPerSecond=1000.000000
        Texture=Texture'Effects_Tex.Smoke.Sparks'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=2.000000,Max=3.000000)
        InitialDelayRange=(Min=0.300000,Max=0.450000)
        StartVelocityRange=(X=(Min=-160.000000,Max=150.000000),Y=(Min=-150.000000,Max=165.000000),Z=(Min=25.000000,Max=75.000000))
        VelocityLossRange=(Z=(Min=1.000000,Max=3.000000))
        GetVelocityDirectionFrom=PTVD_StartPositionAndOwner
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter24'

    Begin Object Class=SparkEmitter Name=SparkEmitter4
        LineSegmentsRange=(Min=1.000000,Max=2.000000)
        TimeBeforeVisibleRange=(Min=0.100000,Max=0.500000)
        TimeBetweenSegmentsRange=(Min=0.020000,Max=0.050000)
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        AutomaticInitialSpawning=False
        Acceleration=(Z=-450.000000)
        ColorScale(0)=(Color=(B=128,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(R=128,A=255))
        MaxParticles=25

        StartSizeRange=(X=(Min=80.000000),Y=(Min=80.000000),Z=(Min=80.000000))
        InitialParticlesPerSecond=500.000000
        Texture=Texture'Effects_Tex.explosions.fire_quad'
        LifetimeRange=(Min=0.200000,Max=0.750000)
        StartVelocityRange=(X=(Min=-500.000000,Max=550.000000),Y=(Min=-555.000000,Max=600.000000),Z=(Min=-1000.000000,Max=1000.000000))
        VelocityLossRange=(Z=(Min=1.000000,Max=3.000000))
    End Object
    Emitters(3)=SparkEmitter'SparkEmitter4'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter25
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        Disabled=True
        Backup_Disabled=True
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
    Emitters(4)=SpriteEmitter'SpriteEmitter25'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter26
        UseColorScale=True
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
        MaxParticles=12

        SpinsPerSecondRange=(X=(Min=0.010000,Max=0.050000))
        SizeScale(0)=(RelativeTime=1.000000,RelativeSize=50.000000)
        StartSizeRange=(X=(Min=10.000000,Max=15.000000),Y=(Min=10.000000,Max=15.000000),Z=(Min=10.000000,Max=15.000000))
        InitialParticlesPerSecond=100.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.exp_dirt'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Max=5.000000)
        StartVelocityRange=(X=(Min=-250.000000,Max=250.000000),Y=(Min=-250.000000,Max=250.000000),Z=(Min=400.000000,Max=600.000000))
    End Object
    Emitters(5)=SpriteEmitter'SpriteEmitter26'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter27
        UseColorScale=True
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        TriggerDisabled=False
        ResetOnTrigger=True
        ColorScale(0)=(Color=(G=77,R=255,A=255))
        ColorScale(1)=(RelativeTime=0.050000,Color=(B=75,G=91,R=109,A=255))
        ColorScale(2)=(RelativeTime=1.000000,Color=(B=180,G=196,R=201,A=255))
        FadeOutStartTime=0.500000
        FadeInEndTime=0.200000
        MaxParticles=2

        StartLocationRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000))
        SpinCCWorCW=(X=1.000000)
        SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=2.000000)
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=6.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=14.000000)
        StartSizeRange=(X=(Min=30.000000,Max=60.000000),Y=(Min=30.000000,Max=60.000000),Z=(Min=45.000000,Max=50.000000))
        InitialParticlesPerSecond=500.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.LSmoke3'
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Max=6.000000)
        InitialDelayRange=(Min=0.250000,Max=0.350000)
        StartVelocityRange=(X=(Min=-150.000000,Max=150.000000),Y=(Min=-150.000000,Max=150.000000),Z=(Min=50.000000,Max=50.000000))
        VelocityLossRange=(Z=(Min=3.000000,Max=3.000000))
    End Object
    Emitters(6)=SpriteEmitter'SpriteEmitter27'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter29
        UseColorScale=True
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
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
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
        StartSizeRange=(X=(Max=150.000000),Y=(Max=150.000000),Z=(Max=150.000000))
        InitialParticlesPerSecond=500.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.dirtcloud'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=2.000000,Max=2.000000)
        InitialDelayRange=(Min=0.250000,Max=0.350000)
        StartVelocityRange=(X=(Min=-100.000000,Max=125.000000),Y=(Min=-115.000000,Max=100.000000),Z=(Min=350.000000,Max=500.000000))
    End Object
    Emitters(7)=SpriteEmitter'SpriteEmitter29'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter32
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
        StartSizeRange=(X=(Min=90.000000,Max=120.000000))
        InitialParticlesPerSecond=100.000000
        Texture=Texture'Effects_Tex.explosions.radialexplosion_1frame'
        LifetimeRange=(Min=0.350000,Max=0.500000)
    End Object
    Emitters(8)=SpriteEmitter'SpriteEmitter32'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter38
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(X=-10.000000,Y=-10.000000,Z=-600.000000)
        ColorScale(0)=(Color=(B=148,G=169,R=180,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=96,G=111,R=115,A=255))
        MaxParticles=8

        SpinsPerSecondRange=(X=(Min=0.010000,Max=0.050000))
        SizeScale(0)=(RelativeTime=1.000000,RelativeSize=50.000000)
        StartSizeRange=(X=(Min=5.000000,Max=10.000000),Y=(Min=5.000000,Max=10.000000),Z=(Min=5.000000,Max=10.000000))
        InitialParticlesPerSecond=100.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.exp_dirt'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Max=5.000000)
        StartVelocityRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=200.000000,Max=800.000000))
    End Object
    Emitters(9)=SpriteEmitter'SpriteEmitter38'

    Begin Object Class=BeamEmitter Name=BeamEmitter5
        RotatingSheets=2
        UseColorScale=True
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=78,G=78,R=78,A=255))
        Opacity=0.500000
        FadeOutStartTime=0.870000
        FadeInEndTime=0.210000

        StartLocationOffset=(Z=-50.000000)
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=1.500000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.800000)
        StartSizeRange=(X=(Min=150.000000,Max=150.000000),Y=(Min=200.000000,Max=200.000000),Z=(Min=200.000000,Max=200.000000))
        InitialParticlesPerSecond=50.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.Impact01'
        LifetimeRange=(Min=2.500000,Max=3.000000)
        InitialDelayRange=(Min=0.150000,Max=0.200000)
        StartVelocityRange=(X=(Min=-100.000000,Max=150.000000),Y=(Min=-100.000000,Max=150.000000),Z=(Min=150.000000,Max=225.000000))
    End Object
    Emitters(10)=BeamEmitter'BeamEmitter5'
}
