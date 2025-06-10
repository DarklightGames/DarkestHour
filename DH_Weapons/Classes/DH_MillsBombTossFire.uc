//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_MillsBombTossFire extends DHThrownExplosiveFire;

defaultproperties
{
    ProjectileClass=Class'DH_MillsBombProjectile'
    AmmoClass=Class'DH_MillsBombAmmo'
    AddedPitch=0
    MinimumThrowSpeed=100.0
    MaximumThrowSpeed=500.0
    SpeedFromHoldingPerSec=800.0
    FireAnim="Toss"
}
