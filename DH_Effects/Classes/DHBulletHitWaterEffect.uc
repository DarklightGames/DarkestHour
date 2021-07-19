//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHBulletHitWaterEffect extends emitter;

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
        name="water_ring"
        UseRotationFrom=PTRS_Actor
        SpinCCWorCW=(X=0.000000,Y=0.000000,Z=0.000000)
        SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=2.500000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=4.000000)
        StartSizeRange=(X=(Min=15.000000,Max=20.000000),Y=(Min=15.000000,Max=20.000000),Z=(Min=15.000000,Max=20.000000))
        InitialParticlesPerSecond=100.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.BulletHits.waterring_2frame'
        TextureUSubdivisions=2
        TextureVSubdivisions=1
        SubdivisionScale(0)=0.500000
        LifetimeRange=(Min=1.000000,Max=1.500000)
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter24'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter27
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
        Acceleration=(Z=-600.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.15
        MaxParticles=3
        UseRotationFrom=PTRS_Actor
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=2.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=5.000000)
        StartSizeRange=(X=(Min=5.500000,Max=7.000000))
        InitialParticlesPerSecond=500.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.watersplashcloud'
        LifetimeRange=(Min=0.50,Max=0.75)
        StartVelocityRange=(X=(Min=75.000000,Max=150.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-10.000000,Max=10.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.205000,RelativeVelocity=(X=0.100000,Y=0.500000,Z=0.500000))
        VelocityScale(2)=(RelativeTime=1.000000,RelativeVelocity=(X=0.150000,Y=0.100000,Z=0.100000))
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter27'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter28
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(Z=-1000.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.500000
        FadeOutStartTime=0.25
        MaxParticles=100
        name="drops"
        UseRotationFrom=PTRS_Actor
        StartSizeRange=(X=(Min=0.500000,Max=0.750000))
        InitialParticlesPerSecond=300.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.Smoke.Sparks'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.8,Max=1.000000)
        StartVelocityRange=(X=(Min=100.000000,Max=500.000000),Y=(Min=-75.000000,Max=75.000000),Z=(Min=-75.000000,Max=75.000000))
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter28'

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
    Emitters(3)=SpriteEmitter'SpriteEmitter29'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter30
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
        Acceleration=(Z=-500.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.25
        MaxParticles=3
        StartLocationRange=(X=(Min=-10.000000,Max=10.000000))
        UseRotationFrom=PTRS_Actor
        StartSpinRange=(X=(Min=0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=2.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
        StartSizeRange=(X=(Min=3.000000,Max=5.000000))
        InitialParticlesPerSecond=500.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.watersplashcloud'
        LifetimeRange=(Min=0.75,Max=0.9)
        StartVelocityRange=(X=(Min=250.000000,Max=300.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-10.000000,Max=10.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.205000,RelativeVelocity=(X=0.100000,Y=0.500000,Z=0.500000))
        VelocityScale(2)=(RelativeTime=1.000000,RelativeVelocity=(X=0.150000,Y=0.100000,Z=0.100000))
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter30'

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
    Emitters(5)=SpriteEmitter'SpriteEmitter31'

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
        LifetimeRange=(Min=0.750000,Max=0.750000)
        StartVelocityRange=(X=(Min=50.000000,Max=200.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-10.000000,Max=10.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(6)=SpriteEmitter'SpriteEmitter32'

    Begin Object Class=BeamEmitter Name=BeamEmitter5
        BeamDistanceRange=(Min=85.000000,Max=150.000000)
        DetermineEndPointBy=PTEP_Distance
        RotatingSheets=1
        FadeOut=True
        RespawnDeadParticles=False
        AutoDestroy=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        ColorScale(0)=(Color=(B=128,G=128,R=128,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=200,G=200,R=200,A=255))
        Opacity=0.5
        FadeOutStartTime=0.150000
        MaxParticles=1
        name="main_impact"
        StartLocationOffset=(X=-5.000000)
        UseRotationFrom=PTRS_Actor
        StartSizeRange=(X=(Min=20.000000,Max=25.000000),Y=(Min=20.000000,Max=25.000000),Z=(Min=85.000000))
        InitialParticlesPerSecond=50.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DH_FX_Tex.Effects.WaterImpact01'
        LifetimeRange=(Min=0.500000,Max=0.750000)
        StartVelocityRange=(X=(Min=300.000000,Max=500.000000),Y=(Min=-5.000000,Max=8.000000),Z=(Min=-8.000000,Max=5.000000))
    End Object
    Emitters(7)=BeamEmitter'BeamEmitter5'

    Autodestroy=true
    bnodelete=false
}
