//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_MN9130Fire extends DHBoltFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_MN9130Bullet'
    AmmoClass=class'DH_Weapons.DH_MN9130Ammo'
    Spread=40.0
    MaxVerticalRecoilAngle=1500
    FireSounds(0)=SoundGroup'Inf_Weapons.nagant9130.nagant9130_fire01'
    FireSounds(1)=SoundGroup'Inf_Weapons.nagant9130.nagant9130_fire02'
    FireSounds(2)=SoundGroup'Inf_Weapons.nagant9130.nagant9130_fire03'
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stNagant'
    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mmGreen'
    FireAnim="shoot_last"
    FireIronAnim="Iron_shootrest"
}
