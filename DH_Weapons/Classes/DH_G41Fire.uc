//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_G41Fire extends DHSemiAutoFire;

defaultproperties
{
    ProjectileClass=Class'DH_G41Bullet'
    AmmoClass=Class'DH_EnfieldNo4Ammo'
    FireRate=0.215
    Spread=50.0

    //Recoil
    RecoilRate=0.06
    RecoilCurve=(Points=((InVal=0.0,OutVal=1.0),(InVal=4.0,OutVal=1.37),(InVal=12.0,OutVal=1.9),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffExponent=2.0
    RecoilFallOffFactor=12.0

    MaxVerticalRecoilAngle=700
    MaxHorizontalRecoilAngle=310  //heavy, but very unbalanced with awkward gas automatic system
    FireSounds(0)=SoundGroup'DH_WeaponSounds.g41_fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.g41_fire02'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.g41_fire03'
    ShellEjectClass=Class'ShellEject1st762x54mm'
    ShellRotOffsetHip=(Pitch=-3000,Yaw=-3000)

    FireLastAnim="shoot_last"
    FireIronLastAnim="Iron_Shoot_Last"
}
