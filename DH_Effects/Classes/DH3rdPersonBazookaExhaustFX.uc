//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH3rdPersonBazookaExhaustFX extends Emitter;

defaultproperties
{
    AutoDestroy=true
    bLightChanged=true
    bNoDelete=false
    LifeSpan=8.0
    Style=STY_Masked
    bHardAttach=true

    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        UseColorScale=true
        FadeOut=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        Acceleration=(X=10.0)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=3.0
        StartLocationOffset=(X=-70.0)
        StartLocationShape=PTLS_Sphere
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.05,Max=0.1))
        StartSpinRange=(X=(Min=-0.5,Max=0.5),Y=(Min=0.5,Max=1.0),Z=(Min=0.5,Max=1.0))
        SizeScale(0)=(RelativeTime=1.0,RelativeSize=20.0)
        StartSizeRange=(X=(Min=30.0,Max=45.0),Y=(Min=30.0,Max=45.0),Z=(Min=30.0,Max=45.0))
        InitialParticlesPerSecond=5000.0
        DrawStyle=PTDS_AlphaBlend
        Texture=texture'Effects_Tex.explosions.DSmoke_2'
        LifetimeRange=(Min=8.0,Max=12.0)
        StartVelocityRange=(X=(Min=-100.0,Max=-20.0),Y=(Min=-2.0,Max=-5.0),Z=(Min=-2.0,Max=5.0))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        UseColorScale=true
        FadeOut=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=3.0
        StartLocationOffset=(X=-40.0)
        StartLocationShape=PTLS_Sphere
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.05,Max=0.1))
        StartSpinRange=(X=(Min=-0.5,Max=0.5),Y=(Min=0.5,Max=1.0),Z=(Min=0.5,Max=1.0))
        SizeScale(0)=(RelativeTime=1.0,RelativeSize=8.0)
        StartSizeRange=(X=(Min=3.0,Max=5.0),Y=(Min=3.0,Max=5.0),Z=(Min=3.0,Max=5.0))
        InitialParticlesPerSecond=5000.0
        DrawStyle=PTDS_AlphaBlend
        Texture=texture'Effects_Tex.explosions.DSmoke_2'
        LifetimeRange=(Min=0.5,Max=1.0)
        StartVelocityRange=(X=(Min=-300.0,Max=-200.0),Y=(Min=-2.0,Max=-5.0),Z=(Min=-2.0,Max=5.0))
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter1'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter2
        UseColorScale=true
        FadeOut=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        Acceleration=(X=100.0)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.5
        FadeOutStartTime=0.098
        FadeInEndTime=0.08
        StartLocationOffset=(X=-40.0)
        StartLocationShape=PTLS_Sphere
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.05,Max=0.1))
        StartSpinRange=(X=(Min=-0.5,Max=0.5),Y=(Min=0.5,Max=1.0),Z=(Min=0.5,Max=1.0))
        SizeScale(0)=(RelativeTime=1.0,RelativeSize=8.0)
        StartSizeRange=(X=(Min=3.0,Max=5.0),Y=(Min=3.0,Max=5.0),Z=(Min=3.0,Max=5.0))
        InitialParticlesPerSecond=5000.0
        DrawStyle=PTDS_Brighten
        Texture=texture'Effects_Tex.explosions.impact_2frame'
        TextureUSubdivisions=2
        TextureVSubdivisions=1
        LifetimeRange=(Min=0.2,Max=0.3)
        StartVelocityRange=(X=(Min=-200.0),Y=(Min=-20.0,Max=20.0),Z=(Min=-20.0,Max=20.0))
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter2'
}
