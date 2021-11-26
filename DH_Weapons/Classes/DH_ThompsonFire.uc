//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_ThompsonFire extends DHAutomaticFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_ThompsonBullet'
    AmmoClass=class'DH_Weapons.DH_ThompsonAmmo'
    FireRate=0.092307 // 650rpm
    Spread=140.0

    // Recoil
    RecoilRate=0.05
    MaxVerticalRecoilAngle=300
    MaxHorizontalRecoilAngle=90
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.5),(InVal=3.0,OutVal=0.66),(InVal=6.0,OutVal=1.2),(InVal=15.0,OutVal=1.0),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffFactor=12.0

    FlashEmitterClass=class'ROEffects.MuzzleFlash1stPistol'
    FireSounds(0)=SoundGroup'DH_WeaponSounds.Thompson.Thompson_FireG1'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.Thompson.Thompson_FireG2'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.Thompson.Thompson_FireG3'
    NoAmmoSound=Sound'Inf_Weapons_Foley.Misc.dryfire_smg'
    PreFireAnim="Shoot1_start"

    //EjectedShellParams
    ShellCaseEjectClass=class'DH_Effects.DHShellEject1st9x19mm'
    //ShellEjectOffset=(X=0.0,Y=-1.0,Z=0.0)
    ShellVelMinX=200.0
    ShellVelMaxX=300.0
    ShellVelMinY=50.0 //200
    ShellVelMaxY=-50.0 //300.0
    ShellVelMinZ=-25.0
    ShellVelMaxZ=25.0)
}
