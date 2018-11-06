//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DH_MP40Fire extends DHAutomaticFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_MP40Bullet'
    AmmoClass=class'ROAmmo.MP32Rd9x19Ammo'
    FireRate=0.13
    Spread=328.0
    RecoilRate=0.05
    MaxVerticalRecoilAngle=250
    MaxHorizontalRecoilAngle=32

    // Recoil percentages
    PctStandIronRecoil=0.55
    PctCrouchIronRecoil=0.45
    PctProneIronRecoil=0.3

    FlashEmitterClass=class'ROEffects.MuzzleFlash1stMP'
    FireSounds(0)=SoundGroup'DH_WeaponSounds.mp40.mp40_fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.mp40.mp40_fire02'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.mp40.mp40_fire03'
    NoAmmoSound=Sound'Inf_Weapons_Foley.Misc.dryfire_smg'
    ShellEjectClass=class'ROAmmo.ShellEject1st9x19mm'
}
