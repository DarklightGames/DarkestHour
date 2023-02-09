//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_M1T17CarbineFire extends DHAutomaticFire;

defaultproperties
{
    bWaitForRelease=true // set to semi-auto by default

    ProjectileClass=class'DH_Weapons.DH_M1T17CarbineBullet'
    AmmoClass=class'DH_Weapons.DH_M1T17CarbineAmmo'
    Spread=75.0
    FireSounds(0)=SoundGroup'DH_WeaponSounds.Carbine.CarbineFire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.Carbine.CarbineFire02'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.Carbine.CarbineFire03'
    ShellEjectClass=class'ROAmmo.ShellEject1st556mm'
    ShellRotOffsetHip=(Pitch=-3000,Yaw=-3000)

    MuzzleBone="MuzzleNew2"
    FireLoopAnim="Shoot_Loop"
    FireEndAnim=""
    FireIronEndAnim=""
    FireIronLoopAnim="Iron_Shoot"

    FireAnim="Shoot"
    FireIronAnim="Iron_Shoot"

    RecoilRate=0.06
    MaxVerticalRecoilAngle=555  //keep in mind the first shot gets 0.8 coefficient
    MaxHorizontalRecoilAngle=120
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.8),(InVal=4.0,OutVal=1.1),(InVal=12.0,OutVal=1.3),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffFactor=18.0

    FireRate=0.09 // 739 rpm (value had to be found experimentally due to an engine bug)
    bHasSemiAutoFireRate=true
    SemiAutoFireRate=0.18
}
