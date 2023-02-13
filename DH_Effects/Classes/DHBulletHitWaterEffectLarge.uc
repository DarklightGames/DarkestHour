//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHBulletHitWaterEffectLarge extends emitter;

#exec OBJ LOAD FILE=..\Textures\DH_FX_Tex.utx

//particles:

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter24
        UseDirectionAs=PTDU_Normal
        ProjectionNormal=(X=1.000000,Z=0.000000)
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        DampRotation=True
        UseSizeScale=True
        UseRegularSizeScale=False
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        UseSubdivisionScale=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        MaxParticles=1
        Name="water_ring"
        UseRotationFrom=PTRS_Actor
        SpinCCWorCW=(X=0.000000,Y=0.000000,Z=0.000000)
        SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=2.500000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=4.000000)
        StartSizeRange=(X=(Min=15.000000,Max=20.000000),Y=(Min=15.000000,Max=20.000000),Z=(Min=15.000000,Max=20.000000))
        InitialParticlesPerSecond=100
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.BulletHits.waterring_2frame'
        TextureUSubdivisions=2
        TextureVSubdivisions=1
        SubdivisionScale(0)=0.500000
        //InitialDelayRange=(Min=0.25,Max=0.35)
        LifetimeRange=(Min=1.000000,Max=1.500000)
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter24'

    Begin Object Class=SparkEmitter Name=SparkEmitter0
        LineSegmentsRange=(Min=0.000000,Max=0.000000)
        TimeBetweenSegmentsRange=(Min=0.030000,Max=0.075000)
        FadeOut=True
        RespawnDeadParticles=false
        AutomaticInitialSpawning=False
        Acceleration=(Z=-500.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.25
        FadeOutStartTime=0.35
        MaxParticles=15
        Name="drops"
        InitialParticlesPerSecond=200.000000
        Texture=Texture'Effects_Tex.BulletHits.sparkfinal2'
        LifetimeRange=(Min=0.5,Max=0.75)
        StartVelocityRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=200.000000,Max=600.000000))
    End Object
    Emitters(1)=SparkEmitter'SparkEmitter0'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter29
        FadeOut=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        UseRandomSubdivision=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.600000
        FadeOutStartTime=0.198000
        StartLocationShape=PTLS_Sphere
        UseRotationFrom=PTRS_Actor
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
        StartSizeRange=(X=(Min=15.000000,Max=20.000000))
        InitialParticlesPerSecond=1000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.watersplatter2'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.500000,Max=0.600000)
        StartVelocityRange=(Y=(Min=-50.000000,Max=50.000000),Z=(Min=-50.000000,Max=50.000000))
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter29'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter31
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
        Acceleration=(Z=-250.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.247500
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.150000,Max=0.150000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=15.000000,Max=25.000000))
        InitialParticlesPerSecond=1000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.watersplatter2'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.750000,Max=0.750000)
        StartVelocityRange=(X=(Min=50.000000,Max=100.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-10.000000,Max=10.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter31'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter32
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        UseRandomSubdivision=True
        UseVelocityScale=True
        Acceleration=(Z=-200.0)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        MaxParticles=3
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.050000,Max=0.050000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=10.000000,Max=20.000000))
        InitialParticlesPerSecond=100.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.watersplatter2'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.50000,Max=0.750000)
        StartVelocityRange=(X=(Min=50.000000,Max=200.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-10.000000,Max=10.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter32'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter44
        UseColorScale=false
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseVelocityScale=True
        Acceleration=(X=-50.000000)
        ColorScale(0)=(Color=(B=189,G=215,R=223,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=189,G=215,R=223,A=255))
        FadeOutStartTime=0.250000
        Opacity=0.5
        MaxParticles=1
        Name="mist_plume"
        StartLocationRange=(X=(Min=45.000000,Max=75.000000),Y=(Min=-10.0,Max=10.0),Z=(Min=-10.0,Max=10.0))
        UseRotationFrom=PTRS_Actor
        StartSpinRange=(X=(Min=0.7200000,Max=0.780000))
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=3.500000)
        StartSizeRange=(X=(Min=40.000000,Max=65.000000))
        InitialParticlesPerSecond=200.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.Impact03'
        LifetimeRange=(Min=0.50000,Max=1.000000)
        //InitialDelayRange=(Min=0.15,Max=0.25)
        StartVelocityRange=(X=(Min=350.000000,Max=450.000000),Y=(Min=-10.000000,Max=15.000000),Z=(Min=-15.000000,Max=10.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(5)=SpriteEmitter'SpriteEmitter44'

    Begin Object Class=BeamEmitter Name=BeamEmitter1
        BeamDistanceRange=(Min=150.000000,Max=300.000000)
        DetermineEndPointBy=PTEP_Distance
        RotatingSheets=2
        FadeOut=True
        RespawnDeadParticles=False
        UseSizeScale=True
        AutoDestroy=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        ColorScale(0)=(Color=(B=200,G=200,R=200,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=200,G=200,R=200,A=255))
        FadeOutStartTime=0.150000
        Opacity=0.8
        MaxParticles=1
        Name="impact_spike"
        UseRotationFrom=PTRS_Actor
        SizeScale(0)=(RelativeSize=0.1)
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=2.5000000)
        StartSizeRange=(X=(Min=25.000000,Max=35.000000),Y=(Min=25.000000,Max=35.000000),Z=(Min=150.000000))
        InitialParticlesPerSecond=200.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.Impact03'
        LifetimeRange=(Min=0.200000,Max=0.250000)
        StartVelocityRange=(X=(Min=300.000000,Max=500.000000),Y=(Min=-20.000000,Max=25.000000),Z=(Min=-25.000000,Max=20.000000))
    End Object
    Emitters(6)=BeamEmitter'BeamEmitter1'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter48
        UseColorScale=false
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseVelocityScale=True
        Acceleration=(X=-100.000000,Z=-1200.000000)
        ColorScale(0)=(Color=(B=189,G=215,R=223,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=189,G=215,R=223,A=255))
        Opacity=0.35
        FadeOutStartTime=0.250000
        MaxParticles=1
        Name="mist_plume2"
        StartLocationRange=(X=(Min=25.000000,Max=50.000000),Y=(Min=-10.0,Max=10.0),Z=(Min=-10.0,Max=10.0))
        UseRotationFrom=PTRS_Actor
        StartSpinRange=(X=(Min=0.7200000,Max=0.780000))
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=0.140000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=4.2)
        StartSizeRange=(X=(Min=75.000000,Max=95.000000))
        InitialParticlesPerSecond=200.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.Impact01'
        LifetimeRange=(Min=0.50000,Max=1.250000)
        //InitialDelayRange=(Min=0.10,Max=0.20)
        StartVelocityRange=(X=(Min=350.000000,Max=450.000000),Y=(Min=-10.000000,Max=15.000000),Z=(Min=-15.000000,Max=10.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(7)=SpriteEmitter'SpriteEmitter48'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter7
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        DampRotation=True
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(Z=-800.000000)
        ColorScale(0)=(Color=(B=192,G=192,R=192,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=192,G=192,R=192,A=255))
        FadeOutStartTime=0.500000
        Opacity=0.25
        MaxParticles=20
        Name="big_drops"
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.250000,Max=0.350000))
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        RotationDampingFactorRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
        StartSizeRange=(X=(Min=0.500000,Max=2.000000))
        InitialParticlesPerSecond=200.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.snowchunksfinal'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Max=1.5)
        StartVelocityRange=(X=(Min=150.000000,Max=700.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=-50.000000,Max=50.000000))
    End Object
    Emitters(8)=SpriteEmitter'SpriteEmitter7'

    Autodestroy=true
    bnodelete=false
}
