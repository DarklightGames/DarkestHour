//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHFuryLogsRightEmitter extends Emitter;

defaultproperties
{
    AutoDestroy=true
    bNoDelete=false
    LifeSpan=8.0
    Style=STY_Masked
    bHardAttach=true

    Begin Object Class=MeshEmitter Name=MeshEmitter0
        StaticMesh=StaticMesh'DH_ShermanM4A3E8_stc.body.Log'
        UseCollision=True
        UseMaxCollisions=True
        UseActorForces=True
        RespawnDeadParticles=False
        SpinParticles=True
        DampRotation=True
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-900.000000)
        DampingFactorRange=(X=(Min=0.250000,Max=0.500000),Y=(Min=0.250000,Max=0.500000),Z=(Min=0.250000,Max=0.500000))
        MaxCollisions=(Min=2.000000,Max=3.000000)
        ColorScale(0)=(Color=(R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        CoordinateSystem=PTCS_Relative
        MaxParticles=3
        Name="MeshEmitter0"
        StartLocationRange=(Y=(Min=80.000000,Max=80.000000),Z=(Min=60.000000,Max=80.000000))
        UseRotationFrom=PTRS_None
        SpinsPerSecondRange=(X=(Min=-0.125000,Max=0.250000),Y=(Min=-0.250000,Max=0.250000),Z=(Min=-0.500000,Max=0.500000))
        InitialParticlesPerSecond=1000.000000
        LifetimeRange=(Min=5.000000,Max=7.000000)
        StartVelocityRange=(X=(Min=-20.000000,Max=20.000000),Y=(Min=30.000000,Max=100.000000),Z=(Min=200.000000,Max=400.000000))
    End Object
    Emitters(0)=MeshEmitter'MeshEmitter0'
}

