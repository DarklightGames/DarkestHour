//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_G41Fire extends DHSemiAutoFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_G41Bullet'
    AmmoClass=class'DH_Weapons.DH_EnfieldNo4Ammo'
    FireRate=0.215
    Spread=50.0

    //Recoil
    PctRestDeployRecoil=1   //0.5 default
    RecoilRate=0.075
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.5),(InVal=0.5,OutVal=0.5),(InVal=1.0,OutVal=1.0),(InVal=1.5,OutVal=1.5),(InVal=2.0,OutVal=2.0),(InVal=2.2,OutVal=2.2),(InVal=2.2,OutVal=2.4),(InVal=2.8,OutVal=2.8),(InVal=3.2,OutVal=2.8)))
    RecoilFallOffFactor=15.0

    MaxVerticalRecoilAngle=700
    MaxHorizontalRecoilAngle=310  //heavy, but very unbalanced with awkward gas automatic system
    FireSounds(0)=SoundGroup'DH_WeaponSounds.g41.g41_fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.g41.g41_fire02'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.g41.g41_fire03'
    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mm'
    ShellRotOffsetHip=(Pitch=-3000,Yaw=-3000)

    FireLastAnim="shoot_last"
    FireIronLastAnim="Iron_Shoot_Last"
}
