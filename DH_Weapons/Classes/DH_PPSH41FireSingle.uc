//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DH_PPSH41FireSingle extends DHSemiAutoFire;

defaultproperties
{
    bWaitForRelease=true

    ProjectileClass=class'DH_Weapons.DH_PPSH41Bullet'
    AmmoClass=class'ROAmmo.SMG71Rd762x25Ammo'

    FireRate=0.0667
    Spread=330.0
    RecoilRate=0.03335
    MaxVerticalRecoilAngle=150
    MaxHorizontalRecoilAngle=80

    // Recoil
    PctStandIronRecoil=0.4
    PctCrouchIronRecoil=0.35
    PctProneIronRecoil=0.25

    // Anims (the loop anim works for a single)
    FireAnim="Shoot_Loop"
    FireLoopAnim="Shoot_Loop"
    FireEndAnim="Shoot_End"
    FireIronAnim="Iron_Shoot_Loop"
    FireIronLoopAnim="Iron_Shoot_Loop"
    FireIronEndAnim="Iron_Shoot_End"

    // Sounds
    FireSounds(0)=SoundGroup'DH_WeaponSounds.ppsh41.ppsh41_fire_single1'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.ppsh41.ppsh41_fire_single2'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.ppsh41.ppsh41_fire_single3'

    // Smoke and Flash
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stPPSH'
    SmokeEmitterClass=class'ROEffects.ROMuzzleSmoke'
    ShellEjectClass=class'ROAmmo.ShellEject1st762x25mm'
    ShellRotOffsetIron=(Pitch=11000)
    ShellIronSightOffset=(X=20.0,Y=0.0,Z=0.0)
}
