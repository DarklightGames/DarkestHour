//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_StielGranateFire extends DHThrownExplosiveFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_StielGranateProjectile'
    AmmoClass=class'ROAmmo.StielGranateAmmo'
    bPullAnimCompensation=true
    AddedFuseTime=0.38
}
