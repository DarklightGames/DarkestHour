//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_PTRDFire extends DHBoltFire;

defaultproperties
{
    ProjectileClass=Class'DH_PTRDBullet'
    AmmoClass=Class'PTRDAmmo'
    bUsePreLaunchTrace=false
    Spread=75.0
    MaxVerticalRecoilAngle=750
    MaxHorizontalRecoilAngle=650
    FireSounds(0)=SoundGroup'Inf_Weapons.PTRD_fire01'
    FireSounds(1)=SoundGroup'Inf_Weapons.PTRD_fire02'
    FireSounds(2)=SoundGroup'Inf_Weapons.PTRD_fire03'
    FlashEmitterClass=Class'MuzzleFlash1stPTRD'
    ShellEjectClass=Class'ShellEject1st14mm'
    ShellIronSightOffset=(X=10.0,Y=3.0,Z=0.0)
    ShellRotOffsetIron=(Pitch=-10000)
    bAnimNotifiedShellEjects=false
    FireIronAnim="shoot"
    ShakeOffsetMag=(X=6.0,Y=2.0,Z=10.0)
    ShakeOffsetTime=4.0
    ShakeRotMag=(X=100.0,Y=100.0,Z=800.0)
    ShakeRotTime=7.0
}
