//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_T3476MountedMG extends DHVehicleMG;

defaultproperties
{
    // MG mesh
    Mesh=SkeletalMesh'DH_T34_anm.T34-76_MG'
    bMatchSkinToVehicle=true
    FireAttachBone="MG_pivot"
    FireEffectOffset=(X=10.0,Y=4.0,Z=0.0)

    // Movement (reduced from original for more plausible looking limits)
    YawBone="MG_pivot"
    MaxPositiveYaw=4000
    MaxNegativeYaw=-4000
    PitchBone="MG_pivot"
    CustomPitchUpLimit=3000
    CustomPitchDownLimit=63500

    // Ammo
    ProjectileClass=class'DH_Weapons.DH_DP28Bullet'
    InitialPrimaryAmmo=60
    NumMGMags=15
    FireInterval=0.1
    TracerProjectileClass=class'DH_Weapons.DH_DP28TracerBullet'
    TracerFrequency=5
    HudAltAmmoIcon=texture'InterfaceArt_tex.HUD.dp27_ammo'

    // Weapon fire
    WeaponFireAttachmentBone="Muzzle"
    WeaponFireOffset=-8
    AmbientSoundScaling=1.3 // TODO: compare to DH MGs that use 2.75
    FireSoundClass=SoundGroup'Inf_Weapons.dt_fire_loop'
    FireEndSound=SoundGroup'Inf_Weapons.dt.dt_fire_end'

    // Reload
    ReloadStages(0)=(Sound=sound'Inf_Weapons_Foley.dt.DT_reloadempty01_000',Duration=1.76)                    // TODO: sound is 1.76 duration vs 1.667 in anim notify (also below)
    ReloadStages(1)=(Sound=sound'Inf_Weapons_Foley.dt.DT_reloadempty02_052',Duration=2.29,HUDProportion=0.65) // 2.29 / 2.333
    ReloadStages(2)=(Sound=sound'Inf_Weapons_Foley.dt.DT_reloadempty03_121',Duration=2.35)                    // 2.35 / 2.333
    ReloadStages(3)=(Sound=sound'Inf_Weapons_Foley.dt.DT_reloadempty04_191',Duration=3.2,HUDProportion=0.35)  // 4.04 / 3.267
}
