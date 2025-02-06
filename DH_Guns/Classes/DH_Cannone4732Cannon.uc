//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// [1] https://comandosupremo.com/forums/index.php?threads/italian-armor-piercing-ammunition-perforanti-effetto-pronto-and-ep-speciale.52
//==============================================================================

class DH_Cannone4732Cannon extends DHATGunCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_Cannone4732_anm.cannone4732_turret'
    Skins(0)=Texture'DH_Cannone4732_tex.cannone4732_body_ext'

    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Cannone4732_stc.collision.cannone4732_turret_yaw_collision',AttachBone="GUN_YAW")
    CollisionStaticMeshes(1)=(CollisionStaticMesh=StaticMesh'DH_Cannone4732_stc.collision.cannone4732_turret_pitch_collision',AttachBone="GUN_PITCH")
    CollisionStaticMeshes(2)=(CollisionStaticMesh=StaticMesh'DH_Cannone4732_stc.collision.cannone4732_turret_barrel_collision',AttachBone="BARREL")

    WeaponFireAttachmentBone="muzzle"

    GunnerAttachmentBone="turret"
    
    ShootAnim="shoot"
    ShootAnimBoneName="barrel"

    // Turret movement
    MaxPositiveYaw=6000
    MaxNegativeYaw=-6000
    YawStartConstraint=-7000.0
    YawEndConstraint=7000.0
    CustomPitchUpLimit=10920    // 60 degrees
    CustomPitchDownLimit=62806  // -15 degrees

    // Cannon ammo
    PrimaryProjectileClass=class'DH_Vehicles.DH_Cannone4732CannonShell'
    SecondaryProjectileClass=class'DH_Vehicles.DH_Cannone4732CannonShellHE'
    TertiaryProjectileClass=class'DH_Vehicles.DH_Cannone4732CannonShellHEAT'

    ProjectileDescriptions(0)="AP"
    ProjectileDescriptions(1)="HE"
    ProjectileDescriptions(2)="HEAT"

    nProjectileDescriptions(0)="Granata Perforante da 47"   // not sure if this is the right name or not!
    nProjectileDescriptions(1)="Granata da 47"
    nProjectileDescriptions(2)="Effeto Pronto da 47"

    // Source [1] indicates that there was an even split of ammo types & that the maximum loadout of each gun was 60 rounds.
    InitialPrimaryAmmo=10
    InitialSecondaryAmmo=10
    InitialTertiaryAmmo=10
    MaxPrimaryAmmo=20
    MaxSecondaryAmmo=20
    MaxTertiaryAmmo=20
    SecondarySpread=0.00125
    TertiarySpread=0.00125

    // Weapon fire
    AddedPitch=-15

    // Sounds
    CannonFireSound(0)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire01'
    CannonFireSound(1)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire02'
    CannonFireSound(2)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire03'
    ReloadStages(0)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_1') //3.5 seconds reload
    ReloadStages(1)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_2')
    ReloadStages(2)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_3')
    ReloadStages(3)=(Sound=Sound'DH_Vehicle_Reloads.Reloads.reload_short_4')

    ResupplyInterval=3.0

    RangeSettings(1)=100
    RangeSettings(2)=200
    RangeSettings(3)=300
    RangeSettings(4)=400
    RangeSettings(5)=500
    RangeSettings(6)=600
    RangeSettings(7)=700
    RangeSettings(8)=800
    RangeSettings(9)=900
    RangeSettings(10)=1000
    RangeSettings(11)=1100
    RangeSettings(12)=1200
    RangeSettings(13)=1300
    RangeSettings(14)=1400
    RangeSettings(15)=1500
    RangeSettings(16)=1600
    RangeSettings(17)=1700
    RangeSettings(18)=1800
    RangeSettings(19)=1900
    RangeSettings(20)=2000

    PitchBone="gun_pitch"
    YawBone="gun_yaw"

    GunWheels(0)=(RotationType=ROTATION_Yaw,BoneName="yaw_wheel",Scale=-32.0,RotationAxis=AXIS_Y)
    GunWheels(1)=(RotationType=ROTATION_Pitch,BoneName="pitch_wheel",Scale=32.0,RotationAxis=AXIS_Y)

    ShakeOffsetMag=(X=6.0,Y=2.0,Z=10.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=4.0
    ShakeRotMag=(X=100.0,Y=100.0,Z=800.0)
    ShakeRotRate=(X=12500.0,Y=12500.0,Z=12500.0)
    ShakeRotTime=7.0

    RotationsPerSecond=0.05

    ProjectileRotationMode=PRM_MuzzleBone
}
