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
    ShellHipOffset=(X=4.6,Y=14.0,Z=6.8)
    ShellIronSightOffset=(X=9.5,Y=1.6,Z=-2.4)
    FireForce="AssaultRifleFire"
    ShakeOffsetMag=(X=3.0,Y=2.0,Z=8.0)
}
