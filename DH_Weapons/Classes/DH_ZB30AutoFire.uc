//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_ZB30AutoFire extends DHAutomaticFire;

defaultproperties
{
    ProjectileClass=Class'DH_Weapons.DH_ZB30Bullet'
    AmmoClass=Class'DH_Weapons.DH_ZB30Ammo'
    FireRate=0.1 // 600 rpm
    FAProjSpawnOffset=(X=-20.000000)

    // Spread
    Spread=100.0

    // Recoil pct
    PctBipodDeployRecoil=0.02

    PctRestDeployRecoil=0.05

    // Recoil
    RecoilRate=0.05
    MaxVerticalRecoilAngle=500
    MaxHorizontalRecoilAngle=200

    FlashEmitterClass=Class'ROEffects.MuzzleFlash1stMG'
    // TODO: need new fire sounds (both single and auto?)
    //FireEndSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_end'
    //FireEndSound=SoundGroup'CC_Inf_Weapons.ZB30.zb30_fire_end'
    //AmbientFireSoundRadius=750.000000
    //AmbientFireSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_loop'
    //AmbientFireSound=SoundGroup'CC_Inf_Weapons.ZB30.zb30_fire_loop'
    //AmbientFireVolume=255
    //PackingThresholdTime=0.120000

    //BipodDeployFireAnim="Bipod_shoot_single"
    BipodDeployFireLoopAnim="Bipod_Shoot_Loop"
    BipodDeployFireEndAnim="Bipod_Shoot_End"

    FireIronAnim="is_shoot_loop"
    FireIronLoopAnim="is_shoot_loop"
    FireIronEndAnim="is_shoot_end"
    FireAnim="hip_shoot_loop"
    FireLoopAnim="hip_shoot_loop"
    FireEndAnim="Hip_Shoot_End"

    ProjSpawnOffset=(X=25.000000)
    TracerFrequency=5

    ShellEjectClass=Class'ROAmmo.ShellEject1st762x54mm'
    ShellIronSightOffset=(X=20.0,Z=-10.0)
    ShellHipOffset=(Y=-7.0)
    ShellRotOffsetIron=(Pitch=-13000)
    ShellRotOffsetHip=(Pitch=-13000)


}
