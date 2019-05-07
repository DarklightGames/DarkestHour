//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_BrenFire extends DHAutomaticFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_BrenBullet'
    TracerProjectileClass=class'DH_Weapons.DH_BrenTracerBullet'
    bUsesTracers=true
    TracerFrequency=5
    AmmoClass=class'DH_Weapons.DH_BrenAmmo'
    FireRate=0.12
    FAProjSpawnOffset=(X=-28.0)
    Spread=125.0
    RecoilRate=0.075
    PctBipodDeployRecoil=0.05
    PctRestDeployRecoil=0.1
    MaxVerticalRecoilAngle=500
    MaxHorizontalRecoilAngle=90
    FireSounds(0)=SoundGroup'DH_WeaponSounds.Bren.Bren_Fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.Bren.Bren_Fire02'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.Bren.Bren_Fire03'
    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mm'
    ShellIronSightOffset=(X=10.0,Y=0.0,Z=-5.0)
    ShellRotOffsetIron=(Pitch=-16200)
    bReverseShellSpawnDirection=true
    BipodDeployFireAnim="deploy_shoot_loop"
    BipodDeployFireLoopAnim="deploy_shoot_loop"
    BipodDeployFireEndAnim="deploy_shoot_end"
    ShakeRotMag=(X=50.0,Y=50.0,Z=175.0)
    ShakeRotTime=0.75
}
