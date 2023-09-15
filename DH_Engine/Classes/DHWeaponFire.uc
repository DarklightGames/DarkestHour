//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHWeaponFire extends ROWeaponFire;

// ROWeaponFire only handles a single ejector type, but some weapons
// eject multiple things from themselves when they fire. For example,
// a machine-gun with disintegrating belt will eject both the
// discarded belt links and the shells. This array can be used to
// accomplish multiple ejectors.
struct ShellEjector
{
    var class<ROShellEject> EjectClass;
    var name                EjectBone;
    var Vector              IronSightOffset;
    var Vector              HipOffset;
    var Rotator             RotOffsetIron;
    var Rotator             RotOffsetHip;
};
var array<ShellEjector> ShellEjectors;

var bool bIgnoresWeaponLock;

var vector MuzzleOffset;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Level.NetMode != NM_DedicatedServer)
    {
        // Add the RO shell ejector to our array.
        if (ShellEjectClass != none)
        {
            ShellEjectors.Insert(0, 1);
            ShellEjectors[0].EjectClass = ShellEjectClass;
            ShellEjectors[0].EjectBone = ShellEmitBone;
            ShellEjectors[0].IronSightOffset = ShellIronSightOffset;
            ShellEjectors[0].HipOffset = ShellHipOffset;
            ShellEjectors[0].RotOffsetIron = ShellRotOffsetIron;
            ShellEjectors[0].RotOffsetHip = ShellRotOffsetHip;
        }
    }
}

simulated function InitEffects()
{
    if (Level.NetMode == NM_DedicatedServer || AIController(Instigator.Controller) != none)
    {
        return;
    }

    if (FlashEmitterClass != none && (FlashEmitter == none || FlashEmitter.bDeleteMe))
    {
        FlashEmitter = Weapon.Spawn(FlashEmitterClass);

        if (FlashEmitter != none && MuzzleBone != '')
        {
            Weapon.AttachToBone(FlashEmitter, MuzzleBone);
            FlashEmitter.SetRelativeLocation(MuzzleOffset);
        }
    }

    if (SmokeEmitterClass != none && (SmokeEmitter == none || SmokeEmitter.bDeleteMe))
    {
        SmokeEmitter = Weapon.Spawn(SmokeEmitterClass, Instigator);

        if (SmokeEmitter != None && MuzzleBone != '')
        {
            Weapon.AttachToBone(SmokeEmitter, MuzzleBone);
            SmokeEmitter.SetRelativeLocation(MuzzleOffset);
        }
    }
}

event ModeDoFire()
{
    local DHProjectileWeapon ProjectileWeapon;

    super.ModeDoFire();

    ProjectileWeapon = DHProjectileWeapon(Weapon);

    if (ProjectileWeapon != none)
    {
        ProjectileWeapon.UpdateWeaponComponentAnimations();
        ProjectileWeapon.UpdateAmmoBelt();
    }
}

// New helper function to check whether player is hip firing
// Allows easy subclassing, which avoids re-stating long functions just to change bUsingSights and/or bBipodDeployed
simulated function bool IsPlayerHipFiring()
{
    return !(Weapon != none && Weapon.bUsingSights) && !(Instigator != none && Instigator.bBipodDeployed);
}

// Modified to also eject shells from our new array of ejectors.
// Modified to use the IsPlayerHipFiring() helper function, which makes this function generic & avoids re-stating in subclasses to make minor changes
simulated function EjectShell()
{
    local int i;
	local Coords EjectCoords;
	local Vector EjectOffset, X, Y, Z;
	local Rotator EjectRot;
	local ROShellEject Shell;

    for (i = 0; i < ShellEjectors.Length; ++i)
    {
	    if (ShellEjectors[i].EjectClass == none)
        {
            continue;
        }

        if (IsPlayerHipFiring())
        {
			// Find the shell eject location then scale it down 5x (since the weapons are scaled up 5x)
        	EjectCoords = Weapon.GetBoneCoords(ShellEjectors[i].EjectBone);
			EjectOffset = (EjectCoords.Origin - Weapon.Location) / 5.0;
        	EjectOffset += Weapon.Location;
        	EjectOffset += (EjectCoords.XAxis * ShellEjectors[i].HipOffset.X) 
                         + (EjectCoords.YAxis * ShellEjectors[i].HipOffset.Y)
                         + (EjectCoords.ZAxis * ShellEjectors[i].HipOffset.Z);

			if (bReverseShellSpawnDirection)
			{
            	EjectRot = Rotator(EjectCoords.YAxis);
            }
            else
            {
            	EjectRot = Rotator(-EjectCoords.YAxis);
            }

	    	Shell = Weapon.Spawn(ShellEjectors[i].EjectClass, none,, EjectOffset, EjectRot);
	    	EjectRot = Rotator(EjectCoords.XAxis) + ShellEjectors[i].RotOffsetHip;
        }
        else
        {
			Weapon.GetViewAxes(X, Y, Z);
			EjectOffset = Instigator.Location + Instigator.EyePosition();
			EjectOffset += (X * ShellEjectors[i].IronSightOffset.X)
                         + (Y * ShellEjectors[i].IronSightOffset.Y)
                         + (Z * ShellEjectors[i].IronSightOffset.Z);
    		EjectRot = Rotator(Y);
			EjectRot.Yaw += 16384;
			Shell = Weapon.Spawn(ShellEjectors[i].EjectClass, none,, EjectOffset, EjectRot);
			EjectRot = Rotator(Y) + ShellEjectors[i].RotOffsetIron;
        }

        EjectRot.Yaw = EjectRot.Yaw + Shell.RandomYawRange - Rand(Shell.RandomYawRange);
        EjectRot.Pitch = EjectRot.Pitch + Shell.RandomPitchRange; // - Rand(Shell.RandomPitchRange * 2);
        EjectRot.Roll = EjectRot.Roll + Shell.RandomRollRange; // - Rand(Shell.RandomRollRange * 2);

        Shell.Velocity = Vector(EjectRot) * class'UInterp'.static.Linear(FRand(), Shell.MinStartSpeed, Shell.MaxStartSpeed);
    }
}

defaultproperties
{
    SpreadStyle=SS_Random // this is actually assumed & hard-coded into spread functionality
}
