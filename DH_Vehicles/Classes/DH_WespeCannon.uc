//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_WespeCannon extends DHVehicleCannon;

defaultproperties
{
    // Turret mesh
    Mesh=SkeletalMesh'DH_Wespe_anm.WESPE_TURRET_EXT'
    // Skins(0)=Texture'DH_M7Priest_tex.ext_vehicles.M7Priest'
    // Skins(1)=Texture'DH_M7Priest_tex.ext_vehicles.M7Priest2'
    FireAttachBone=TURRET_PLACEMENT
    FireEffectScale=2.5 // turret fire is larger & positioned in centre of open superstructure
    FireEffectOffset=(X=-55.0,Y=-15.0,Z=100.0)

    // Turret movement
    bHasTurret=false
    ManualRotationsPerSecond=0.01
    RotationsPerSecond=0.01
    bLimitYaw=true
    MaxPositiveYaw=3640        // 20 degrees
    MaxNegativeYaw=-3640       // -20 degrees
    YawStartConstraint=-3640.0
    YawEndConstraint=3640.0
    CustomPitchUpLimit=7644    // 42 degrees
    CustomPitchDownLimit=64625 // -5 degrees

    // Cannon ammo
    PrimaryProjectileClass=class'DH_Vehicles.DH_LeFH18CannonShellHE'
    // SecondaryProjectileClass=class'DH_Vehicles.DH_LeFH18CannonShellSmoke'
    // TertiaryProjectileClass=class'DH_Vehicles.DH_LeFH18CannonShellAP'

    ProjectileDescriptions(0)="HE"
    ProjectileDescriptions(1)="Smoke"
    ProjectileDescriptions(2)="AP"

    nProjectileDescriptions(0)="F.H.Gr."
    nProjectileDescriptions(1)="F.H.Gr.Nb."
    nProjectileDescriptions(2)="Pz.Gr."

    InitialPrimaryAmmo=18
    InitialSecondaryAmmo=8
    InitialTertiaryAmmo=4
    MaxPrimaryAmmo=18
    MaxSecondaryAmmo=8
    MaxTertiaryAmmo=4
    Spread=0.01
    SecondarySpread=0.005
    TertiarySpread=0.005

    // Weapon fire
    WeaponFireOffset=18.0
    AddedPitch=68

    // Artillery
    bIsArtillery=true

    // Sounds
    CannonFireSound(0)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire01'
    CannonFireSound(1)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire02'
    CannonFireSound(2)=SoundGroup'Vehicle_Weapons.Tiger.88mm_fire03'
    ReloadStages(0)=(Sound=Sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_01',Duration=4.0)
    ReloadStages(1)=(Sound=Sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_02',Duration=4.0)
    ReloadStages(2)=(Sound=Sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_03',Duration=2.0)
    ReloadStages(3)=(Sound=Sound'Vehicle_reloads.Reloads.Pz_IV_F2_Reload_04')
    ResupplyInterval=10.0

    YawBone=GUN_YAW
    PitchBone=GUN_PITCH
    WeaponFireAttachmentBone=MUZZLE

    ShootAnim=FIRE
    ShootAnimBoneName=BARREL

    GunnerAttachmentBone="TURRET"

    ProjectileRotationMode=PRM_MuzzleBone

    GunWheels(0)=(RotationType=ROTATION_Pitch,BoneName="WHEEL_PITCH",Scale=128,RotationAxis=AXIS_X)
    GunWheels(1)=(RotationType=ROTATION_Yaw,BoneName="WHEEL_YAW",Scale=128,RotationAxis=AXIS_X)

    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Wespe_stc.wespe_turret_pitch_collision',AttachBone="GUN_PITCH")
    CollisionStaticMeshes(1)=(CollisionStaticMesh=StaticMesh'DH_Wespe_stc.wespe_turret_yaw_collision',AttachBone="GUN_YAW")

    ShakeOffsetMag=(X=6.0,Y=2.0,Z=10.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=4.0
    ShakeRotMag=(X=100.0,Y=100.0,Z=800.0)
    ShakeRotRate=(X=12500.0,Y=12500.0,Z=12500.0)
    ShakeRotTime=7.0
}
