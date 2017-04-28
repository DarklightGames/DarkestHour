//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHConstruction_Sandbags_BrokenEmitter extends Emitter;

defaultproperties
{
    Begin Object Class=MeshEmitter Name=MeshEmitter0
        StaticMesh=StaticMesh'DH_Construction_stc.Sandbags.sandbags_single_01'
        UseCollision=True
        RespawnDeadParticles=False
        SpinParticles=True
        DampRotation=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-1000.000000)
        DampingFactorRange=(X=(Min=0.200000,Max=0.500000),Y=(Min=0.200000,Max=0.500000),Z=(Min=0.200000,Max=0.500000))
        MaxCollisions=(Max=2.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        MaxParticles=16
        Name="MeshEmitter0"
        SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
        InitialParticlesPerSecond=1000.000000
        StartVelocityRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-200.000000,Max=200.000000),Z=(Min=250.000000,Max=500.000000))
        UseRotationFrom=PTRS_Actor
        StartLocationShape=PTLS_Box
        StartLocationRange=(X=(Min=-90.0,Max=90.0),Z=(Min=0.0,Max=90.0))
        BuSE
    End Object
    Emitters(0)=MeshEmitter0

    // todo: smoke and sand emitter??

    AutoDestroy=true
    bNoDelete=false
}

