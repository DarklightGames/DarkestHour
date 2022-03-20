//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
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

    Spread=70.0

    // Recoil
    RecoilRate=0.075
    MaxVerticalRecoilAngle=550
    MaxHorizontalRecoilAngle=250
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.5),(InVal=5.0,OutVal=0.6),(InVal=10.0,OutVal=0.9),(InVal=20.0,OutVal=1.0),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffExponent=2.0
    RecoilFallOffFactor=6.0

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
