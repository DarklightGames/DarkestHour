//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_EnfieldNo4ScopedFire extends DHBoltFire;

defaultproperties
{
    ProjectileClass=Class'DH_EnfieldNo4ScopedBullet'
    AmmoClass=Class'DH_EnfieldNo4ScopedAmmo'
    Spread=20.0
    AddedPitch=10
    AddedYaw=9
    PctRestDeployRecoil=0.25
    FireSounds(0)=SoundGroup'DH_WeaponSounds.EnfieldNo4.EnfieldRifle_Fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.EnfieldNo4.EnfieldRifle_Fire02'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.EnfieldNo4.EnfieldRifle_Fire03'
    FlashEmitterClass=Class'MuzzleFlash1stKar'
    ShellEjectClass=Class'ShellEject1st762x54mm'
    FireAnim="shoot_last"
    FireIronAnim="Scope_shoot"
    ShellIronSightOffset=(X=12.0,Y=2.0,Z=-3.0)
    ShellRotOffsetIron=(Pitch=8000)
    ShellRotOffsetHip=(Pitch=-8000)
    ShakeRotMag=(X=50.0,Y=50.0,Z=400.0)
    ShakeRotTime=5.0
    AimError=500.0
}
