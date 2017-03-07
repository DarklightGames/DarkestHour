//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_Winchester1897Fire extends DHBoltFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_Winchester1897Bullet'
    AmmoClass=class'DH_Weapons.DH_Winchester1897Ammo'
    ProjPerFire=9
    bUsePreLaunchTrace=false // due to multiple buckshot projectiles fired with each shot
    bWaitForRelease=true

    FireSounds(0)=SoundGroup'DH_WeaponSounds.Winchester1897.Winchester1897_fire01'
    SmokeEmitterClass=class'ROEffects.ROMuzzleSmoke'
    ShellEjectClass=class'DH_Weapons.DH_1stShellEjectShotgun'
    ShellHipOffset=(X=4.6,Y=14.0,Z=6.8)
    ShellIronSightOffset=(X=9.5,Y=1.6,Z=-2.4)

    SpreadStyle=SS_Random
    Spread=667.0
    CrouchSpreadModifier=1.0 // spread modifiers all neutral as it's a very high spread, multi-projectile weapon
    ProneSpreadModifier=1.0
    BipodDeployedSpreadModifier=1.0
    RestDeploySpreadModifier=1.0
    HipSpreadModifier=1.0
    LeanSpreadModifier=1.0

    RecoilRate=0.075
    MaxVerticalRecoilAngle=3500
    MaxHorizontalRecoilAngle=800

    FireAnim="shoot"
    FireIronAnim="iron_shoot"
    FireIronEndAnim="Iron_shot"

    ShakeRotMag=(X=0.0,Y=0.0,Z=175.0)
    ShakeRotRate=(X=10000.0,Y=10000.0,Z=10000.0)
    ShakeRotTime=0.75
    ShakeOffsetMag=(X=0.0,Y=0.0,Z=3.0)
}
