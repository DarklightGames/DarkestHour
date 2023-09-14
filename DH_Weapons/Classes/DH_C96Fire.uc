//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_C96Fire extends DHPistolFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_C96Bullet'
    AmmoClass=class'DH_Weapons.DH_C96Ammo'
    FireSounds(0)=SoundGroup'DH_WeaponSounds.c96.C96_FireSingle01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.c96.C96_FireSingle02'

    Spread=200.0
    MaxVerticalRecoilAngle=870
    MaxHorizontalRecoilAngle=350

    ShellEjectClass=class'ROAmmo.ShellEject1st9x19mm'
    ShellHipOffset=(X=0.0,Y=0.0,Z=0.0)

    FireLastAnim="Shoot_Empty"
    FireIronLastAnim="iron_shoot_empty"
}
