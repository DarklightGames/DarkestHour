//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_PPS43Fire extends DHFastAutoFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_PPS43Bullet'
    AmmoClass=class'ROAmmo.PPS43Ammo'
    FireRate=0.0857 // 700 rpm
    Spread=135.0

    // Recoil
    RecoilRate=0.04285
    MaxVerticalRecoilAngle=260
    MaxHorizontalRecoilAngle=85
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.7),(InVal=5.0,OutVal=0.85),(InVal=15.0,OutVal=1.0),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffFactor=13.0

    AmbientFireSound=SoundGroup'DH_WeaponSounds.pps43.pps43_fire_loop'
    FireEndSound=SoundGroup'DH_WeaponSounds.pps43.pps43_fire_end'
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stPPSH'
    ShellEjectClass=class'ROAmmo.ShellEject1st762x25mm'
    ShellRotOffsetIron=(Pitch=5000)
}
