//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHHorizonArtillery extends Emitter;

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
        Opacity=0.7
        MaxParticles=1
        DetailMode=DM_SuperHigh
        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Min=16.0,Max=32.0)
        StartSpinRange=(X=(Max=1.0))
        SizeScale(0)=(RelativeSize=0.75)
        SizeScale(1)=(RelativeTime=1.0,RelativeSize=1.75)
        StartSizeRange=(X=(Max=150.0))
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
        MaxParticles=3
        SizeScale(1)=(RelativeTime=0.25,RelativeSize=1.0)
        SizeScale(2)=(RelativeTime=1.0,RelativeSize=2.0)
        StartSizeRange=(X=(Min=50.0,Max=50.0),Y=(Min=50.0,Max=50.0),Z=(Min=50.0,Max=50.0))
        InitialParticlesPerSecond=30.0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.radialexplosion_1frame'
        LifetimeRange=(Min=0.25,Max=0.25)
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter1'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter2
        UseColorScale=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        UseRandomSubdivision=true
        ColorScale(0)=(Color=(B=255,G=255,R=255))
        ColorScale(1)=(RelativeTime=1.0)
        MaxParticles=2
        UseRotationFrom=PTRS_Actor
        StartSpinRange=(X=(Max=1.0))
        SizeScale(0)=(RelativeSize=1.0)
        SizeScale(1)=(RelativeTime=1.0,RelativeSize=3.0)
        StartSizeRange=(X=(Min=10.0,Max=10.0))
        InitialParticlesPerSecond=5000.0
        Texture=Texture'Effects_Tex.Weapons.muzzle_4frame3rd'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.1,Max=0.2)
        StartVelocityRange=(X=(Min=20.0,Max=25.0))
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter2'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter3
        UseColorScale=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        UseRandomSubdivision=true
        ColorScale(0)=(Color=(B=255,G=255,R=255))
        ColorScale(1)=(RelativeTime=1.0)
        MaxParticles=1
        StartLocationOffset=(X=10.0)
        StartLocationRange=(X=(Max=10.0))
        UseRotationFrom=PTRS_Actor
        StartSpinRange=(X=(Max=1.0))
        SizeScale(0)=(RelativeSize=1.0)
        SizeScale(1)=(RelativeTime=1.0,RelativeSize=2.0)
        StartSizeRange=(X=(Min=10.0,Max=10.0))
        InitialParticlesPerSecond=5000.0
        Texture=Texture'Effects_Tex.Weapons.muzzle_4frame3rd'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.2,Max=0.2)
        StartVelocityRange=(X=(Min=60.0,Max=75.0))
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter3'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter4
        UseColorScale=true
        RespawnDeadParticles=false
        SpinParticles=true
        UseSizeScale=true
        UseRegularSizeScale=false
        UniformSize=true
        AutomaticInitialSpawning=false
        UseRandomSubdivision=true
        ColorScale(0)=(Color=(B=255,G=255,R=255))
        ColorScale(1)=(RelativeTime=1.0)
        MaxParticles=1
        StartLocationOffset=(X=30.0)
        StartLocationRange=(X=(Max=10.0))
        UseRotationFrom=PTRS_Actor
        StartSpinRange=(X=(Max=1.0))
        SizeScale(0)=(RelativeSize=1.0)
        SizeScale(1)=(RelativeTime=1.0,RelativeSize=2.0)
        StartSizeRange=(X=(Min=5.0,Max=5.0))
        InitialParticlesPerSecond=5000.0
        Texture=Texture'Effects_Tex.Weapons.muzzle_4frame3rd'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.1,Max=0.2)
        StartVelocityRange=(X=(Min=20.0,Max=25.0))
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter4'
}
