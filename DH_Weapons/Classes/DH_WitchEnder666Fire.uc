//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_WitchEnder666Fire extends DHBoltFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_WitchEnder666Bullet'
    AmmoClass=class'DH_Weapons.DH_WitchEnder666Ammo'
    ProjPerFire=15
    bUsePreLaunchTrace=false // due to multiple buckshot projectiles fired with each shot
    BotRefireRate=0.95
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stKar'

    Spread=250.0
    CrouchSpreadModifier=1.0 // spread modifiers all neutral as it's a very high spread, multi-projectile weapon
    ProneSpreadModifier=1.0
    BipodDeployedSpreadModifier=1.0
    RestDeploySpreadModifier=1.0
    HipSpreadModifier=1.0
    LeanSpreadModifier=1.0
    RecoilRate=0.075
    MaxVerticalRecoilAngle=900
    MaxHorizontalRecoilAngle=120
    

    FireSounds(0)=Sound'DH_WeaponSounds.Winchester1897.WitchEnderFire'
    ShellEjectClass=class'DH_Weapons.DH_1stShellEjectShotgun'
    ShellHipOffset=(X=0,Y=0,Z=0)
    ShellIronSightOffset=(X=0,Y=0,Z=0)
    FireForce="AssaultRifleFire"
    MuzzleBone="muzzle"
    ShellEmitBone="ejector"
    ShakeOffsetMag=(X=3.0,Y=2.0,Z=8.0)
}
