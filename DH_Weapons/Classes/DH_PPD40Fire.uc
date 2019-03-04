//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DH_PPD40Fire extends DHFastAutoFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_PPD40Bullet'
    AmmoClass=class'ROAmmo.SMG71Rd762x25Ammo'
    FireRate=0.075 // 800rpm
    Spread=185.0

    // Recoil
    RecoilRate=0.05
    MaxVerticalRecoilAngle=300
    MaxHorizontalRecoilAngle=115
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.4),(InVal=3.0,OutVal=0.8),(InVal=6.0,OutVal=1.35),(InVal=15.0,OutVal=1.5),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffFactor=14.0

    AmbientFireSound=SoundGroup'DH_WeaponSounds.ppd40.ppd40_fire_loop'
    FireEndSound=SoundGroup'DH_WeaponSounds.ppd40.ppd40_fire_end'
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stPPSH'
    ShellEjectClass=class'ROAmmo.ShellEject1st762x25mm'
    ShellRotOffsetIron=(Pitch=5000)
}
