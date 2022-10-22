//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_DP27LateFire extends DHFastAutoFire;

// Modified to rotate the magazine after a shot.
event ModeDoFire()
{
    local DH_DP27Weapon W;

    super.ModeDoFire();

    if (Instigator.IsLocallyControlled())
    {
        W = DH_DP27Weapon(Weapon);

        if (W != none)
        {
            W.UpdateMagRotation();
        }
    }
}

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_DP27Bullet'
    TracerProjectileClass=class'DH_Weapons.DH_DP27TracerBullet'
    AmmoClass=class'DH_Weapons.DH_DP27Ammo'
    FireRate=0.105 // 632 rpm (value had to be found experimentally due to an engine bug)
    TracerFrequency=5
    FAProjSpawnOffset=(X=-20.0)
    Spread=70.0

    // Recoil
    RecoilRate=0.05
    PctBipodDeployRecoil=0.075 // 0.1 by default
    MaxVerticalRecoilAngle=840  // these values are high because of custom recoil modifier for bipod being 0.075
    MaxHorizontalRecoilAngle=340
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.6),(InVal=6.0,OutVal=1.0),(InVal=10.0,OutVal=1.2),(InVal=16.0,OutVal=0.8),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffExponent=4.0
    RecoilFallOffFactor=24.0

    AmbientFireSound=SoundGroup'DH_WeaponSounds.DP28.DP28_fire_loop'
    FireEndSound=SoundGroup'DH_WeaponSounds.DP28.DP28_fire_end'
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stDP'
    BipodDeployFireAnim="Deploy_shoot_loop"
    BipodDeployFireLoopAnim="Deploy_Shoot_Loop"
    BipodDeployFireEndAnim="Deploy_Shoot_End"
    FireAnim="shoot_loop"
    FireLoopAnim="shoot_loop"
    FireEndAnim="Shoot_End"

    FireLastAnim="shoot_last"
    BipodDeployFireLastAnim="deploy_shoot_last"

    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mmGreen'
    ShellIronSightOffset=(X=0.0,Y=0.0,Z=0.0)
    ShellHipOffset=(X=-24.0,Y=0.0,Z=0.0)
    ShellRotOffsetIron=(Pitch=-16384)  
    ShellRotOffsetHip=(Pitch=-16384)

    ShakeOffsetMag=(X=2.0,Y=1.0,Z=2.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=1.0
    ShakeRotMag=(X=50.0,Y=50.0,Z=90.0)
    ShakeRotRate=(X=10000.0,Y=10000.0,Z=10000.0)
    ShakeRotTime=1.2
}
