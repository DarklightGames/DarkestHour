//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M1GrenadeTossFire extends DHThrownExplosiveFire;

defaultproperties
{
    ProjectileClass=Class'DH_M1GrenadeProjectile'
    AmmoClass=Class'DH_M1GrenadeAmmo'
    AddedPitch=0
    MinimumThrowSpeed=100.0
    MaximumThrowSpeed=500.0
    SpeedFromHoldingPerSec=800.0
    FireAnim="Toss"
}
