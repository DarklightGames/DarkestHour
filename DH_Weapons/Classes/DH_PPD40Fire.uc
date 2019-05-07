//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_PPD40Fire extends DHFastAutoFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_PPD40Bullet'
    AmmoClass=class'ROAmmo.SMG71Rd762x25Ammo'
    FireRate=0.075
    Spread=340.0
    RecoilRate=0.05
    MaxVerticalRecoilAngle=390
    MaxHorizontalRecoilAngle=95
    AmbientFireSound=SoundGroup'DH_WeaponSounds.ppd40.ppd40_fire_loop'
    FireEndSound=SoundGroup'DH_WeaponSounds.ppd40.ppd40_fire_end'
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stPPSH'
    ShellEjectClass=class'ROAmmo.ShellEject1st762x25mm'
    ShellRotOffsetIron=(Pitch=5000)
}
