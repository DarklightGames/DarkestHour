//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Winchester1897Fire extends DHBoltFire;

defaultproperties
{
    ProjectileClass=Class'DH_Winchester1897Bullet'
    AmmoClass=Class'DH_Winchester1897Ammo'
    ProjPerFire=9
    bUsePreLaunchTrace=false // due to multiple buckshot projectiles fired with each shot
    BotRefireRate=0.95
    FlashEmitterClass=Class'MuzzleFlash1stKar'

    Spread=300.0
    CrouchSpreadModifier=1.0 // spread modifiers all neutral as it's a very high spread, multi-projectile weapon
    ProneSpreadModifier=1.0
    BipodDeployedSpreadModifier=1.0
    RestDeploySpreadModifier=1.0
    HipSpreadModifier=1.0
    LeanSpreadModifier=1.0
    RecoilRate=0.075
    MaxVerticalRecoilAngle=900
    MaxHorizontalRecoilAngle=120

    FireSounds(0)=SoundGroup'DH_WeaponSounds.Winchester1897_fire01'
    ShellEjectClass=Class'DH_1stShellEjectShotgun'
    ShellHipOffset=(X=0,Y=0,Z=0)
    ShellIronSightOffset=(X=0,Y=0,Z=0)
    FireForce="AssaultRifleFire"
    MuzzleBone="muzzle"
    ShellEmitBone="ejector"
    ShakeOffsetMag=(X=3.0,Y=2.0,Z=8.0)
}
