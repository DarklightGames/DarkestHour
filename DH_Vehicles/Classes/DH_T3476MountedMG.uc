//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_T3476MountedMG extends DHVehicleMG;

defaultproperties
{
    // MG mesh
    Mesh=SkeletalMesh'DH_T34_anm.T34-76_MG'
    bMatchSkinToVehicle=true
    FireAttachBone="MG_placement"
    FireEffectOffset=(X=10.0,Y=4.0,Z=0.0)

    // Movement (reduced from original for more plausible looking limits)
    YawBone="MG_pivot"
    MaxPositiveYaw=4000
    MaxNegativeYaw=-4000
    PitchBone="MG_pivot"
    CustomPitchUpLimit=3000
    CustomPitchDownLimit=63500

    // Ammo
    ProjectileClass=Class'DH_DP27Bullet'
    InitialPrimaryAmmo=63
    NumMGMags=15
    FireInterval=0.105
    TracerProjectileClass=Class'DH_DP27TracerBullet'
    TracerFrequency=5
    HudAltAmmoIcon=Texture'InterfaceArt_tex.dp27_ammo'

    // Weapon fire
    WeaponFireAttachmentBone="Muzzle"
    WeaponFireOffset=-8
    AmbientSoundScaling=1.3 // TODO: compare to DH MGs that use 2.75
    FireSoundClass=SoundGroup'DH_WeaponSounds.dt_fire_loop'
    FireEndSound=SoundGroup'DH_WeaponSounds.dt_fire_end'

    // Reload
    HUDOverlayReloadAnim="reload_tankmg"
    ReloadStages(0)=(Sound=Sound'Inf_Weapons_Foley.DT_reloadempty01_000',Duration=1.76)
    ReloadStages(1)=(Sound=Sound'Inf_Weapons_Foley.DT_reloadempty02_052',Duration=2.29,HUDProportion=0.65)
    ReloadStages(2)=(Sound=Sound'Inf_Weapons_Foley.DT_reloadempty03_121',Duration=2.35)
    ReloadStages(3)=(Sound=Sound'Inf_Weapons_Foley.DT_reloadempty04_191',Duration=2.2,HUDProportion=0.35)
}
