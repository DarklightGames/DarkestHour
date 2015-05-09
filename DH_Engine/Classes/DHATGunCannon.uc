//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHATGunCannon extends DHTankCannon
    abstract;

// Modified to use 3 part reload instead of usual 4 part
simulated function Timer()
{
    if (VehicleWeaponPawn(Owner) == none || VehicleWeaponPawn(Owner).Controller == none)
    {
        SetTimer(0.05, true);
    }
    else if (CannonReloadState == CR_Empty)
    {
        PlayOwnedSound(ReloadSoundOne, SLOT_Misc, FireSoundVolume / 255.0,, 150.0,, false);
        CannonReloadState = CR_ReloadedPart1;
        SetTimer(GetSoundDuration(ReloadSoundOne), false);
    }
    else if (CannonReloadState == CR_ReloadedPart1)
    {
        PlayOwnedSound(ReloadSoundTwo, SLOT_Misc, FireSoundVolume / 255.0,, 150.0,, false);
        CannonReloadState = CR_ReloadedPart2;
        SetTimer(GetSoundDuration(ReloadSoundTwo), false);
    }
    else if (CannonReloadState == CR_ReloadedPart2)
    {
        PlayOwnedSound(ReloadSoundThree, SLOT_Misc, FireSoundVolume / 255.0,, 150.0,, false);
        CannonReloadState = CR_ReloadedPart3;
        SetTimer(GetSoundDuration(ReloadSoundThree), false);
    }
    else if (CannonReloadState == CR_ReloadedPart3)
    {
        if (Role == ROLE_Authority)
        {
            bClientCanFireCannon = true;
        }

        CannonReloadState = CR_ReadyToFire;
        SetTimer(0.0, false);
    }
}

// AT gun will always be penetrated by a shell
simulated function bool DHShouldPenetrate(DHAntiVehicleProjectile P, vector HitLocation, vector HitRotation, float PenetrationNumber)
{
   return true;
}

// Matt: reinstating original RO functions for AT guns, as generally don't have gunner's collision & if they do (e.g. German 88mm) they need different handling from new commander hit system
simulated function bool HitDriverArea(vector HitLocation, vector Momentum)
{
    return super(ROVehicleWeapon).HitDriverArea(HitLocation, Momentum);
}

simulated function bool HitDriver(vector HitLocation, vector Momentum)
{
    return super(ROVehicleWeapon).HitDriver(HitLocation, Momentum);
}

// There aren't any angles that are below the driver angle for the AT Gun cannon
simulated function bool BelowDriverAngle(vector loc, vector ray)
{
    return false;
}

// Limit the left and right movement of the gun
simulated function int LimitYaw(int yaw)
{
    if (!bLimitYaw)
    {
        return yaw;
    }

    if (CannonPawn != none)
    {
        return Clamp(yaw, CannonPawn.DriverPositions[CannonPawn.DriverPositionIndex].ViewNegativeYawLimit, CannonPawn.DriverPositions[CannonPawn.DriverPositionIndex].ViewPositiveYawLimit);
    }

    return Clamp(yaw, MaxNegativeYaw, MaxPositiveYaw);
}

defaultproperties
{
    bHasTurret=false
}
