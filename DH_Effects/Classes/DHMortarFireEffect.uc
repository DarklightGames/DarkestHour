//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMortarFireEffect extends Emitter;

simulated function PostBeginPlay()
{
    if (!Level.bDropDetail)
    {
        bDynamicLight = true;
        SetTimer(0.15, false);
    }
    
    LightBrightness = RandRange(96, 150);
    Super.PostBeginPlay();
}

simulated function Timer()
{
    bDynamicLight = false;
}

defaultproperties
{
    AutoDestroy=true
    bNoDelete=false
    
    //bDynamicLight=true
    bMovable=true

    LightEffect=LE_NonIncidence
    LightType=LT_Steady
    //LightBrightness = 96.0
    LightRadius = 6.0
    LightHue = 20
    LightSaturation = 28
    AmbientGlow = 254
    LightCone = 8

    Begin Object Class=SpriteEmitter Name=SpriteEmitter21
        UseColorScale=True
        RespawnDeadParticles=False
        Backup_Disabled=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=255,G=255,R=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=64,G=128,R=255))
        Opacity=0.250000
        MaxParticles=1
        name="barrel_flare"
        DetailMode=DM_SuperHigh
        StartLocationShape=PTLS_Sphere
        StartSpinRange=(X=(Max=1.000000))
        SizeScale(0)=(RelativeSize=0.150000)
        SizeScale(1)=(RelativeTime=0.750000,RelativeSize=0.500000)
        StartSizeRange=(X=(Max=60.000000))
        InitialParticlesPerSecond=5000.000000
        Texture=Texture'SpecialEffects.Coronas.Corona2'
        LifetimeRange=(Min=0.150000,Max=0.200000)
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter21'

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
        name="muzzle_smoke"
        SizeScale(1)=(RelativeTime=0.250000,RelativeSize=0.250000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=0.500000)
        InitialParticlesPerSecond=30.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.radialexplosion_1frame'
        LifetimeRange=(Min=0.250000,Max=0.250000)
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter31'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter32
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
        MaxParticles=14
        name="smoke"
        StartLocationOffset=(X=50.000000)
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Max=0.125000))
        StartSpinRange=(X=(Max=1.000000))
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=32.000000,Max=64.000000),Y=(Min=32.000000,Max=64.000000),Z=(Min=32.000000,Max=64.000000))
        InitialParticlesPerSecond=1000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.DSmoke_2'
        LifetimeRange=(Min=1.000000,Max=3.000000)
        StartVelocityRange=(X=(Min=32.000000,Max=320.000000))
        VelocityLossRange=(X=(Max=2.000000),Y=(Max=2.000000),Z=(Max=2.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.125000,RelativeVelocity=(X=0.200000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter32'

    Begin Object Class=BeamEmitter Name=BeamEmitter6
        BeamDistanceRange=(Min=30.000000,Max=100.000000)
        DetermineEndPointBy=PTEP_Distance
        RotatingSheets=2
        FadeOut=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=200,G=200,R=200,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=200,G=200,R=200,A=255))
        Opacity=0.390000
        FadeOutStartTime=0.050000
        MaxParticles=1
        name="flash"
        StartLocationOffset=(X=-6.000000)
        UseRotationFrom=PTRS_Actor
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=2.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=0.500000)
        StartSizeRange=(X=(Min=10.000000,Max=20.000000),Y=(Min=10.000000,Max=20.000000),Z=(Min=30.000000,Max=90.000000))
        InitialParticlesPerSecond=100.000000
        Texture=Texture'Effects_Tex.explosions.fire_quad' //'DH_FX_Tex.Weapons.50calmuzzleflash'
        LifetimeRange=(Min=0.150000,Max=0.200000)
        StartVelocityRange=(X=(Min=50.000000,Max=100.000000))
    End Object
    Emitters(3)=BeamEmitter'BeamEmitter6'

    Begin Object Class=BeamEmitter Name=BeamEmitter7
        BeamDistanceRange=(Min=250.000000,Max=300.000000)
        DetermineEndPointBy=PTEP_Distance
        RotatingSheets=2
        FadeOut=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=200,G=200,R=200,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=200,G=200,R=200,A=255))
        Opacity=0.4
        FadeOutStartTime=0.050000
        MaxParticles=1
        name="smoke_spike"
        StartLocationOffset=(X=-8.000000)
        UseRotationFrom=PTRS_Actor
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=2.500000)
        StartSizeRange=(X=(Min=10.000000,Max=20.000000),Y=(Min=10.000000,Max=20.000000),Z=(Min=200.000000,Max=300.000000))
        InitialParticlesPerSecond=100.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.Impact03'
        LifetimeRange=(Min=0.150000,Max=0.200000)
        StartVelocityRange=(X=(Min=50.000000,Max=100.000000))
    End Object
    Emitters(4)=BeamEmitter'BeamEmitter7'

    Begin Object Class=SparkEmitter Name=SparkEmitter0
        LineSegmentsRange=(Min=1.000000,Max=1.000000)
        TimeBeforeVisibleRange=(Min=0.100000,Max=0.100000)
        TimeBetweenSegmentsRange=(Min=0.050000,Max=0.100000)
        UseColorScale=True
        RespawnDeadParticles=False
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=0.382143,Color=(B=64,G=128,R=255,A=255))
        ColorScale(2)=(RelativeTime=1.000000,Color=(R=255,A=255))
        name="sparks"
        UseRotationFrom=PTRS_Actor
        StartLocationRange=(X=(Max=100.000000))
        InitialParticlesPerSecond=100.000000
        Texture=Texture'DH_FX_Tex.Weapons.pistolflash'
        LifetimeRange=(Min=0.150000,Max=0.250000)
        StartVelocityRange=(X=(Min=50.000000,Max=300.000000),Y=(Min=-75.000000,Max=75.000000),Z=(Min=-75.000000,Max=75.000000))
    End Object
    Emitters(5)=SparkEmitter'SparkEmitter0'
}
