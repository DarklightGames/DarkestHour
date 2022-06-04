//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_PPS43Fire extends DHAutomaticFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_PPS43Bullet'
    AmmoClass=class'ROAmmo.PPS43Ammo'
    FireRate=0.095 // ~702 rpm (value had to be found experimentally due to an engine bug)
    Spread=135.0

    // Recoil
    RecoilRate=0.04285
    MaxVerticalRecoilAngle=270
    MaxHorizontalRecoilAngle=80
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.7),(InVal=6.0,OutVal=1.0),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffFactor=13.0

    FireSounds(0)=SoundGroup'DH_WeaponSounds.pps43.PPS43_Single1'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.pps43.PPS43_Single2'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.pps43.PPS43_Single3'
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stPPSH'
    ShellEjectClass=class'ROAmmo.ShellEject1st762x25mm'
    ShellRotOffsetIron=(Pitch=5000)

    FireIronLastAnim="iron_idle_empty"
}
