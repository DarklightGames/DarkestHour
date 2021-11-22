//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
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

    // Spread
    HipSpreadModifier=6.0
    Spread=65.0

    // Recoil
    RecoilRate=0.1
    MaxVerticalRecoilAngle=670
    MaxHorizontalRecoilAngle=180
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.6),(InVal=2.0,OutVal=0.8),(InVal=3.0,OutVal=1.0),(InVal=6.0,OutVal=1.2),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffExponent=4.0
    RecoilFallOffFactor=40.0

    //Effects
    MuzzleBone=Muzzle
    MuzzleOffset=(X=-0.5,Z=0.18)
    FlashEmitterClass=class'DH_Effects.DHMuzzleFlash1stKar'
    FireSounds(0)=SoundGroup'DH_WeaponSounds.BAR.BAR_Fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.BAR.BAR_Fire02'

    BipodDeployFireAnim="iron_fire"
    //BipodDeployFireLoopAnim="SightUp_iron_shoot_loop"
    //BipodDeployFireEndAnim="SightUp_iron_shoot_end"
    FireAnim=fire
    FireIronAnim=Iron_fire

    //Ejected shell params
    ShellCaseEjectClass=class'DH_Effects.DHShellEject1st762x54mm'
    ShellEmitBone=ejector3
    ShellEjectOffset=(X=2.0,Y=-5.0,Z=-0.5)
    //ShellEjectRotate=(Yaw=50000)
    //ShellEjectRotate=(Pitch=25000,Yaw=5000)
    ShellVelMinX=100.0
    ShellVelMaxX=350.0
    ShellVelMinY=250.0
    ShellVelMaxY=450.0
    ShellVelMinZ=200.0
    ShellVelMaxZ=250.0
    bReverseShellSpawnDirection=true

    ShakeRotMag=(X=45.0,Y=30.0,Z=120.0)
    ShakeRotTime=0.75
}
