//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DH_EnfieldNo2Fire extends DHPistolFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_EnfieldNo2Bullet'
    AmmoClass=class'DH_Weapons.DH_EnfieldNo2Ammo'
    Spread=340.0
    FireSounds(0)=SoundGroup'DH_WeaponSounds.EnfieldNo2.EnfieldNo2_Fire01'
    FireLastAnim="shoot"
    FireIronLastAnim="iron_shoot"
}
