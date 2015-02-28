//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_MP40Fire extends DH_AutomaticFire;

defaultproperties
{
    ProjSpawnOffset=(X=25.0)
    FAProjSpawnOffset=(X=-20.0)
    FireIronAnim="Iron_Shoot_Loop"
    FireIronLoopAnim="Iron_Shoot_Loop"
    FireIronEndAnim="Iron_Shoot_End"
    FireSounds(0)=SoundGroup'Inf_Weapons.mp40.mp40_fire01'
    FireSounds(1)=SoundGroup'Inf_Weapons.mp40.mp40_fire02'
    FireSounds(2)=SoundGroup'Inf_Weapons.mp40.mp40_fire03'
    maxVerticalRecoilAngle=550
    maxHorizontalRecoilAngle=75
    PctProneIronRecoil=0.5
    RecoilRate=0.075
    ShellEjectClass=class'ROAmmo.ShellEject1st9x19mm'
    ShellIronSightOffset=(X=15.0)
    FireAnim="Shoot_Loop"
    FireLoopAnim="Shoot_Loop"
    FireEndAnim="Shoot_End"
    TweenTime=0.0
    NoAmmoSound=sound'Inf_Weapons_Foley.Misc.dryfire_smg'
    FireRate=0.12
    AmmoClass=class'ROAmmo.MP32Rd9x19Ammo'
    ShakeRotMag=(X=50.0,Y=50.0,Z=150.0)
    ShakeRotRate=(X=10000.0,Y=10000.0,Z=10000.0)
    ShakeRotTime=0.5
    ShakeOffsetMag=(X=3.0,Y=1.0,Z=3.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=1.0
    ProjectileClass=class'DH_Weapons.DH_MP40Bullet'
    BotRefireRate=0.99
    WarnTargetPct=0.9
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stMP'
    SmokeEmitterClass=class'ROEffects.ROMuzzleSmoke'
    aimerror=1200.0
    Spread=300.0
    SpreadStyle=SS_Random
}
