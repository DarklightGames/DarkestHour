//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_M712Fire extends DHFastAutoFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_M712Bullet'
    AmmoClass=class'DH_Weapons.DH_M712Ammo'
    FireRate=0.075 // 913 rpm (value had to be found experimentally due to an engine bug)
    Spread=180.0

    // Recoil
    RecoilRate=0.05
    MaxVerticalRecoilAngle=275
    MaxHorizontalRecoilAngle=120
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.3),(InVal=2.0,OutVal=0.7),(InVal=6.0,OutVal=1.3),(InVal=15.0,OutVal=1.0),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffFactor=10.0

    AmbientFireSound=SoundGroup'DH_WeaponSounds.c96.C96_FireLoop01'
    FireSounds(0)=SoundGroup'DH_WeaponSounds.c96.C96_FireSingle01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.c96.C96_FireSingle02'
    FireEndSound=SoundGroup'DH_WeaponSounds.c96.C96_FireEnd01'
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stPistol'

    ShellEjectClass=class'ROAmmo.ShellEject1st9x19mm'
    ShellRotOffsetIron=(Pitch=5000)

    FireIronLastAnim="iron_shoot_last"
    FireLastAnim="shoot_last"
}
