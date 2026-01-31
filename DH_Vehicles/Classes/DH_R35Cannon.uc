//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_R35Cannon extends DHVehicleCannon;

defaultproperties
{
    // Turret mesh
    Mesh=SkeletalMesh'DH_R35_anm.R35_TURRET_ITA_EXT'
    // Skins(0)=Texture'DH_VehiclesUS_tex.M5_body_ext'
    // Skins(1)=Texture'DH_VehiclesUS_tex.M5_turret_int'
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_R35_stc.R35_TURRET_YAW_COLLISION_ITA',AttachBone="YAW")
    CollisionStaticMeshes(1)=(CollisionStaticMesh=StaticMesh'DH_R35_stc.R35_TURRET_PITCH_COLLISION',AttachBone="PITCH")

    YawBone="YAW"
    PitchBone="PITCH"
    WeaponFireAttachmentBone="MUZZLE"
    AltFireAttachmentBone="MG_MUZZLE"
    AltFireOffset=(X=-10,Y=0,Z=0)

    // TODO: set up these values properly
    // Turret armor
    FrontArmorFactor=5.1
    RightArmorFactor=3.2
    LeftArmorFactor=3.2
    RearArmorFactor=3.2
    FrontArmorSlope=10.0
    FrontLeftAngle=323.0
    FrontRightAngle=37.0
    RearRightAngle=143.0
    RearLeftAngle=217.0

    // Turret movement
    ManualRotationsPerSecond=0.04
    CustomPitchUpLimit=3641
    CustomPitchDownLimit=63352

    // Cannon ammo
    PrimaryProjectileClass=Class'DH_R35CannonShell'
    SecondaryProjectileClass=Class'DH_R35CannonShellHE'
    TertiaryProjectileClass=Class'DH_R35CannonShellCanister'

    ProjectileDescriptions(0)="APCBC"
    ProjectileDescriptions(1)="HE"
    ProjectileDescriptions(2)="Canister"

    nProjectileDescriptions(0)="APCBC Mle 1935"
    nProjectileDescriptions(1)="HE Mle 1937"
    nProjectileDescriptions(2)="Canister Mle 1918"

    // TODO: get ammo counts, apparently thesse were quite low.
    InitialPrimaryAmmo=60
    InitialSecondaryAmmo=30
    InitialTertiaryAmmo=15
    MaxPrimaryAmmo=64
    MaxSecondaryAmmo=44
    MaxTertiaryAmmo=20
    SecondarySpread=0.00145
    TertiarySpread=0.04

    // Coaxial MG ammo
    AltFireProjectileClass=Class'DH_ReibelMGBullet'
    InitialAltAmmo=150
    NumMGMags=5
    AltFireInterval=0.08    // 750 rounds per minute
    TracerProjectileClass=Class'DH_ReibelMGTracerBullet'
    TracerFrequency=10

    // Weapon fire
    WeaponFireOffset=12.5
    AddedPitch=18
    EffectEmitterClass=Class'TankCannonFireEffectTypeC' // smaller muzzle flash effect
    ShakeRotRate=(Z=600.0)
    ShakeOffsetMag=(Z=5.0)
    ShakeOffsetTime=6.0

    // Sounds
    CannonFireSound(0)=SoundGroup'DH_CC_Vehicle_Weapons.37mmAT_fire_02'
    CannonFireSound(1)=SoundGroup'DH_CC_Vehicle_Weapons.37mmAT_fire_02'
    CannonFireSound(2)=SoundGroup'DH_CC_Vehicle_Weapons.37mmAT_fire_02'

    // TODO: different sounds for the MG
    AltFireSoundClass=SoundGroup'DH_WeaponSounds.30cal_FireLoop01'
    AltFireEndSound=SoundGroup'DH_WeaponSounds.30cal_FireEnd01'

    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.reload_01s_01')
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.reload_01s_02')
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.reload_01s_03')
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.reload_01s_04')
}
