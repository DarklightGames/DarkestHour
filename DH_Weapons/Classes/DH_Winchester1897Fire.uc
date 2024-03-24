//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Winchester1897Fire extends DHBoltFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_Winchester1897Bullet'
    AmmoClass=class'DH_Weapons.DH_Winchester1897Ammo'
    ProjPerFire=9
    bUsePreLaunchTrace=false // due to multiple buckshot projectiles fired with each shot
    BotRefireRate=0.95
    FlashEmitterClass=class'DH_Effects.DHMuzzleFlash1stShotgun'

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

    FireSounds(0)=SoundGroup'DH_WeaponSounds.Winchester1897.Winchester1897_fire01'
    ShellEjectClass=class'DH_Weapons.DH_1stShellEjectShotgun'
    ShellRotOffsetHip=(Pitch=800,Yaw=-10000)
    ShellHipOffset=(X=0,Y=0,Z=0)
    ShellRotOffsetIron=(Pitch=1500,Yaw=2000)
    ShellIronSightOffset=(X=5.5,Y=1.5,Z=-2.0)
    FireForce="AssaultRifleFire"
    MuzzleBone="muzzle"
    ShellEmitBone="ejector"
    ShakeOffsetMag=(X=3.0,Y=2.0,Z=8.0)
}
