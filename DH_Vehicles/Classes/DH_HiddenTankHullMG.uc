class DH_HiddenTankHullMG extends DH_ROMountedTankMG
      abstract;

var()	sound ReloadSound; // sound of this MG reloading
var		bool  bReloading;  // This MG is currently reloading
var		int	  NumMags;	   // Number of mags carried for this MG;

replication
{
    reliable if (bNetDirty && bNetOwner && Role == ROLE_Authority)
        bReloading, NumMags;
}

// Returns true if this weapon is ready to fire
simulated function bool ReadyToFire(bool bAltFire)
{
	//log("bReloading = "$bReloading);

	if (bReloading)
		return false;

	return super.ReadyToFire(bAltFire);
}

function CeaseFire(Controller C, bool bWasAltFire)
{
	super.CeaseFire(C, bWasAltFire);

	if (!bReloading && !HasAmmo(0))
		HandleReload();
}

function HandleReload()
{
	if (NumMags > 0 && !bReloading)
	{
		bReloading = true;
		NumMags--;
		NetUpdateTime = Level.TimeSeconds - 1;
		SetTimer(GetSoundDuration(ReloadSound), false);
		PlaySound(ReloadSound, SLOT_none,1.5,, 25, ,true);
	}
}

simulated function Timer()
{
   if (bReloading)
   {
	    if (Role == ROLE_Authority)
	    {
			bReloading=false;
			MainAmmoCharge[0] = InitialPrimaryAmmo;
			NetUpdateTime = Level.TimeSeconds - 1;
        }
   }
}

event bool AttemptFire(Controller C, bool bAltFire)
{
  	if (Role != ROLE_Authority || bForceCenterAim)
		return false;

	if (FireCountdown <= 0)
	{
		CalcWeaponFire(bAltFire);
		if (bCorrectAim)
			WeaponFireRotation = AdjustAim(bAltFire);

		if (bAltFire)
		{
			if (AltFireSpread > 0)
				WeaponFireRotation = rotator(vector(WeaponFireRotation) + VRand()*FRand()*AltFireSpread);
		}
		else if (Spread > 0)
		{
			WeaponFireRotation = rotator(vector(WeaponFireRotation) + VRand()*FRand()*Spread);
		}

        DualFireOffset *= -1;

		Instigator.MakeNoise(1.0);
		if (bAltFire)
		{
			if (!ConsumeAmmo(2))
			{
				VehicleWeaponPawn(Owner).ClientVehicleCeaseFire(bAltFire);
				return false;
			}
			FireCountdown = AltFireInterval;
			AltFire(C);
		}
		else
		{
			if (bMultipleRoundTypes)
			{
				if (ProjectileClass == PrimaryProjectileClass)
				{
					if (!ConsumeAmmo(0))
					{
						VehicleWeaponPawn(Owner).ClientVehicleCeaseFire(bAltFire);
						return false;
					}
			    }
			    else if (ProjectileClass == SecondaryProjectileClass)
			    {
					if (!ConsumeAmmo(1))
					{
						VehicleWeaponPawn(Owner).ClientVehicleCeaseFire(bAltFire);
						return false;
					}
			    }
			}
			else if (!ConsumeAmmo(0))
			{
				VehicleWeaponPawn(Owner).ClientVehicleCeaseFire(bAltFire);
				HandleReload();
				return false;
			}

			FireCountdown = FireInterval;
		    Fire(C);
		}
		AimLockReleaseTime = Level.TimeSeconds + FireCountdown * FireIntervalAimLock;

	    return true;
	}

	return false;
}

// Fill the ammo up to the initial ammount
function bool GiveInitialAmmo()
{
	local bool bDidResupply;

	if (NumMags != default.NumMags)
	{
		bDidResupply = true;
	}

	MainAmmoCharge[0] = InitialPrimaryAmmo;
	MainAmmoCharge[1] = InitialSecondaryAmmo;
	AltAmmoCharge = InitialAltAmmo;
	NumMags = default.NumMags;

	return bDidResupply;
}

simulated function int getNumMags()
{
    return NumMags;
}

defaultproperties
{
}
