//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_ColtM1911Fire extends DHPistolFire;

defaultproperties
{
    ProjectileClass=Class'DH_ColtM1911Bullet'
    AmmoClass=Class'DH_ColtM1911Ammo'
    FireSounds(0)=SoundGroup'DH_WeaponSounds.Colt45.Colt45_Fire01'

    Spread=220.0
    MaxVerticalRecoilAngle=600
    MaxHorizontalRecoilAngle=350

    ShellEjectClass=Class'ShellEject1st9x19mm'
    ShellHipOffset=(X=0.0,Y=0.0,Z=0.0)

    FireLastAnim="Shoot_Empty"
    FireIronLastAnim="iron_shoot_empty"
}
