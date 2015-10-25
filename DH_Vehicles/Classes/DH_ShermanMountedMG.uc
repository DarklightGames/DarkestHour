//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ShermanMountedMG extends DHVehicleMG;

defaultproperties
{
    NumMags=6
    FireAttachBone="mg_yaw"
    TracerProjectileClass=class'DH_Weapons.DH_30CalTracerBullet'
    TracerFrequency=5
    hudAltAmmoIcon=texture'InterfaceArt_tex.HUD.mg42_ammo'
    YawBone="mg_yaw"
    PitchBone="mg_yaw"
    PitchUpLimit=15000
    PitchDownLimit=45000
    CustomPitchUpLimit=3000
    CustomPitchDownLimit=63000
    WeaponFireAttachmentBone="mg_yaw"
    WeaponFireOffset=8.0
    bInstantFire=false
    Spread=0.002
    FireInterval=0.12
    FireSoundClass=SoundGroup'DH_AlliedVehicleSounds2.3Cal.V30cal_loop01'
    FireEndSound=SoundGroup'DH_AlliedVehicleSounds2.3Cal.V30cal_end01'
    ProjectileClass=class'DH_Weapons.DH_30CalBullet'
    ShakeRotMag=(X=20.0,Y=20.0,Z=20.0)
    ShakeOffsetMag=(X=0.01,Y=0.01,Z=0.01)
    MaxPositiveYaw=4000
    MaxNegativeYaw=-8000
    bLimitYaw=true
    InitialPrimaryAmmo=200
    FireEffectOffset=(X=-40,Y=0.0,Z=30.0) // positions fire on co-driver's hatch
    Mesh=SkeletalMesh'DH_ShermanM4A1_anm.Sherman_MG'
}
