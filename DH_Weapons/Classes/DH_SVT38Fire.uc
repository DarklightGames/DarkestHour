//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_SVT38Fire extends DHSemiAutoFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_SVT38Bullet'
    AmmoClass=class'DH_Weapons.DH_SVT38Ammo'
    Spread=55.0
    MaxVerticalRecoilAngle=510
    MaxHorizontalRecoilAngle=190
    FireRate=0.215

    //Recoil
    PctRestDeployRecoil=1   //0.5 default
    RecoilRate=0.075
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.5),(InVal=0.5,OutVal=0.5),(InVal=1.0,OutVal=1.0),(InVal=1.5,OutVal=1.5),(InVal=2.0,OutVal=2.0),(InVal=2.2,OutVal=2.2),(InVal=2.2,OutVal=2.4),(InVal=2.8,OutVal=2.8),(InVal=2.9,OutVal=2.8)))
    RecoilFallOffFactor=15.0

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

    FireLastAnim="shoot_last"
    FireIronLastAnim="Iron_Shoot_Last"
}
