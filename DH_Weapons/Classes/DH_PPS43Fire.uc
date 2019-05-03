//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_PPS43Fire extends DHFastAutoFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_PPS43Bullet'
    AmmoClass=class'ROAmmo.PPS43Ammo'
    FireRate=0.0857
    Spread=330.0
    RecoilRate=0.04285
    AmbientFireSound=SoundGroup'DH_WeaponSounds.pps43.pps43_fire_loop'
    FireEndSound=SoundGroup'DH_WeaponSounds.pps43.pps43_fire_end'
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stPPSH'
    ShellEjectClass=class'ROAmmo.ShellEject1st762x25mm'
    ShellRotOffsetIron=(Pitch=5000)
}
