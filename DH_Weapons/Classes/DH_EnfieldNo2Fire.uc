//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_EnfieldNo2Fire extends DHPistolFire;

defaultproperties
{
    ProjectileClass=Class'DH_EnfieldNo2Bullet'
    AmmoClass=Class'DH_EnfieldNo2Ammo'

    Spread=250.0
    MaxVerticalRecoilAngle=650
    MaxHorizontalRecoilAngle=100

    FireSounds(0)=SoundGroup'DH_WeaponSounds.EnfieldNo2.EnfieldNo2_Fire01'
    FireLastAnim="shoot"
    FireIronLastAnim="iron_shoot"
}
