//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Wz35Fire extends DHBoltFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_PTRDBullet' // TODO: replace with WZ35 bullet
    AmmoClass=class'DH_Weapons.DH_Wz35Ammo'
    bUsePreLaunchTrace=false
    Spread=75.0
    MaxVerticalRecoilAngle=750
    MaxHorizontalRecoilAngle=650
    FireSounds(0)=SoundGroup'DH_MN_InfantryWeapons_sound.Boys01'
    FireSounds(1)=SoundGroup'DH_MN_InfantryWeapons_sound.Boys01'
    FireSounds(2)=SoundGroup'DH_MN_InfantryWeapons_sound.Boys01'
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stPTRD'
    ShellEjectClass=class'ROAmmo.ShellEject1st14mm'
    //ShellIronSightOffset=(X=10.0,Y=3.0,Z=0.0)
    //ShellRotOffsetIron=()
    bAnimNotifiedShellEjects=true
    FireIronAnim="deploy_shoot"
    ShakeOffsetMag=(X=6.0,Y=2.0,Z=10.0)
    ShakeOffsetTime=4.0
    ShakeRotMag=(X=100.0,Y=100.0,Z=800.0)
    ShakeRotTime=7.0
}
