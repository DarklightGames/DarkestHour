//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_KV1MG extends DHVehicleMG;

defaultproperties
{
    // MG mesh
    Mesh=SkeletalMesh'DH_KV_1and2_anm.KV_MG'
    FireEffectOffset=(X=-40.0,Y=-5.0,Z=0.0)
    WeaponAttachOffset=(X=2.0,Y=-3.5,Z=-1.0) // the MG mesh is off-kilter when not adjusted

    FireAttachBone="mg_yaw"

    // Movement
    MaxPositiveYaw=4000
    MaxNegativeYaw=-4500
    PitchBone="mg_pivot"
    YawBone="mg_pivot"
    CustomPitchUpLimit=3000
    CustomPitchDownLimit=63000

    // Ammo
    ProjectileClass=class'DH_Weapons.DH_DP27Bullet'
    InitialPrimaryAmmo=63
    NumMGMags=15
    FireInterval=0.105
    TracerProjectileClass=class'DH_Weapons.DH_DP27TracerBullet'
    TracerFrequency=5
    HudAltAmmoIcon=Texture'InterfaceArt_tex.HUD.dp27_ammo'

    // Weapon fire
    WeaponFireAttachmentBone="muzzle"
    WeaponFireOffset=-8
    AmbientSoundScaling=1.3 // TODO: compare to DH MGs that use 2.75
    FireSoundClass=SoundGroup'DH_WeaponSounds.dt_fire_loop'
    FireEndSound=SoundGroup'DH_WeaponSounds.dt.dt_fire_end'

    // Reload
    HUDOverlayReloadAnim="reload_tankmg"
    ReloadStages(0)=(Sound=none,Duration=1.76) //Sound'Inf_Weapons_Foley.dt.DT_reloadempty01_000'
    ReloadStages(1)=(Sound=none,Duration=2.29,HUDProportion=0.65) //Sound'Inf_Weapons_Foley.dt.DT_reloadempty02_052'
    ReloadStages(2)=(Sound=none,Duration=2.35) //Sound'Inf_Weapons_Foley.dt.DT_reloadempty03_121'
    ReloadStages(3)=(Sound=none,Duration=2.2,HUDProportion=0.35) //Sound'Inf_Weapons_Foley.dt.DT_reloadempty04_191'
    ShakeOffsetMag=(X=0.01,Y=0.01,Z=0.01)
}
