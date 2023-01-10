//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_G43Fire extends DHSemiAutoFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_G43Bullet'
    AmmoClass=class'ROAmmo.G43Ammo'
    Spread=45.0
    MaxVerticalRecoilAngle=740
    MaxHorizontalRecoilAngle=170
    FireRate=0.215

    //Recoil
    PctRestDeployRecoil=1   //0.5 default
    RecoilRate=0.075
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.5),(InVal=0.5,OutVal=0.5),(InVal=1.0,OutVal=1.0),(InVal=1.5,OutVal=1.5),(InVal=2.0,OutVal=2.0),(InVal=2.2,OutVal=2.2),(InVal=2.2,OutVal=2.4),(InVal=2.8,OutVal=2.8),(InVal=3.2,OutVal=2.8)))
    RecoilFallOffFactor=15.0

    FireSounds(0)=SoundGroup'DH_old_inf_Weapons.g43.g43shot1'
    FireSounds(1)=SoundGroup'DH_old_inf_Weapons.g43.g43shot2'
    FireSounds(2)=SoundGroup'DH_old_inf_Weapons.g43.g43shot3'
    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mm'
    ShellRotOffsetHip=(Pitch=-3000,Yaw=-3000)

    FireLastAnim="shoot_last"
    FireIronLastAnim="Iron_Shoot_Last"
    FireIronAnim="Iron_Shoot_g43"
    FireAnim="Shoot_g43"
}
