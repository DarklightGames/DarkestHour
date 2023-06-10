//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_EnfieldNo2Fire extends DHPistolFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_EnfieldNo2Bullet'
    AmmoClass=class'DH_Weapons.DH_EnfieldNo2Ammo'

    Spread=250.0
    MaxVerticalRecoilAngle=650
    MaxHorizontalRecoilAngle=100

    FireSounds(0)=SoundGroup'DH_WeaponSounds.EnfieldNo2.EnfieldNo2_Fire01'
    FireLastAnim="shoot"
    FireIronLastAnim="iron_shoot"
}
