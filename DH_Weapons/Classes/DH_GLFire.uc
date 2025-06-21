//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_GLFire extends DHThrownExplosiveFire;

defaultproperties
{
    ProjectileClass=Class'DH_GLProjectile'
    AmmoClass=Class'DH_GLAmmo'
    ProjSpawnOffset=(X=-5.0)
    AddedPitch=250
    MinimumThrowSpeed=400.0
    MaximumThrowSpeed=500.0
    AddedFuseTime=1.0  //doesnt seem to work here
    SpeedFromHoldingPerSec=700.0
}
