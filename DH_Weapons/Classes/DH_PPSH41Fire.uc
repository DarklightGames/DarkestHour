//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_PPSH41Fire extends DHFastAutoFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_PPSH41Bullet'
    AmmoClass=class'ROAmmo.SMG71Rd762x25Ammo'

    FireRate=0.0667
    Spread=360.0
    RecoilRate=0.03335
    MaxVerticalRecoilAngle=280
    MaxHorizontalRecoilAngle=85

    // Recoil percentages
    PctStandIronRecoil=0.55
    PctCrouchIronRecoil=0.45
    PctProneIronRecoil=0.3

    AmbientFireSound=SoundGroup'DH_WeaponSounds.ppsh41.ppsh41_fire_loop'
    FireEndSound=SoundGroup'DH_WeaponSounds.ppsh41.ppsh41_fire_end'
    FireSounds(0)=SoundGroup'DH_WeaponSounds.ppsh41.ppsh41_fire_single1'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.ppsh41.ppsh41_fire_single2'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.ppsh41.ppsh41_fire_single3'
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stPPSH'
    ShellEjectClass=class'ROAmmo.ShellEject1st762x25mm'
    ShellRotOffsetIron=(Pitch=11000)
}
