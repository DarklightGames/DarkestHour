//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
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

    // Recoil
    PctStandIronRecoil=0.4
    PctCrouchIronRecoil=0.35
    PctProneIronRecoil=0.25

    AmbientFireSound=SoundGroup'DH_WeaponSounds.ppsh41.ppsh41_fire_loop'
    FireEndSound=SoundGroup'DH_WeaponSounds.ppsh41.ppsh41_fire_end'
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stPPSH'
    ShellEjectClass=class'ROAmmo.ShellEject1st762x25mm'
    ShellRotOffsetIron=(Pitch=11000)
}
