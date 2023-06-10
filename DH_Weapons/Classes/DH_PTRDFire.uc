//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_PTRDFire extends DHBoltFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_PTRDBullet'
    AmmoClass=class'ROAmmo.PTRDAmmo'
    bUsePreLaunchTrace=false
    Spread=75.0
    MaxVerticalRecoilAngle=750
    MaxHorizontalRecoilAngle=650
    FireSounds(0)=SoundGroup'Inf_Weapons.PTRD.PTRD_fire01'
    FireSounds(1)=SoundGroup'Inf_Weapons.PTRD.PTRD_fire02'
    FireSounds(2)=SoundGroup'Inf_Weapons.PTRD.PTRD_fire03'
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stPTRD'
    ShellEjectClass=class'ROAmmo.ShellEject1st14mm'
    ShellIronSightOffset=(X=10.0,Y=3.0,Z=0.0)
    ShellRotOffsetIron=(Pitch=-10000)
    bAnimNotifiedShellEjects=false
    FireIronAnim="shoot"
    ShakeOffsetMag=(X=6.0,Y=2.0,Z=10.0)
    ShakeOffsetTime=4.0
    ShakeRotMag=(X=100.0,Y=100.0,Z=800.0)
    ShakeRotTime=7.0
}
