//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_FG42Fire extends DHAutomaticFire; // TODO: could maybe use DHFastAutoFire/DHHighROFWeaponAttachment as fires at 750 rpm (higher than PPs-43 SMG's 700 rpm, which does use fast auto)

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_FG42Bullet'
    AmmoClass=class'DH_Weapons.DH_FG42Ammo'
    FireRate=0.08
    FAProjSpawnOffset=(X=-28.0)

    Spread=160.0
    RecoilRate=0.06

    // Recoil
    PctStandIronRecoil=0.4
    PctCrouchRecoil=0.8
    PctCrouchIronRecoil=0.35
    PctProneRecoil=0.7
    PctProneIronRecoil=0.2
    PctBipodDeployRecoil=0.05
    PctRestDeployRecoil=0.065
    PctLeanPenalty=1.15

    MaxVerticalRecoilAngle=400
    MaxHorizontalRecoilAngle=160

    FireSounds(0)=SoundGroup'DH_WeaponSounds.FG42.FG42_Fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.FG42.FG42_Fire02'

    BipodDeployFireAnim="deploy_shoot_loop"
    BipodDeployFireLoopAnim="deploy_shoot_loop"
    BipodDeployFireEndAnim="deploy_shoot_end"

    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mm'
    ShellIronSightOffset=(X=20.0,Y=0.0,Z=-2.0)
    ShellRotOffsetIron=(Pitch=500)
    ShellRotOffsetHip=(Pitch=-3000,Yaw=-5000)
    bReverseShellSpawnDirection=true

    ShakeRotTime=0.75
}
