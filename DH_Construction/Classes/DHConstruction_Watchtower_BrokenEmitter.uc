//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHConstruction_Watchtower_BrokenEmitter extends Emitter;

defaultproperties
{
    Begin Object Class=MeshEmitter Name=MeshEmitter0
        StaticMesh=StaticMesh'DH_Construction_stc.Constructions.plank_destro_01'
        UseCollision=true
        RespawnDeadParticles=false
        SpinParticles=true
        DampRotation=true
        AutomaticInitialSpawning=false
        Acceleration=(Z=-1000.0)
        DampingFactorRange=(X=(Min=0.2,Max=0.5),Y=(Min=0.2,Max=0.5),Z=(Min=0.2,Max=0.5))
        MaxCollisions=(Max=2.0)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        MaxParticles=8
        Name="MeshEmitter0"
        SpinsPerSecondRange=(X=(Min=-1.0,Max=1.0),Y=(Min=-1.0,Max=1.0),Z=(Min=-1.0,Max=1.0))
        StartSpinRange=(X=(Min=-1.0,Max=1.0),Y=(Min=-1.0,Max=1.0),Z=(Min=-1.0,Max=1.0))
        InitialParticlesPerSecond=1000.0
        StartVelocityRange=(X=(Min=-200.0,Max=200.0),Y=(Min=-200.0,Max=200.0),Z=(Min=250.0,Max=500.0))
        UseRotationFrom=PTRS_Actor
        StartLocationShape=PTLS_Box
        StartLocationRange=(X=(Min=-90.0,Max=90.0),Z=(Min=0.0,Max=90.0),Z=(Min=60,Max=600))
    End Object
    Emitters(0)=MeshEmitter0

    Begin Object Class=MeshEmitter Name=MeshEmitter1
        StaticMesh=StaticMesh'DH_Construction_stc.Constructions.plank_destro_02'
        UseCollision=true
        RespawnDeadParticles=false
        SpinParticles=true
        DampRotation=true
        AutomaticInitialSpawning=false
        Acceleration=(Z=-1000.0)
        DampingFactorRange=(X=(Min=0.2,Max=0.5),Y=(Min=0.2,Max=0.5),Z=(Min=0.2,Max=0.5))
        MaxCollisions=(Max=2.0)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        MaxParticles=8
        Name="MeshEmitter1"
        SpinsPerSecondRange=(X=(Min=-1.0,Max=1.0),Y=(Min=-1.0,Max=1.0),Z=(Min=-1.0,Max=1.0))
        StartSpinRange=(X=(Min=-1.0,Max=1.0),Y=(Min=-1.0,Max=1.0),Z=(Min=-1.0,Max=1.0))
        InitialParticlesPerSecond=1000.0
        StartVelocityRange=(X=(Min=-200.0,Max=200.0),Y=(Min=-200.0,Max=200.0),Z=(Min=250.0,Max=500.0))
        UseRotationFrom=PTRS_Actor
        StartLocationShape=PTLS_Box
        StartLocationRange=(X=(Min=-90.0,Max=90.0),Z=(Min=0.0,Max=90.0),Z=(Min=60,Max=600))
    End Object
    Emitters(1)=MeshEmitter1

    Begin Object Class=MeshEmitter Name=MeshEmitter2
        StaticMesh=StaticMesh'DH_Construction_stc.Constructions.plank_destro_03'
        UseCollision=true
        RespawnDeadParticles=false
        SpinParticles=true
        DampRotation=true
        AutomaticInitialSpawning=false
        Acceleration=(Z=-1000.0)
        DampingFactorRange=(X=(Min=0.2,Max=0.5),Y=(Min=0.2,Max=0.5),Z=(Min=0.2,Max=0.5))
        MaxCollisions=(Max=2.0)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.0,Color=(B=255,G=255,R=255,A=255))
        MaxParticles=8
        Name="MeshEmitter2"
        SpinsPerSecondRange=(X=(Min=-1.0,Max=1.0),Y=(Min=-1.0,Max=1.0),Z=(Min=-1.0,Max=1.0))
        StartSpinRange=(X=(Min=-1.0,Max=1.0),Y=(Min=-1.0,Max=1.0),Z=(Min=-1.0,Max=1.0))
        InitialParticlesPerSecond=1000.0
        StartVelocityRange=(X=(Min=-200.0,Max=200.0),Y=(Min=-200.0,Max=200.0),Z=(Min=250.0,Max=500.0))
        UseRotationFrom=PTRS_Actor
        StartLocationShape=PTLS_Box
        StartLocationRange=(X=(Min=-90.0,Max=90.0),Z=(Min=0.0,Max=90.0),Z=(Min=60,Max=600))
    End Object
    Emitters(2)=MeshEmitter2

    AutoDestroy=true
    bNoDelete=false
}
