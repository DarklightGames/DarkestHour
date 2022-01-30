//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_SVT38Fire extends DHSemiAutoFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_SVT38Bullet'
    AmmoClass=class'ROAmmo.SVT40Ammo'
    Spread=55.0
    MaxVerticalRecoilAngle=510
    MaxHorizontalRecoilAngle=190
    FireRate=0.215

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
