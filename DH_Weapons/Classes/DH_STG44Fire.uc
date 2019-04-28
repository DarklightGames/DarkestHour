//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DH_STG44Fire extends DHAutomaticFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_STG44Bullet'
    AmmoClass=class'ROAmmo.STG44Ammo'
    FAProjSpawnOffset=(X=-28.0)
    FireRate=0.14

    Spread=105.0

    // Recoil
    RecoilRate=0.07
    MaxVerticalRecoilAngle=290
    MaxHorizontalRecoilAngle=110
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.35),(InVal=3.0,OutVal=0.66),(InVal=8.0,OutVal=1.15),(InVal=15.0,OutVal=1.0),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffFactor=16.0

    FireSounds(0)=SoundGroup'DH_WeaponSounds.stg44.stg44_fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.stg44.stg44_fire02'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.stg44.stg44_fire03'
    ShellEjectClass=class'ROAmmo.ShellEject1st556mm'
    ShellIronSightOffset=(X=15.0,Y=0.0,Z=-2.5)
    ShellRotOffsetIron=(Pitch=2000)
    bReverseShellSpawnDirection=true
    ShakeRotMag=(X=50.0,Y=50.0,Z=175.0)
    ShakeRotTime=0.75
}
