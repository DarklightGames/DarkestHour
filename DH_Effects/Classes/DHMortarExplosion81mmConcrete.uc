//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMortarExplosion81mmConcrete extends DHMortarExplosion;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter47
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
        MaxParticles=2
        name="main_flash"
        StartLocationOffset=(Z=15.000000)
        StartLocationRange=(X=(Min=-15.000000,Max=15.000000),Y=(Min=-15.000000,Max=15.000000),Z=(Min=0.000000,Max=50.000000))
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=1.00000)
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
    Emitters(0)=SpriteEmitter'SpriteEmitter47'

    Begin Object Class=SparkEmitter Name=SparkEmitter8
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
        name="side_sparks"
        StartLocationOffset=(Z=10.000000)
        InitialParticlesPerSecond=500.000000
        Texture=Texture'Effects_Tex.explosions.fire_quad'
        LifetimeRange=(Min=0.200000,Max=0.750000)
        StartVelocityRange=(X=(Min=-1550.000000,Max=1700.000000),Y=(Min=-1625.000000,Max=1750.000000),Z=(Min=-100.000000,Max=350.000000))
        VelocityLossRange=(Z=(Min=1.000000,Max=3.000000))
    End Object
    Emitters(1)=SparkEmitter'SparkEmitter8'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter49
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
        MaxParticles=50
        name="floating_sparks"
        StartLocationOffset=(Z=40.000000)
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
    Emitters(2)=SpriteEmitter'SpriteEmitter49'

    Begin Object Class=SparkEmitter Name=SparkEmitter9
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
        MaxParticles=15
        name="upward_sparks"
        StartSizeRange=(X=(Min=80.000000),Y=(Min=80.000000),Z=(Min=80.000000))
        InitialParticlesPerSecond=500.000000
        Texture=Texture'Effects_Tex.explosions.fire_quad'
        LifetimeRange=(Min=0.200000,Max=0.750000)
        StartVelocityRange=(X=(Min=-500.000000,Max=550.000000),Y=(Min=-555.000000,Max=600.000000),Z=(Min=200.000000,Max=1000.000000))
        VelocityLossRange=(Z=(Min=1.000000,Max=3.000000))
    End Object
    Emitters(3)=SparkEmitter'SparkEmitter9'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter50
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(G=128,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=213,G=234,R=255,A=255))
        MaxParticles=1
        name="flash_halo"
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=1.00000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=4.000000)
        StartSizeRange=(X=(Min=120.000000,Max=180.000000),Y=(Min=120.000000,Max=180.000000),Z=(Min=120.000000,Max=180.000000))
        InitialParticlesPerSecond=1000.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'SpecialEffects.Flares.SoftFlare'
        LifetimeRange=(Min=0.400000,Max=0.500000)
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter50'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter51
        UseDirectionAs=PTDU_Normal
        ProjectionNormal=(X=1.000000,Z=0.500000)
        RespawnDeadParticles=False
        SpinParticles=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(Z=-600.000000)
        ColorScale(0)=(Color=(B=61,G=82,R=84,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=96,G=111,R=115,A=255))
        ColorScaleRepeats=4.000000
        MaxParticles=30
        name="large_chunks"
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.750000))
        StartSpinRange=(X=(Max=0.500000))
        StartSizeRange=(X=(Min=5.000000,Max=18.000000),Y=(Min=5.000000,Max=18.000000),Z=(Min=5.000000,Max=18.000000))
        InitialParticlesPerSecond=500.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.concrete_chunks'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        LifetimeRange=(Max=5.000000)
        StartVelocityRange=(X=(Min=-250.000000,Max=350.000000),Y=(Min=-350.000000,Max=250.000000),Z=(Min=400.000000,Max=1000.000000))
    End Object
    Emitters(5)=SpriteEmitter'SpriteEmitter51'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter52
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
        ColorScale(1)=(RelativeTime=0.050000,Color=(B=63,G=63,R=63,A=255))
        ColorScale(2)=(RelativeTime=1.000000,Color=(B=196,G=196,R=196,A=255))
        FadeOutStartTime=0.500000
        FadeInEndTime=0.200000
        MaxParticles=2
        name="base_smoke"
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
        Texture=Texture'Effects_Tex.explosions.LSmoke1'
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Max=6.000000)
        InitialDelayRange=(Min=0.250000,Max=0.350000)
        StartVelocityRange=(X=(Min=-200.000000,Max=170.000000),Y=(Min=-200.000000,Max=170.000000),Z=(Min=70.000000,Max=150.000000))
        VelocityLossRange=(Z=(Min=3.000000,Max=3.000000))
    End Object
    Emitters(6)=SpriteEmitter'SpriteEmitter52'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter53
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
        Acceleration=(X=-10.000000,Y=-10.000000,Z=-400.000000)
        ColorScale(0)=(Color=(B=128,G=128,R=128,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.700000
        MaxParticles=4
        name="base_light"
        StartLocationRange=(X=(Min=-150.000000,Max=125.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=25.000000,Max=25.000000))
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.150000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
        StartSizeRange=(X=(Max=150.000000),Y=(Max=150.000000),Z=(Max=150.000000))
        InitialParticlesPerSecond=500.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.stonesmokefinal'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=1.500000,Max=1.9500000)
        InitialDelayRange=(Min=0.50000,Max=0.350000)
        StartVelocityRange=(X=(Min=-100.000000,Max=125.000000),Y=(Min=-115.000000,Max=100.000000),Z=(Min=250.000000,Max=350.000000))
    End Object
    Emitters(7)=SpriteEmitter'SpriteEmitter53'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter54
        UseColorScale=True
        FadeOut=false
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-400.000000)
        ColorScale(0)=(Color=(B=192,G=192,R=192,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=192,G=192,R=192,A=255))
        MaxParticles=9
        name="light_gravel"
        StartLocationRange=(X=(Min=-35.000000,Max=35.000000),Y=(Min=-35.000000,Max=35.000000))
        SpinsPerSecondRange=(X=(Min=0.050000,Max=0.10000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
        SizeScale(0)=(RelativeTime=1.000000,RelativeSize=15.000000)
        StartSizeRange=(X=(Min=5.000000,Max=10.000000),Y=(Min=5.000000,Max=10.000000),Z=(Min=5.000000,Max=10.000000))
        InitialParticlesPerSecond=100.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.debris.chunksparselite'
        LifetimeRange=(Min=5.000000,Max=5.000000)
        StartVelocityRange=(X=(Min=-250.000000,Max=250.000000),Y=(Min=-250.000000,Max=250.000000),Z=(Min=100.000000,Max=600.000000))
    End Object
    Emitters(8)=SpriteEmitter'SpriteEmitter54'

    Begin Object Class=BeamEmitter Name=BeamEmitter11
        RotatingSheets=2
        UseColorScale=True
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=128,G=128,R=128,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=196,G=196,R=196,A=255))
        Opacity=0.500000
        FadeOutStartTime=0.870000
        MaxParticles=4
        name="light_spikes"
        StartLocationOffset=(Z=-50.000000)
        StartLocationRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=1.500000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.800000)
        StartSizeRange=(X=(Min=150.000000,Max=200.000000),Y=(Min=150.000000,Max=200.000000),Z=(Min=250.000000,Max=350.000000))
        InitialParticlesPerSecond=15.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.Impact03'
        LifetimeRange=(Min=2.500000,Max=3.000000)
        InitialDelayRange=(Min=0.100000,Max=0.200000)
        StartVelocityRange=(X=(Min=-100.000000,Max=150.000000),Y=(Min=-100.000000,Max=150.000000),Z=(Min=150.000000,Max=225.000000))
    End Object
    Emitters(9)=BeamEmitter'BeamEmitter11'

    Begin Object Class=BeamEmitter Name=BeamEmitter12
        RotatingSheets=2
        UseColorScale=True
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=96,G=96,R=96,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=128,G=128,R=128,A=255))
        Opacity=0.500000
        FadeOutStartTime=0.870000
        FadeInEndTime=0.210000
        MaxParticles=2
        name="dark_spikes"
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
        StartVelocityRange=(X=(Min=-200.000000,Max=250.000000),Y=(Min=-200.000000,Max=250.000000),Z=(Min=250.000000,Max=400.000000))
    End Object
    Emitters(10)=BeamEmitter'BeamEmitter12'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter11
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Y=50.000000,Z=50.000000)
        ColorScale(0)=(Color=(B=129,G=129,R=129,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.35
        FadeOutStartTime=4.0
        MaxParticles=12
        Name="Smoke_pillar"
        StartLocationRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000))
        SpinCCWorCW=(X=1.000000)
        SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=2.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=4.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=6.000000)
        StartSizeRange=(X=(Min=25.000000,Max=75.000000),Y=(Min=25.000000,Max=75.000000),Z=(Min=45.000000,Max=50.000000))
        InitialParticlesPerSecond=500.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.LSmoke1'
        LifetimeRange=(Min=7.000000,Max=8.000000)
        StartVelocityRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=250.000000,Max=1500.000000))
        VelocityLossRange=(Z=(Min=1.000000,Max=3.000000))
    End Object
    Emitters(11)=SpriteEmitter'SpriteEmitter11'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter12
        UseCollision=True
        //UseCollisionPlanes=True
        UseMaxCollisions=True
        UseSpawnedVelocityScale=True
        RespawnDeadParticles=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-1000.000000)
        MaxCollisions=(Min=1.000000,Max=2.000000)
        SpawnedVelocityScaleRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        MaxParticles=12
        SpawnAmount=1
        SpawnFromOtherEmitter=12
        Name="Shrapnel"
        StartLocationRange=(Z=(Min=100.000000,Max=200.000000))
        StartSizeRange=(X=(Min=0.000000,Max=0.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
        LifetimeRange=(Min=0.200000,Max=0.200000)
        StartVelocityRange=(X=(Min=-3000.000000,Max=3000.000000),Y=(Min=-3000.000000,Max=3000.000000),Z=(Min=-3000.000000,Max=3000.000000))
        VelocityLossRange=(X=(Min=3.000000,Max=3.000000),Y=(Min=3.000000,Max=3.000000),Z=(Min=3.000000,Max=3.000000))
    End Object
    Emitters(12)=SpriteEmitter'SpriteEmitter12'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter13
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.400000
        FadeOutStartTime=0.285000
        MaxParticles=12
        Name="ShrapnelImpact"
        SpinsPerSecondRange=(X=(Max=0.050000))
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
        SizeScale(0)=(RelativeTime=1.000000,RelativeSize=15.000000)
        StartSizeRange=(X=(Min=1.000000,Max=2.000000),Y=(Min=1.000000,Max=2.000000),Z=(Min=1.000000,Max=2.000000))
        InitialParticlesPerSecond=2.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.LSmoke1'
        LifetimeRange=(Min=1.500000,Max=1.500000)
        InitialDelayRange=(Min=0.300000,Max=0.400000)
    End Object
    Emitters(13)=SpriteEmitter'SpriteEmitter13'  
}
