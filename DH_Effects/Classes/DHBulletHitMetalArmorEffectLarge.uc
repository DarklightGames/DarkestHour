//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHBulletHitMetalArmorEffectLarge extends Emitter;

var texture SparkGroup[4];
var texture ShrapGroup[4];

//particles: 34

simulated function PostBeginPlay()
{
    Emitters[4].Texture = SparkGroup[Rand(4)];
    Emitters[6].Texture = ShrapGroup[Rand(4)];
    Super.PostBeginPlay();
}

defaultproperties
{
    SparkGroup(0)=Texture'DH_FX_Tex.Sparks.sparks01'
    SparkGroup(1)=Texture'DH_FX_Tex.Sparks.sparks02'
    SparkGroup(2)=Texture'DH_FX_Tex.Sparks.sparks03'
    SparkGroup(3)=Texture'DH_FX_Tex.Sparks.sparks04'

    ShrapGroup(0)=Texture'DH_FX_Tex.debris.shrapnel2'
    ShrapGroup(1)=Texture'DH_FX_Tex.debris.shrapnel3'
    ShrapGroup(2)=Texture'DH_FX_Tex.debris.shrapnel4'
    ShrapGroup(3)=Texture'DH_FX_Tex.debris.shrapnel6'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        MaxParticles=1
        Name="flash"
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=12.000000,Max=16.000000))
        InitialParticlesPerSecond=500.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.Weapons.muzzle_4frame3rd'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.100000,Max=0.100000)
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter5
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        UseRandomSubdivision=True
        UseVelocityScale=True
        Acceleration=(Y=-50.000000,Z=-200.000000)
        ColorScale(0)=(Color=(B=192,G=192,R=192,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.250000
        Opacity=0.35
        MaxParticles=4
        Name="heavy_dust"
        StartLocationRange=(X=(Min=-10.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Min=-5.000000,Max=5.000000))
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.150000,Max=0.250000))
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=2.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=6.0000)
        StartSizeRange=(X=(Min=15.000000,Max=25.000000))
        InitialParticlesPerSecond=20.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.snowfinal2'
        TextureUSubdivisions=2
        TextureVSubdivisions=2//Texture=Texture'DH_FX_Tex.Effects.Impact03'
        LifetimeRange=(Min=2.000000,Max=3.000000)
        StartVelocityRange=(X=(Min=150.000000,Max=350.000000),Y=(Min=-35.000000,Max=45.000000),Z=(Min=-45.000000,Max=35.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter5'

    Begin Object Class=BeamEmitter Name=BeamEmitter3
        BeamDistanceRange=(Min=65.000000,Max=100.000000)
        DetermineEndPointBy=PTEP_Distance
        RotatingSheets=2
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        AutoDestroy=True
        UseSizeScale=True
        UseRegularSizeScale=False
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.6
        MaxParticles=1
        Name="large_exit"
        UseRotationFrom=PTRS_Actor
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=55.000000),Y=(Min=15.000000,Max=20.000000),Z=(Min=15.000000,Max=20.000000))
        InitialParticlesPerSecond=200.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.Impact01'
        LifetimeRange=(Min=0.200000,Max=0.400000)
        StartVelocityRange=(X=(Min=-100.000000,Max=-250.000000),Y=(Min=-20.000000,Max=35.000000),Z=(Min=-35.000000,Max=200.000000))
    End Object
    Emitters(2)=BeamEmitter'BeamEmitter3'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter30
        UseColorScale=true
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=0,G=195,R=255,A=255))
        //Opacity=0.85
        FadeOutStartTime=0.1
        MaxParticles=1
        Name="spark_burst"
        UseRotationFrom=PTRS_Actor
        StartLocationOffset=(X=10.000000)
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000))
        SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.10000))
        SizeScale(0)=(RelativeSize=0.1)
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=1.00000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=2.500000)
        StartSizeRange=(X=(Min=35.000000,Max=50.000000))
        InitialParticlesPerSecond=1000.000000
        DrawStyle=PTDS_Transluscent
        Texture=Texture'DH_FX_Tex.blood.blood_spatter1alt'
        InitialDelayRange=(Min=0.05000,Max=0.100000)
        LifetimeRange=(Min=0.25,Max=0.350000)
        StartVelocityRange=(X=(Min=5.000000,Max=10.000000))
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter30'

    Begin Object Class=BeamEmitter Name=BeamEmitter4
        BeamDistanceRange=(Min=65.000000,Max=85.000000)
        DetermineEndPointBy=PTEP_Distance
        RotatingSheets=1
        UseColorScale=false
        RespawnDeadParticles=False
        AutoDestroy=True
        AutomaticInitialSpawning=False
        //StartLocationOffset=(X=-4.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        MaxParticles=4
        Name="SparkGroups"
        UseRotationFrom=PTRS_Actor
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
        StartSizeRange=(X=(Min=10.000000,Max=15.000000),Y=(Min=10.000000,Max=15.000000),Z=(Min=65.000000))
        InitialParticlesPerSecond=200.000000
        DrawStyle=PTDS_Brighten
        LifetimeRange=(Min=0.100,Max=0.150000)
        StartVelocityRange=(X=(Min=300.000000,Max=600.000000),Y=(Min=-100.000000,Max=125.000000),Z=(Min=-125.000000,Max=100.000000))
    End Object
    Emitters(4)=BeamEmitter'BeamEmitter4'

    Begin Object Class=SparkEmitter Name=SparkEmitter1
        LineSegmentsRange=(Min=0.000000,Max=0.000000)
        TimeBetweenSegmentsRange=(Min=0.030000,Max=0.075000)
        FadeOut=True
        RespawnDeadParticles=False
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.200000
        Name="sparks"
        MaxParticles=8
        UseRotationFrom=PTRS_Actor
        StartSizeRange=(X=(Min=1.000000,Max=3.000000),Y=(Min=1.000000,Max=3.000000),Z=(Min=1.000000,Max=3.000000))
        InitialParticlesPerSecond=5000.000000
        Texture=Texture'Effects_Tex.BulletHits.sparkfinal2'
        LifetimeRange=(Min=0.150000,Max=0.250000)
        StartVelocityRange=(X=(Min=150.000000,Max=300.000000),Y=(Min=-75.000000,Max=75.000000),Z=(Min=-75.000000,Max=75.000000))
    End Object
    Emitters(5)=SparkEmitter'SparkEmitter1'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter18
        UseCollision=true
        UseDirectionAs=PTDU_UpAndNormal
        ProjectionNormal=(X=1.000000,Y=0.500000)
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        DampRotation=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-800.000000)
        DampingFactorRange=(X=(Min=0.150000,Max=0.250000),Y=(Min=0.150000,Max=0.250000),Z=(Min=0.150000,Max=0.250000))
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        //FadeOutStartTime=0.150000
        MaxParticles=15
        Name="shrapnel_spray"
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.70000))
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        RotationDampingFactorRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
        StartSizeRange=(X=(Min=2.000000,Max=4.000))
        InitialParticlesPerSecond=500.000000
        DrawStyle=PTDS_AlphaBlend
        LifetimeRange=(Min=1.50000,Max=1.50000)
        StartVelocityRange=(X=(Min=150.000000,Max=600.000000),Y=(Min=-225.000000,Max=175.000000),Z=(Min=-180.000000,Max=200.000000))
    End Object
    Emitters(6)=SpriteEmitter'SpriteEmitter18'

    Autodestroy=true
    bnodelete=false
}
