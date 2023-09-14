//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_GLFire extends DHThrownExplosiveFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_GLProjectile'
    AmmoClass=class'DH_Weapons.DH_GLAmmo'
    ProjSpawnOffset=(X=-5.0)
    AddedPitch=250
    MinimumThrowSpeed=400.0
    MaximumThrowSpeed=500.0
    AddedFuseTime=1.0  //doesnt seem to work here
    SpeedFromHoldingPerSec=700.0
}
