//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHShellEject3rd9x19mm extends DHShellEject3rd;

simulated function Trigger(Actor Other, Pawn EventInstigator)
{
    Emitters[0].SpawnParticle(1);
}

defaultproperties
{
    Begin Object Class=MeshEmitter Name=MeshEmitter0
        StaticMesh=StaticMesh'WeaponPickupSM.S9mm_SMG_Pistol'
        UseCollision=True
        RespawnDeadParticles=False
        SpinParticles=True
        DampRotation=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-900.000000)
        ExtentMultiplier=(X=0.000000,Y=0.000000,Z=0.000000)
        DampingFactorRange=(X=(Min=0.500000,Max=0.600000),Y=(Min=0.500000,Max=0.500000),Z=(Min=0.500000,Max=0.500000))
        MaxParticles=30
        Name="shell"
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.100000,Max=1.000000),Y=(Min=0.100000,Max=1.000000),Z=(Min=0.100000,Max=1.000000))
        StartSpinRange=(X=(Min=0.100000,Max=0.500000))
        LifetimeRange=(Min=6.0,Max=6.0)
        StartVelocityRange=(X=(Min=25.0,Max=45.0),Y=(Min=25.0,Max=45.0),Z=(Min=-150.0,Max=-250.0)) //eject bone is rotated weirdly, so fixing here
        StartVelocityRadialRange=(Min=-250.000000,Max=250.000000)
        //Sounds(0)=(Sound=SoundGroup'Inf_Weapons.shells.ShellRifleConcrete',Radius=(Min=100.000000,Max=100.000000),Volume=(Min=1.000000,Max=1.000000),Probability=(Min=1.000000,Max=1.000000))
        //CollisionSound=PTSC_Random
        //CollisionSoundProbability=(Min=1.000000,Max=1.000000)
    End Object
    Emitters(0)=MeshEmitter'MeshEmitter0'
}
