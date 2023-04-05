//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHShellSplashEffect extends Emitter; // substantially different was RO equivalent class 'TankAPHitWaterEffect'

defaultproperties
{
    AutoDestroy=true
    bNoDelete=false
    bHighDetail=true

    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        UseDirectionAs=PTDU_Normal
        ProjectionNormal=(X=1.0,Z=0.0)
        FadeOut=true
        FadeIn=true
        RespawnDeadParticles=false
        SpinParticles=true
        DampRotation=true
        UseSizeScale=true
        UseRegularSizeScale=false
        AutomaticInitialSpawning=false
        BlendBetweenSubdivisions=true
        UseSubdivisionScale=true
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        MaxParticles=1
        UseRotationFrom=PTRS_Actor
        SpinCCWorCW=(X=0.0,Y=0.0,Z=0.0)
        SpinsPerSecondRange=(X=(Min=-0.1,Max=0.1))
        SizeScale(0)=(RelativeSize=1.0)
        SizeScale(1)=(RelativeTime=0.5,RelativeSize=2.5)
        SizeScale(2)=(RelativeTime=1.0,RelativeSize=6.0)
        StartSizeRange=(X=(Min=35.0,Max=45.0),Y=(Min=35.0,Max=45.0),Z=(Min=35.0,Max=45.0))
        InitialParticlesPerSecond=100.0
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.BulletHits.waterring_2frame'
        TextureUSubdivisions=2
        TextureVSubdivisions=1
        SubdivisionScale(0)=0.5
        LifetimeRange=(Min=1.0,Max=1.5)
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        FadeOut=true
        FadeIn=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        BlendBetweenSubdivisions=true
        UseRandomSubdivision=true
        UseVelocityScale=true
        Acceleration=(Z=-600.0)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.5
        MaxParticles=6
        UseRotationFrom=PTRS_Actor
        StartSpinRange=(X=(Min=0.5,Max=0.5))
        SizeScale(0)=(RelativeSize=1.0)
        SizeScale(1)=(RelativeTime=1.0,RelativeSize=5.0)
        StartSizeRange=(X=(Min=12.0,Max=12.0),Y=(Min=8.0,Max=10.0),Z=(Min=8.0,Max=10.0))
        InitialParticlesPerSecond=500.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.watersplashcloud'
        LifetimeRange=(Min=1.5,Max=1.5)
        StartVelocityRange=(X=(Min=450.0,Max=700.0),Y=(Min=-5.0,Max=5.0),Z=(Min=-5.0,Max=5.0))
        VelocityScale(0)=(RelativeVelocity=(X=1.0,Y=1.0,Z=1.0))
        VelocityScale(1)=(RelativeTime=0.2,RelativeVelocity=(X=0.1,Y=0.5,Z=0.5))
        VelocityScale(2)=(RelativeTime=1.0,RelativeVelocity=(X=0.1,Y=0.1,Z=0.1))
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter1'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter2
        FadeOut=true
        FadeIn=true
        RespawnDeadParticles=false
        UniformSize=true
        AutomaticInitialSpawning=false
        UseRandomSubdivision=true
        Acceleration=(Z=-500.0)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=100))
        Opacity=0.2
        FadeOutStartTime=0.6
        MaxParticles=16
        UseRotationFrom=PTRS_Actor
        StartSizeRange=(X=(Min=3.0,Max=5.0))
        InitialParticlesPerSecond=300.0
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects_Tex.Smoke.Sparks'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=2.0,Max=2.0)
        StartVelocityRange=(X=(Min=200.0,Max=400.0),Y=(Min=-75.0,Max=75.0),Z=(Min=-75.0,Max=75.0))
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter2'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter3
        FadeOut=true
        FadeIn=true
        RespawnDeadParticles=false
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        BlendBetweenSubdivisions=true
        UseRandomSubdivision=true
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        MaxParticles=2
        UseRotationFrom=PTRS_Actor
        SizeScale(1)=(RelativeTime=1.0,RelativeSize=2.0)
        StartSizeRange=(X=(Min=50.0,Max=60.0))
        InitialParticlesPerSecond=100.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.watersplatter2'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=1.0,Max=1.0)
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter3'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter4
        FadeOut=true
        FadeIn=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        BlendBetweenSubdivisions=true
        UseRandomSubdivision=true
        UseVelocityScale=true
        Acceleration=(Z=-700.0)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.5
        MaxParticles=3
        StartLocationRange=(X=(Min=-10.0,Max=10.0))
        UseRotationFrom=PTRS_Actor
        StartSpinRange=(X=(Min=0.5,Max=0.5))
        SizeScale(0)=(RelativeSize=2.0)
        SizeScale(1)=(RelativeTime=1.0,RelativeSize=5.0)
        StartSizeRange=(X=(Min=12.0,Max=16.0))
        InitialParticlesPerSecond=500.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.watersplashcloud'
        LifetimeRange=(Min=1.5,Max=1.5)
        StartVelocityRange=(X=(Min=250.0,Max=300.0),Y=(Min=-10.0,Max=10.0),Z=(Min=-10.0,Max=10.0))
        VelocityScale(0)=(RelativeVelocity=(X=1.0,Y=1.0,Z=1.0))
        VelocityScale(1)=(RelativeTime=0.205,RelativeVelocity=(X=0.1,Y=0.5,Z=0.5))
        VelocityScale(2)=(RelativeTime=1.0,RelativeVelocity=(X=0.15,Y=0.1,Z=0.1))
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter4'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter5
        FadeOut=true
        FadeIn=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        BlendBetweenSubdivisions=true
        UseRandomSubdivision=true
        UseVelocityScale=true
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        MaxParticles=6
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.15,Max=0.15))
        SizeScale(0)=(RelativeSize=0.5)
        SizeScale(1)=(RelativeTime=1.0,RelativeSize=1.5)
        StartSizeRange=(X=(Min=24.0,Max=32.0))
        InitialParticlesPerSecond=100.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.watersplatter2'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.75,Max=0.75)
        StartVelocityRange=(X=(Min=50.0,Max=100.0),Y=(Min=-10.0,Max=10.0),Z=(Min=-10.0,Max=10.0))
        VelocityScale(0)=(RelativeVelocity=(X=1.0,Y=1.0,Z=1.0))
        VelocityScale(1)=(RelativeTime=0.475,RelativeVelocity=(X=0.1,Y=0.2,Z=0.2))
        VelocityScale(2)=(RelativeTime=1.0)
    End Object
    Emitters(5)=SpriteEmitter'SpriteEmitter5'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter6
        FadeOut=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        Acceleration=(X=-30.0,Y=-30.0,Z=-1000.0)
        ColorScale(0)=(Color=(B=61,G=82,R=84,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=96,G=111,R=115,A=255))
        FadeOutStartTime=1.0
        MaxParticles=12
        SpinsPerSecondRange=(X=(Min=0.05,Max=0.05))
        StartSpinRange=(X=(Min=-0.5,Max=0.5))
        SizeScale(0)=(RelativeTime=1.0,RelativeSize=25.0)
        StartSizeRange=(X=(Min=5.0,Max=10.0),Y=(Min=5.0,Max=10.0),Z=(Min=5.0,Max=10.0))
        InitialParticlesPerSecond=100.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.BulletHits.watersplatter2'
        LifetimeRange=(Min=2.0,Max=2.0)
        StartVelocityRange=(X=(Min=-100.0,Max=100.0),Y=(Min=-100.0,Max=100.0),Z=(Min=500.0,Max=800.0))
    End Object
    Emitters(6)=SpriteEmitter'SpriteEmitter6'
}
