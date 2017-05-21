//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_M3A1HalftrackMG extends DHVehicleMG;

defaultproperties
{
    // MG mesh
    Mesh=SkeletalMesh'DH_M3A1Halftrack_anm.m3halftrack_gun'
    Skins(0)=texture'DH_Weapon_tex.AlliedSmallArms.30calMain'
    Skins(1)=texture'DH_Weapon_tex.AlliedSmallArms.30calGrip'
    Skins(2)=texture'DH_Weapon_tex.AmmoPouches.30CalAmmoTin'
    Skins(3)=texture'DH_VehiclesUS_tex.ext_vehicles.Green'
    bForceSkelUpdate=true // necessary for new player hit detection system, as makes server update the MG mesh skeleton, which it wouldn't otherwise as server doesn't draw mesh
    GunnerAttachmentBone="com_attachment"

    // Movement
    RotationsPerSecond=0.5
    YawBone="Gun_protection"
    MaxPositiveYaw=12000
    MaxNegativeYaw=-12000
    PitchBone="Gun_protection"
    CustomPitchUpLimit=5000
    CustomPitchDownLimit=63000

    // Ammo
    ProjectileClass=class'DH_Weapons.DH_30CalBullet'
    InitialPrimaryAmmo=250
    NumMGMags=30
    FireInterval=0.12
    TracerProjectileClass=class'DH_Weapons.DH_30CalTracerBullet'
    TracerFrequency=5

    // Weapon fire
    WeaponFireAttachmentBone="tip"
    AmbientEffectEmitterClass=class'DH_Vehicles.DH_Vehicle30CalMGEmitter'
    FireSoundClass=SoundGroup'DH_WeaponSounds.30Cal.30cal_FireLoop01'
    FireEndSound=SoundGroup'DH_WeaponSounds.30Cal.30cal_FireEnd01'
    ShakeRotMag=(X=25.0,Y=0.0,Z=10.0)
    ShakeRotRate=(X=5000.0,Y=5000.0,Z=5000.0)
    ShakeOffsetMag=(X=0.5,Y=0.0,Z=0.2)
    ShakeOffsetRate=(X=500.0,Y=500.0,Z=500.0)

    // Reload
    HUDOverlayReloadAnim="Reloads"
    ReloadStages(0)=(Sound=none,Duration=1.44) // no sounds because HUD overlay reload animation plays them
    ReloadStages(1)=(Sound=none,Duration=1.52)
    ReloadStages(2)=(Sound=none,Duration=1.99)
    ReloadStages(3)=(Sound=none,Duration=1.75)
}
