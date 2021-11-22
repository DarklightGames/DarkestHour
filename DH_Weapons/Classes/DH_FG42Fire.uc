//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_FG42Fire extends DHAutomaticFire; // TODO: could maybe use DHFastAutoFire/DHHighROFWeaponAttachment as fires at 750 rpm (higher than PPs-43 SMG's 700 rpm, which does use fast auto)

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_FG42Bullet'
    AmmoClass=class'DH_Weapons.DH_FG42Ammo'
    FireRate=0.08
    bHasSemiAutoFireRate=true
    SemiAutoFireRate=0.2
    FAProjSpawnOffset=(X=-28.0)

    // Spread
    HipSpreadModifier=5.0
    Spread=65.0

    // Recoil
    RecoilRate=0.06
    MaxVerticalRecoilAngle=620
    MaxHorizontalRecoilAngle=240
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.66),(InVal=4.0,OutVal=1.0),(InVal=12.0,OutVal=1.3),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffExponent=2.0
    RecoilFallOffFactor=12.0

    FireSounds(0)=SoundGroup'DH_WeaponSounds.FG42.FG42_Fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.FG42.FG42_Fire02'

    BipodDeployFireAnim="deploy_shoot_loop"
    BipodDeployFireLoopAnim="deploy_shoot_loop"
    BipodDeployFireEndAnim="deploy_shoot_end"

    //Ejected shell params
    ShellCaseEjectClass=class'DH_Effects.DHShellEject1st762x54mm'
    ShellEjectOffset=(X=0.0,Y=0.2,Z=0.0)
    ShellVelMinX=200.0
    ShellVelMaxX=350.0
    ShellVelMinY=0.0
    ShellVelMaxY=0.0
    ShellVelMinZ=-200.0
    ShellVelMaxZ=-300.0

    //bReverseShellSpawnDirection=true
    FlashEmitterClass=class'DH_Effects.DHMuzzleFlash1stMG'
    SmokeEmitterClass=class'DH_Effects.DHMuzzleSmoke'

    ShakeRotTime=0.75
}
