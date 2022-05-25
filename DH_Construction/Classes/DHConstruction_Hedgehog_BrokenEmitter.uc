//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHConstruction_Hedgehog_BrokenEmitter extends Emitter;

defaultproperties
{
    Begin Object Class=MeshEmitter Name=MeshEmitter0
        StaticMesh=StaticMesh'DH_Construction_stc.Obstacles.hedgehog_01_destro_element'
        UseCollision=false
        RespawnDeadParticles=false
        SpinParticles=true
        DampRotation=true
        AutomaticInitialSpawning=false
        Acceleration=(Z=-1000.0)
        DampingFactorRange=(X=(Min=0.2,Max=0.5),Y=(Min=0.2,Max=0.5),Z=(Min=0.2,Max=0.5))
        MaxCollisions=(Max=2.0)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        MaxParticles=3
        Name="MeshEmitter0"
        SpinsPerSecondRange=(X=(Min=-1.0,Max=1.0),Y=(Min=-1.0,Max=1.0),Z=(Min=-1.0,Max=1.0))
        StartSpinRange=(X=(Min=-1.0,Max=1.0),Y=(Min=-1.0,Max=1.0),Z=(Min=-1.0,Max=1.0))
        InitialParticlesPerSecond=1000.0
        StartVelocityRange=(X=(Min=-200.0,Max=200.0),Y=(Min=-200.0,Max=200.0),Z=(Min=250.0,Max=500.0))
        UseRotationFrom=PTRS_Actor
        StartLocationShape=PTLS_Box
        StartLocationRange=(X=(Min=-90.0,Max=90.0),Z=(Min=0.0,Max=90.0))
    End Object
    Emitters(0)=MeshEmitter0

    // todo: smoke and sand emitter??

    AutoDestroy=true
    bNoDelete=false
}
