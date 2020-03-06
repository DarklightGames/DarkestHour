//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_MolotovFire extends DHThrownExplosiveFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_MolotovProjectile'
    AmmoClass=class'DH_Weapons.DH_MolotovAmmo'

    bIsSmokeGrenade=true; //blocks molotov from exploding in hands

    // bPullAnimCompensation=true
    // AddedFuseTime=0.38
}
