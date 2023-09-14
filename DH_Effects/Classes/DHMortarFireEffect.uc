//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMortarFireEffect extends Emitter;

defaultproperties
{
    AutoDestroy=true
    bNoDelete=false

    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        UseColorScale=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        ColorScale(0)=(Color=(B=255,G=255,R=255))
        ColorScale(1)=(RelativeTime=1.0)
        MaxParticles=1
        DetailMode=DM_SuperHigh
        StartLocationShape=PTLS_Sphere
        StartSpinRange=(X=(Max=1.0))
        SizeScale(0)=(RelativeSize=0.15)
        SizeScale(1)=(RelativeTime=0.75,RelativeSize=0.5)
        StartSizeRange=(X=(Max=60.0))
        InitialParticlesPerSecond=5000.0
        Texture=Texture'Effects_Tex.BulletHits.glowfinal'
        LifetimeRange=(Min=0.25,Max=0.35)
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        UseColorScale=true
        FadeOut=true
        FadeIn=true
        RespawnDeadParticles=false
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        ColorScale(0)=(Color=(B=174,G=228,R=255,A=255))
        ColorScale(1)=(RelativeTime=0.2,Color=(B=255,G=255,R=255,A=255))
        ColorScale(2)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        ColorScale(3)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        ColorScale(4)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.1025
        FadeInEndTime=0.05
        MaxParticles=1
        SizeScale(1)=(RelativeTime=0.25,RelativeSize=0.25)
        SizeScale(2)=(RelativeTime=1.0,RelativeSize=0.5)
        InitialParticlesPerSecond=30.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.radialexplosion_1frame'
        LifetimeRange=(Min=0.25,Max=0.25)
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter1'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter2
        FadeOut=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        UseRandomSubdivision=true
        Acceleration=(X=25.0,Y=25.0)
        ColorScale(0)=(Color=(B=95,G=95,R=95,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=150,G=150,R=150))
        Opacity=0.75
        FadeOutStartTime=0.78
        MaxParticles=16
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Max=0.125))
        StartSpinRange=(X=(Max=1.0))
        SizeScale(1)=(RelativeTime=1.0,RelativeSize=1.0)
        StartSizeRange=(X=(Min=32.0,Max=64.0),Y=(Min=32.0,Max=64.0),Z=(Min=32.0,Max=64.0))
        InitialParticlesPerSecond=62500.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.DSmoke_2'
        LifetimeRange=(Min=1.0,Max=3.0)
        StartVelocityRange=(X=(Min=32.0,Max=320.0))
        VelocityLossRange=(X=(Max=5.0),Y=(Max=5.0),Z=(Max=5.0))
        VelocityScale(0)=(RelativeVelocity=(X=1.0,Y=1.0,Z=1.0))
        VelocityScale(1)=(RelativeTime=0.125,RelativeVelocity=(X=0.2,Y=0.2,Z=0.2))
        VelocityScale(2)=(RelativeTime=1.0)
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter2'
}
