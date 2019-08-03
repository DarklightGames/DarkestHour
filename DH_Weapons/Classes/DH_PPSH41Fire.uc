//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_PPSH41Fire extends DHFastAutoFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_PPSH41Bullet'
    AmmoClass=class'ROAmmo.SMG71Rd762x25Ammo'
    FireRate=0.0667 // 900rpm
    Spread=180.0

    // Recoil
    RecoilRate=0.03335
    MaxVerticalRecoilAngle=280
    MaxHorizontalRecoilAngle=120
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.5),(InVal=5.0,OutVal=0.66),(InVal=10.0,OutVal=1.3),(InVal=15.0,OutVal=1.0),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffFactor=18.0

    AmbientFireSound=SoundGroup'DH_WeaponSounds.ppsh41.ppsh41_fire_loop'
    FireEndSound=SoundGroup'DH_WeaponSounds.ppsh41.ppsh41_fire_end'
    FireSounds(0)=SoundGroup'DH_WeaponSounds.ppsh41.ppsh41_fire_single1'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.ppsh41.ppsh41_fire_single2'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.ppsh41.ppsh41_fire_single3'

    FlashEmitterClass=class'ROEffects.MuzzleFlash1stPPSH'
    ShellEjectClass=class'ROAmmo.ShellEject1st762x25mm'
    ShellRotOffsetIron=(Pitch=11000)
}
