//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_BARFire extends DHAutomaticFire;

function ModeTick(float DeltaTime) // TODO: why is this tick override only added to the BAR? (it's probably pointless)
{
    super.ModeTick(DeltaTime);

    if (bIsFiring && !AllowFire())
    {
        Weapon.StopFire(ThisModeNum);
    }
}

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_BARBullet'
    AmmoClass=class'DH_Weapons.DH_BARAmmo'
    FireRate=0.2
    FAProjSpawnOffset=(X=-28.0)

    Spread=130.0
    HipSpreadModifier=6.0
    RecoilRate=0.1
    PctStandIronRecoil=0.7
    PctCrouchRecoil=0.65
    PctCrouchIronRecoil=0.45
    PctProneIronRecoil=0.25
    PctBipodDeployRecoil=0.05
    PctRestDeployRecoil=0.1
    MaxVerticalRecoilAngle=800
    MaxHorizontalRecoilAngle=150

    FlashEmitterClass=class'ROEffects.MuzzleFlash1stPistol'
    FireSounds(0)=SoundGroup'DH_WeaponSounds.BAR.BAR_Fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.BAR.BAR_Fire02'

    PreFireAnim="Shoot1_start"
    BipodDeployFireAnim="SightUp_iron_shoot_loop"
    BipodDeployFireLoopAnim="SightUp_iron_shoot_loop"
    BipodDeployFireEndAnim="SightUp_iron_shoot_end"

    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mm'
    ShellIronSightOffset=(X=20.0,Y=0.0,Z=-2.0)
    ShellRotOffsetIron=(Pitch=500)
    ShellRotOffsetHip=(Pitch=-3000,Yaw=-5000)
    bReverseShellSpawnDirection=true

    ShakeRotMag=(X=45.0,Y=30.0,Z=120.0)
    ShakeRotTime=0.75
}
