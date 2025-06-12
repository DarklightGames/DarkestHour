//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_SovietMolotovFire extends DHThrownExplosiveFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_SovietMolotovProjectile'
    AmmoClass=class'DH_Weapons.DH_SovietMolotovAmmo'

    bIsSmokeGrenade=true; //blocks molotov from exploding in hands

    // bPullAnimCompensation=true
    // AddedFuseTime=0.38
}
