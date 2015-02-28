//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_TankAPShellShatter extends Emitter;

defaultproperties
{
    Begin Object Class=SparkEmitter Name=SparkEmitter0
        LineSegmentsRange=(Min=1.0,Max=3.0)
        TimeBetweenSegmentsRange=(Min=0.1,Max=0.3)
        FadeOut=true
        RespawnDeadParticles=false
        AutomaticInitialSpawning=false
        Acceleration=(Z=-10.0)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.25
        FadeInEndTime=0.25
        MaxParticles=512
        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Max=1.0)
        UseRotationFrom=PTRS_Actor
        StartSizeRange=(X=(Min=200.0,Max=200.0),Y=(Min=200.0,Max=200.0),Z=(Min=200.0,Max=200.0))
        InitialParticlesPerSecond=65536.0
        Texture=texture'Effects_Tex.BulletHits.sparkfinal2'
        LifetimeRange=(Min=0.2,Max=0.5)
        StartVelocityRange=(X=(Min=-256.0,Max=256.0),Y=(Min=-1024.0,Max=1024.0),Z=(Min=-256.0,Max=256.0))
    End Object
    Emitters(1)=SparkEmitter'DH_Effects.DH_TankAPShellShatter.SparkEmitter0'
    AutoDestroy=true
    bLightChanged=true
    bNoDelete=false
    bNetTemporary=true
    RemoteRole=ROLE_SimulatedProxy
    LifeSpan=4.0
    Style=STY_Masked
    bHardAttach=true
    bDirectional=true
    bSelected=true
}
