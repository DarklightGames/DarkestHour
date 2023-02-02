//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHBulletHitSandEffect extends emitter;

var texture Impacts[4];

simulated function PostBeginPlay()
{
    Emitters[0].Texture = Impacts[Rand(4)];
    Super.PostBeginPlay();
}

defaultproperties
{
    Impacts(0)=Texture'DH_FX_Tex.Effects.MudImpact01'
    Impacts(1)=Texture'DH_FX_Tex.Effects.MudImpact02'
    Impacts(2)=Texture'DH_FX_Tex.Effects.MudImpact03'
    Impacts(3)=Texture'DH_FX_Tex.Effects.MudImpact04'

    Begin Object Class=BeamEmitter Name=BeamEmitter4
        FadeOut=true
        BeamDistanceRange=(Min=20.000000,Max=35.000000)
        DetermineEndPointBy=PTEP_Distance
        RotatingSheets=2
        UseColorScale=True
        RespawnDeadParticles=False
        AutoDestroy=True
        AutomaticInitialSpawning=False
        StartLocationOffset=(X=-4.000000)
        ColorScale(0)=(Color=(B=108,G=158,R=174,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=148,G=198,R=214,A=255))
        FadeOutStartTime=0.1
        Opacity=0.5
        MaxParticles=1
        name="impact1"
        UseRotationFrom=PTRS_Actor
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
        StartSizeRange=(X=(Min=20.000000,Max=25.000000),Y=(Min=20.000000,Max=25.000000),Z=(Min=20.000000))
        InitialParticlesPerSecond=200.000000
        DrawStyle=PTDS_Brighten
        LifetimeRange=(Min=0.150000,Max=0.250000)
        StartVelocityRange=(X=(Min=300.000000,Max=600.000000),Y=(Min=-75.000000,Max=85.000000),Z=(Min=-85.000000,Max=75.000000))
    End Object
    Emitters(0)=BeamEmitter'BeamEmitter4'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter27
        UseDirectionAs=PTDU_Normal
        UseColorScale=True
        RespawnDeadParticles=False
        SpinParticles=True
        DampRotation=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-10.000000)
        DampingFactorRange=(X=(Min=0.150000,Max=0.250000),Y=(Min=0.150000,Max=0.250000),Z=(Min=0.150000,Max=0.250000))
        ColorScale(0)=(Color=(B=189,G=215,R=223,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=189,G=215,R=223,A=255))
        MaxParticles=3
        name="ground_chunks"
        //StartLocationOffset=(X=5.000000)
        UseRotationFrom=PTRS_Normal
        SpinsPerSecondRange=(X=(Min=0.050000,Max=0.100000))
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        RotationDampingFactorRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
        RotationNormal=(Z=1.000000)
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
        StartSizeRange=(X=(Min=10.000000,Max=12.000000))
        InitialParticlesPerSecond=1000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.debris.genericchunks'
        LifetimeRange=(Min=0.150000,Max=0.300000)
        StartVelocityRange=(Y=(Min=-10.000000,Max=12.000000),Z=(Min=-10.000000,Max=12.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter27'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter39
        UseColorScale=True
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        AutoDestroy=true
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(X=20.000000,Y=50.000000)
        ColorScale(0)=(Color=(B=189,G=215,R=223,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=189,G=215,R=223,A=255))
        Opacity=0.5
        FadeOutStartTime=0.2500000
        FadeInEndTime=0.1
        MaxParticles=4
        name="dustcloud"
        StartLocationOffset=(Z=-25.000000)
        UseRotationFrom=PTRS_Actor
        StartLocationRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000))
        RotationOffset=(Pitch=728,Yaw=4733,Roll=13107)
        SpinCCWorCW=(Y=1.000000,Z=1.000000)
        SpinsPerSecondRange=(X=(Min=0.025000,Max=0.050000),Y=(Max=0.100000),Z=(Min=1.000000,Max=1.000000))
        StartSpinRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=16000.000000,Max=20000.000000),Z=(Min=9000.000000,Max=12000.000000))
        SizeScale(1)=(RelativeTime=1.00,RelativeSize=3.000000)
        StartSizeRange=(X=(Min=25.000000,Max=35.000000),Y=(Min=25.000000,Max=35.000000),Z=(Min=75.000000,Max=150.000000))
        InitialParticlesPerSecond=50.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.LSmoke1'
        LifetimeRange=(Min=1.000000,Max=1.500000)
        StartVelocityRange=(X=(Min=25.000000,Max=50.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=-20.0,Max=20.000000))
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter39'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter44
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseVelocityScale=True
        Acceleration=(Y=-50.000000,Z=-300.000000)
        ColorScale(0)=(Color=(B=189,G=215,R=223,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=189,G=215,R=223,A=255))
        Opacity=0.8
        FadeOutStartTime=0.140000
        MaxParticles=4
        name="light_dust"
        StartLocationRange=(X=(Min=-10.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Min=-5.000000,Max=5.000000))
        UseRotationFrom=PTRS_Actor
        StartSpinRange=(X=(Min=0.600000,Max=0.800000))
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=3.250000)
        StartSizeRange=(X=(Min=20.000000,Max=35.000000))
        InitialParticlesPerSecond=20.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.Impact03'
        LifetimeRange=(Min=0.510000,Max=1.000000)
        StartVelocityRange=(X=(Min=150.000000,Max=425.000000),Y=(Min=-10.000000,Max=15.000000),Z=(Min=-15.000000,Max=10.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter44'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter40
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseVelocityScale=True
        Acceleration=(Z=-300.000000)
        ColorScale(0)=(Color=(B=65,G=86,R=95,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=87,G=109,R=130,A=255))
        Opacity=0.6
        FadeOutStartTime=0.140000
        MaxParticles=1
        name="dark_dust"
        StartLocationOffset=(X=10.000000)
        SphereRadiusRange=(Min=15.000000,Max=20.000000)
        UseRotationFrom=PTRS_Actor
        StartSpinRange=(X=(Min=0.650000,Max=0.750000))
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=2.500000)
        StartSizeRange=(X=(Min=10.000000,Max=55.000000))
        InitialParticlesPerSecond=30.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.Impact01'
        LifetimeRange=(Min=0.510000,Max=1.000000)
        StartVelocityRange=(X=(Min=100.000000,Max=350.000000),Y=(Min=-10.000000,Max=15.000000),Z=(Min=-15.000000,Max=10.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter40'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter18
        FadeOut=true
        UseColorScale=True
        RespawnDeadParticles=False
        SpinParticles=True
        DampRotation=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Y=20.0,Z=-800.000000)
        ColorScale(0)=(Color=(B=108,G=158,R=174,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=148,G=198,R=214,A=255))
        ColorScaleRepeats=4.000000
        Opacity=0.5
        FadeOutStartTime=0.35
        MaxParticles=10 //15
        name="fine_grains"
        StartLocationOffset=(X=10.000000)
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.250000))
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        RotationDampingFactorRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.500000)
        StartSizeRange=(X=(Min=5.000000,Max=12.000000))
        InitialParticlesPerSecond=600.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'DH_FX_Tex.debris.chunksparselite'
        InitialDelayRange=(Min=0.10000,Max=0.150000)
        LifetimeRange=(Min=0.450000,Max=0.75000)
        StartVelocityRange=(X=(Min=250.000000,Max=350.000000),Y=(Min=-100.000000,Max=75.000000),Z=(Min=-80.000000,Max=125.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(5)=SpriteEmitter'SpriteEmitter18'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter88
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(Z=-500.0)
        ColorScale(0)=(Color=(B=108,G=158,R=174,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=148,G=198,R=214,A=255))
        FadeOutStartTime=0.10000
        Opacity=0.6
        MaxParticles=4
        name="ground_splash"
        StartLocationRange=(X=(Min=-5.000000,Max=5.000000))
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.150000))
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
        StartSizeRange=(X=(Min=8.000000,Max=10.000000))
        InitialParticlesPerSecond=500.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.snowfinal'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.150000,Max=0.3500000)
        StartVelocityRange=(X=(Min=5.000000,Max=75.000000),Y=(Min=-35.000000,Max=40.000000),Z=(Min=-35.000000,Max=40.000000))
    End Object
    Emitters(6)=SpriteEmitter'SpriteEmitter88'

    Autodestroy=true
    bnodelete=false
}
