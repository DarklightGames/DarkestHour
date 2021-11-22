//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHShellEject3rd762x54mm extends DHShellEject3rd;

simulated function Trigger(Actor Other, Pawn EventInstigator)
{
    Emitters[0].SpawnParticle(1);
}

defaultproperties
{
    Begin Object Class=MeshEmitter Name=MeshEmitter0
        StaticMesh=StaticMesh'WeaponPickupSM.S762_Rifle_MG'
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
        SpinCCWorCW=(X=1.000000,Y=0.000000,Z=0.000000)
        SpinsPerSecondRange=(X=(Min=6.000000,Max=8.000000),Y=(Min=-0.500000,Max=0.500000))
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
        StartSizeRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
        StartVelocityRange=(X=(Min=100.000000,Max=200.000000),Y=(Min=250.000000,Max=350.000000),Z=(Min=100.000000,Max=150.000000))
        StartVelocityRadialRange=(Min=0.400000,Max=0.400000)
        LifetimeRange=(Min=6.0,Max=6.0)
        //Sounds(0)=(Sound=SoundGroup'Inf_Weapons.shells.ShellRifleConcrete',Radius=(Min=100.000000,Max=100.000000),Volume=(Min=1.000000,Max=1.000000),Probability=(Min=1.000000,Max=1.000000))
        //CollisionSound=PTSC_Random
        //CollisionSoundProbability=(Min=1.000000,Max=1.000000)
    End Object
    Emitters(0)=MeshEmitter'MeshEmitter0'
}
