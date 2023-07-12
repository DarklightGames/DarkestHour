//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_M7PriestMG extends DHVehicleMG;

defaultproperties
{
    // MG mesh
    Mesh=SkeletalMesh'DH_M7Priest_anm.priest_mg_ext'
    Skins(0)=Texture'DH_M7Priest_tex.ext_vehicles.M7Priest'
    Skins(1)=Texture'DH_Weapon_tex.AlliedSmallArms.50CalMain'
    bForceSkelUpdate=true // necessary for new player hit detection system, as makes server update the MG mesh skeleton, which it wouldn't otherwise as server doesn't draw mesh
    GunnerAttachmentBone="com_attachment"
    FireEffectClass=none // there's no MG hatch & the 'turret' fire effect fills the open superstructure

    // Movement
    RotationsPerSecond=0.5
    YawBone="yaw"
    bLimitYaw=false
    PitchBone="pitch"
    CustomPitchUpLimit=5000
    CustomPitchDownLimit=63400

    // Ammo
    ProjectileClass=class'DH_Vehicles.DH_50CalVehicleBullet'
    InitialPrimaryAmmo=105
    NumMGMags=3
    FireInterval=0.133333 // 450 RPM
    TracerProjectileClass=class'DH_Vehicles.DH_50CalVehicleTracerBullet'
    TracerFrequency=5
//  HudAltAmmoIcon=Texture'InterfaceArt_tex.HUD.50cal_ammo' // TODO: get this ammo icon made for a 50 cal ammo tin (with matching '50cal_ammo_reload' VehicleMGReloadTexture in MG pawn)

    // Weapon fire
    WeaponFireAttachmentBone="tip"
    AmbientEffectEmitterClass=class'DH_Vehicles.DH_Vehicle50CalMGEmitter'
    FireSoundClass=SoundGroup'DH_WeaponSounds.50Cal.50Cal_fire_loop'
    FireEndSound=SoundGroup'DH_WeaponSounds.50Cal.50Cal_fire_end'
    AmbientSoundScaling=5.0
    ShakeRotMag=(X=25.0,Y=0.0,Z=10.0)
    ShakeRotRate=(X=5000.0,Y=5000.0,Z=5000.0)
    ShakeOffsetMag=(X=0.5,Y=0.0,Z=0.2)
    ShakeOffsetRate=(X=500.0,Y=500.0,Z=500.0)

    // Reload
    HUDOverlayReloadAnim="Reload"
    ReloadStages(0)=(Sound=none,Duration=1.44) // no sounds because HUD overlay reload animation plays them
    ReloadStages(1)=(Sound=none,Duration=1.52)
    ReloadStages(2)=(Sound=none,Duration=2.05)
    ReloadStages(3)=(Sound=none,Duration=2.05)
}
