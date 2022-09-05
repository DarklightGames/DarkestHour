//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_AVT40Fire extends DHAutomaticFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_AVT40Bullet'
    AmmoClass=class'ROAmmo.SVT40Ammo'
    FireRate=0.095 // ~700rpm (value had to be found experimentally due to an engine bug)
    bHasSemiAutoFireRate=true
    SemiAutoFireRate=0.215
    Spread=60.0
    bWaitForRelease=true // set to semi-auto by default

    RecoilRate=0.06
    MaxVerticalRecoilAngle=700  //keep in mind the first shot gets 0.8 coefficient
    MaxHorizontalRecoilAngle=210
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.8),(InVal=4.0,OutVal=1.1),(InVal=12.0,OutVal=1.5),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffExponent=2.0
    RecoilFallOffFactor=12.0

    FireSounds(0)=Sound'DH_WeaponSounds.svt.svtfire1'
    FireSounds(1)=Sound'DH_WeaponSounds.svt.svtfire2'
    FireSounds(2)=Sound'DH_WeaponSounds.svt.svtfire3'
    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mmGreen'
    ShellEmitBone="ejector"
    ShellRotOffsetHip=(Pitch=-3000,Yaw=0,Roll=-3000)

    ShakeOffsetMag=(X=3.0,Y=1.0,Z=3.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=1.0
    ShakeRotMag=(X=50.0,Y=50.0,Z=200.0)
    ShakeRotRate=(X=12500.0,Y=10000.0,Z=10000.0)
    ShakeRotTime=2.0

    FireLoopAnim="Shoot_auto"
    FireEndAnim=""
    FireIronLoopAnim="Iron_Shoot"
    FireIronEndAnim=""
    FireAnim="Shoot"
    FireIronAnim="Iron_Shoot"

    FireLastAnim="shoot_last"
    FireIronLastAnim="Iron_Shoot_Last"
}
