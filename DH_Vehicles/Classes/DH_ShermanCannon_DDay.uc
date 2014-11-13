//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ShermanCannon_DDay extends DH_ShermanCannon;

// Limit the left and right movement of the driver
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
     YawStartConstraint=-25000.000000
     YawEndConstraint=25000.000000
     MaxPositiveYaw=23666
     MaxNegativeYaw=-23666
     bLimitYaw=true
     InitialPrimaryAmmo=35
     InitialSecondaryAmmo=50
}
