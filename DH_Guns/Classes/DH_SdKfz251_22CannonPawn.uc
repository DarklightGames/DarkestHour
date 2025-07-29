//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_SdKfz251_22CannonPawn extends DH_Pak40CannonPawn;

defaultproperties
{
    GunClass=Class'DH_SdKfz251_22Cannon'
    DriverPositions(1)=(DriverTransitionAnim="stand_idlehold_bayo",ViewPositiveYawLimit=2400,ViewNegativeYawLimit=-5100) // animation better positions the standing gunner in a vehicle
    DrivePos=(X=-11.0,Y=-1.0,Z=-57.0)
}
