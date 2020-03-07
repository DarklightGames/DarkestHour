//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_C96Fire extends DHPistolFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_C96Bullet'
    AmmoClass=class'DH_Weapons.DH_C96Ammo'
    FireSounds(0)=SoundGroup'DH_old_inf_weapons.C96.c96_shot1'
    FireSounds(1)=SoundGroup'DH_old_inf_weapons.C96.c96_shot2'

    Spread=200.0
    MaxVerticalRecoilAngle=870
    MaxHorizontalRecoilAngle=350

    ShellEjectClass=class'ROAmmo.ShellEject1st9x19mm'
    ShellHipOffset=(X=0.0,Y=0.0,Z=0.0)

    FireLastAnim="Shoot_Empty"
    FireIronLastAnim="iron_shoot_empty"
}
