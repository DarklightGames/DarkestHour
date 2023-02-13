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

// Modified to also eject shells from our new array of ejectors.
simulated function EjectShell()
{
    local int i;
	local Coords EjectCoords;
	local Vector EjectOffset, X, Y, Z;
	local Rotator EjectRot;
	local ROShellEject Shell;

    super.EjectShell();

    for (i = 0; i < ShellEjectors.Length; ++i)
    {
	    if (ShellEjectors[i].EjectClass == none)
        {
            continue;
        }

        if (Weapon.bUsingSights)
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
        else
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

        EjectRot.Yaw = EjectRot.Yaw + Shell.RandomYawRange - Rand(Shell.RandomYawRange * 2);
        EjectRot.Pitch = EjectRot.Pitch + Shell.RandomPitchRange - Rand(Shell.RandomPitchRange * 2);
        EjectRot.Roll = EjectRot.Roll + Shell.RandomRollRange - Rand(Shell.RandomRollRange * 2);

        Shell.Velocity = Vector(EjectRot) * class'UInterp'.static.Linear(FRand(), Shell.MinStartSpeed, Shell.MaxStartSpeed);
    }
}

defaultproperties
{
    SpreadStyle=SS_Random // this is actually assumed & hard-coded into spread functionality
}
