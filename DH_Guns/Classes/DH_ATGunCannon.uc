//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ATGunCannon extends DH_ROTankCannon
    config(xGunsightDebugging)
    abstract;

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

// Matt: added to replace deprecated 'should penetrate' functions below
simulated function bool DHShouldPenetrate(class<DH_ROAntiVehicleProjectile> P, vector HitLocation, vector HitRotation, float PenetrationNumber)
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
    local int NewYaw;
    local ROVehicleWeaponPawn PwningPawn;

    PwningPawn = ROVehicleWeaponPawn(Owner);

    if (!bLimitYaw)
    {
        return yaw;
    }

    NewYaw = yaw;

    if (PwningPawn != none)
    {
        if (yaw > PwningPawn.DriverPositions[PwningPawn.DriverPositionIndex].ViewPositiveYawLimit)
        {
            NewYaw = PwningPawn.DriverPositions[PwningPawn.DriverPositionIndex].ViewPositiveYawLimit;
        }
        else if (yaw < PwningPawn.DriverPositions[PwningPawn.DriverPositionIndex].ViewNegativeYawLimit)
        {
            NewYaw = PwningPawn.DriverPositions[PwningPawn.DriverPositionIndex].ViewNegativeYawLimit;
        }
    }
    else
    {
        if (yaw > MaxPositiveYaw)
        {
            NewYaw = MaxPositiveYaw;
        }
        else if (yaw < MaxNegativeYaw)
        {
            NewYaw = MaxNegativeYaw;
        }
    }

    return NewYaw;
}

defaultproperties
{
    FrontArmorFactor=1.0
    RightArmorFactor=0.8
    LeftArmorFactor=0.8
    RearArmorFactor=1.0
    FrontLeftAngle=332.0
    FrontRightAngle=28.0
    RearRightAngle=162.0
    RearLeftAngle=198.0
}
