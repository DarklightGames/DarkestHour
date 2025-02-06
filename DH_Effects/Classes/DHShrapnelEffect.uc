//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHShrapnelEffect extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter6         //invisible shrapnel projectiles that create collisions in the environment that allow the emitter below to spawn at those locations.
        UseCollision=True
        UseCollisionPlanes=True
        UseMaxCollisions=True
        UseSpawnedVelocityScale=True
        RespawnDeadParticles=False
        UniformSize=True
        Acceleration=(Z=-1000.000000)
        MaxCollisions=(Min=1.000000,Max=2.000000)
        SpawnFromOtherEmitter=6
        SpawnAmount=1
        SpawnedVelocityScaleRange=(X=(Min=-7.000000,Max=7.000000),Y=(Min=-7.000000,Max=7.000000),Z=(Min=-7.000000,Max=7.000000))
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        MaxParticles=20 //Was 12
      
        StartLocationRange=(Z=(Min=100.000000,Max=200.000000))
        StartSizeRange=(X=(Min=0.000000,Max=0.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
        LifetimeRange=(Min=0.500000,Max=0.70000) // was 0.2
        StartVelocityRange=(X=(Min=-3000.000000,Max=3000.000000),Y=(Min=-3000.000000,Max=3000.000000),Z=(Min=-3000.000000,Max=3000.000000))
        VelocityLossRange=(X=(Min=3.000000,Max=3.000000),Y=(Min=3.000000,Max=3.000000),Z=(Min=3.000000,Max=3.000000))
    End Object
    Emitters(5)=SpriteEmitter'SpriteEmitter6'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter7         //Shrapnel hit effects, the smoke that appears on the impact of the above sprite
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.450000
        FadeOutStartTime=0.285000
        MaxParticles=20 //Was 12
      
        SpinsPerSecondRange=(X=(Max=0.050000))
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
        SizeScale(0)=(RelativeTime=1.000000,RelativeSize=15.000000)
        StartSizeRange=(X=(Min=1.000000,Max=2.000000),Y=(Min=1.000000,Max=2.000000),Z=(Min=1.000000,Max=2.000000))
        InitialParticlesPerSecond=0
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Effects_Tex.explosions.LSmoke1'
        LifetimeRange=(Min=1.500000,Max=1.500000)
        InitialDelayRange=(Min=0.0,Max=0.0) // was 0.3 to 0.4
    End Object
    Emitters(6)=SpriteEmitter'SpriteEmitter7'

    AutoDestroy=True
    bNoDelete=False
}
