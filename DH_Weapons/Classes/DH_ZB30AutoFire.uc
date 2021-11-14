//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_ZB30AutoFire extends DHAutomaticFire;

defaultproperties
{
    ProjectileClass=Class'DH_Weapons.DH_ZB30Bullet'
    AmmoClass=Class'DH_Weapons.DH_FG42Ammo'
    FireRate=0.1 // 600 rpm
    FAProjSpawnOffset=(X=-20.000000)

    // Spread
    HipSpreadModifier=6.0
    Spread=65.0

    // Recoil
    RecoilRate=0.05
    MaxVerticalRecoilAngle=590
    MaxHorizontalRecoilAngle=220
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.66),(InVal=2.0,OutVal=0.8),(InVal=3.0,OutVal=1.0),(InVal=6.0,OutVal=1.0),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffExponent=2.0
    RecoilFallOffFactor=6.0

    FlashEmitterClass=Class'ROEffects.MuzzleFlash1stMG'
    
    FireSounds(0)=SoundGroup'DH_WeaponSounds.Bren.Bren_Fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.Bren.Bren_Fire02'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.Bren.Bren_Fire03'

    // TODO: need new fire sounds (both single and auto?) <---leftover comments from WIP CC port (it does need new sound though)
    //FireEndSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_end'
    //FireEndSound=SoundGroup'CC_Inf_Weapons.ZB30.zb30_fire_end'
    //AmbientFireSoundRadius=750.000000
    //AmbientFireSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_loop'
    //AmbientFireSound=SoundGroup'CC_Inf_Weapons.ZB30.zb30_fire_loop'
    //AmbientFireVolume=255
    //PackingThresholdTime=0.120000

    BipodDeployFireAnim="deploy_shoot"
    FireIronAnim="iron_shoot"
    FireAnim="shoot"

    ProjSpawnOffset=(X=25.000000)
    TracerFrequency=5

    ShellEjectClass=Class'ROAmmo.ShellEject1st762x54mm'
    ShellIronSightOffset=(X=20.0,Z=-10.0)
    ShellHipOffset=(Y=-7.0)
    ShellRotOffsetIron=(Pitch=-13000)
    ShellRotOffsetHip=(Pitch=-13000)


}
