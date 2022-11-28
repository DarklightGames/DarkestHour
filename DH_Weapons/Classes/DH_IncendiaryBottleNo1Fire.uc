//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_IncendiaryBottleNo1Fire extends DHThrownExplosiveFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_IncendiaryBottleNo1Projectile'
    AmmoClass=class'DH_Weapons.DH_IncendiaryBottleNo1Ammo'

    bIsSmokeGrenade=true; //blocks molotov from exploding in hands

    // bPullAnimCompensation=true
    // AddedFuseTime=0.38
}
