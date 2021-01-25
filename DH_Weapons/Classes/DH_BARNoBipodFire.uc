//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_BARNoBipodFire extends DHAutomaticFire;

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
    ProjectileClass=class'DH_Weapons.DH_BARNoBipodBullet'
    AmmoClass=class'DH_Weapons.DH_BARAmmo'
    FireRate=0.2
    FAProjSpawnOffset=(X=-28.0)

    MuzzleBone=MuzzleNew

    // Spread
    HipSpreadModifier=6.0
    Spread=65.0

    // Recoil //adjusted from full variant
    RecoilRate=0.1
    MaxVerticalRecoilAngle=680
    MaxHorizontalRecoilAngle=150
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.7),(InVal=3.0,OutVal=0.8),(InVal=4.0,OutVal=1.0),(InVal=8.0,OutVal=1.15),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffExponent=4.0
    RecoilFallOffFactor=40.0

    FlashEmitterClass=class'ROEffects.MuzzleFlash1stPistol'
    FireSounds(0)=SoundGroup'DH_WeaponSounds.BAR.BAR_Fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.BAR.BAR_Fire02'

    BipodDeployFireAnim="iron_fire"
    //BipodDeployFireLoopAnim="SightUp_iron_shoot_loop"
    //BipodDeployFireEndAnim="SightUp_iron_shoot_end"
    FireAnim=fire
    FireIronAnim=Iron_fire
    ShellEmitBone=ejector3

    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mm'
    ShellIronSightOffset=(X=20.0,Y=0.0,Z=-2.0)
    ShellRotOffsetIron=(Pitch=500)
    ShellRotOffsetHip=(Pitch=-3000,Yaw=-5000)
    bReverseShellSpawnDirection=true

    ShakeRotMag=(X=45.0,Y=30.0,Z=120.0)
    ShakeRotTime=0.75
}
