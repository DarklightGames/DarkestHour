//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_Breda30Fire extends DHAutomaticFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_Breda30Bullet'
    TracerProjectileClass=class'DH_Weapons.DH_Breda30TracerBullet'
    bUsesTracers=true
    TracerFrequency=5
    AmmoClass=class'DH_Weapons.DH_Breda30Ammo'
    FireRate=0.14 // ~500 rpm
    FAProjSpawnOffset=(X=-28.0)

    Spread=70.0
    HipSpreadModifier=6.0

    // Recoil
    RecoilRate=0.05
    MaxVerticalRecoilAngle=580
    MaxHorizontalRecoilAngle=230
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.66),(InVal=2.0,OutVal=0.8),(InVal=3.0,OutVal=1.0),(InVal=6.0,OutVal=1.0),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffExponent=2.0
    RecoilFallOffFactor=6.0

    FlashEmitterClass=Class'ROEffects.MuzzleFlash1stMG'
    
    FireSounds(0)=SoundGroup'DH_WeaponSounds.Bren.Bren_Fire01'  // TODO: give me custom sounds or give me death
    FireSounds(1)=SoundGroup'DH_WeaponSounds.Bren.Bren_Fire02'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.Bren.Bren_Fire03'
    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mm' // TODO: replace with wacky italian 6.5×52mm Carcano
    ShellIronSightOffset=(X=10.0,Y=0.0,Z=-5.0)
    ShellRotOffsetIron=(Pitch=-16200)
    bReverseShellSpawnDirection=true
    BipodDeployFireAnim="deploy_shoot"
    FireAnim="shoot"

    ShakeOffsetMag=(X=2.0,Y=1.0,Z=2.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=1.0
    ShakeRotMag=(X=50.0,Y=50.0,Z=90.0)
    ShakeRotRate=(X=10000.0,Y=10000.0,Z=10000.0)
    ShakeRotTime=1.2
}
