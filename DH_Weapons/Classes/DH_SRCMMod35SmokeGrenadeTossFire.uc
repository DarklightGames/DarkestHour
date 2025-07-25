//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_SRCMMod35SmokeGrenadeTossFire extends DHThrownExplosiveFire;

defaultproperties
{
    ProjectileClass=Class'DH_SRCMMod35SmokeGrenadeProjectile'
    AmmoClass=Class'DH_SRCMMod35SmokeGrenadeAmmo'
    AddedPitch=0
    MinimumThrowSpeed=100.0
    MaximumThrowSpeed=500.0
    SpeedFromHoldingPerSec=800.0
    FireAnim="Toss"
}
