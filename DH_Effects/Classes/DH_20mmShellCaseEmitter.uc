//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_20mmShellCaseEmitter extends Emitter;

simulated function Trigger(Actor Other, Pawn EventInstigator)
{
    Emitters[0].SpawnParticle(1);
}

defaultproperties
{
    Begin Object Class=MeshEmitter Name=MeshEmitter0
        StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.German20mmShellCase'
        UseCollision=true
        RespawnDeadParticles=false
        SpawnOnlyInDirectionOfNormal=true
        SpinParticles=true
        AutomaticInitialSpawning=false
        Acceleration=(Z=-500.0)
        DampingFactorRange=(X=(Min=0.5,Max=0.5),Y=(Min=0.5,Max=0.5),Z=(Min=0.5,Max=0.5))
        MaxParticles=30
        StartLocationOffset=(X=0.0,Y=4.0,Z=0.0)
        MeshNormal=(Z=0.0)
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.1,Max=1.0),Y=(Min=0.1,Max=1.0),Z=(Min=0.1,Max=1.0))
        LifetimeRange=(Min=1.5,Max=1.5)
        StartVelocityRange=(X=(Min=-1.0,Max=1.0),Y=(Min=25.0,Max=100.0),Z=(Min=0.1,Max=1.0))
        StartVelocityRadialRange=(Min=-250.0,Max=250.0)
    End Object
    Emitters(0)=MeshEmitter'MeshEmitter0'

    bUnlit=false
    bNoDelete=false
    bHardAttach=true
    CullDistance=4000.0
}
