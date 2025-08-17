//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_C96Fire extends DHPistolFire;

defaultproperties
{
    ProjectileClass=Class'DH_C96Bullet'
    AmmoClass=Class'DH_C96Ammo'
    FireSounds(0)=SoundGroup'DH_WeaponSounds.C96_FireSingle01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.C96_FireSingle02'

    Spread=200.0
    MaxVerticalRecoilAngle=870
    MaxHorizontalRecoilAngle=350
    FireRate=0.23

    ShellEjectClass=Class'ShellEject1st9x19mm'
    ShellHipOffset=(X=0.0,Y=0.0,Z=0.0)

    FireLastAnim="Shoot_Empty"
    FireIronLastAnim="iron_shoot_empty"
}
