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
    PrimaryProjectileClass=class'DH_Vehicles.DH_M7PriestCannonShellHE'
    SecondaryProjectileClass=class'DH_Vehicles.DH_M7PriestCannonShellSmoke'
    TertiaryProjectileClass=class'DH_Vehicles.DH_ShermanM4A3105CannonShellHEAT'

    ProjectileDescriptions(0)="HE-T"
    ProjectileDescriptions(1)="WP"
    ProjectileDescriptions(2)="HEAT"

    nProjectileDescriptions(0)="M1 HE-T"
    nProjectileDescriptions(1)="M60 WP"
    nProjectileDescriptions(2)="M67 HEAT"

    InitialPrimaryAmmo=58
    InitialSecondaryAmmo=3
    InitialTertiaryAmmo=8
    MaxPrimaryAmmo=58
    MaxSecondaryAmmo=3
    MaxTertiaryAmmo=8
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

    ProjectileRotationMode=PRM_MuzzleBone

    GunWheels(0)=(RotationType=ROTATION_Pitch,BoneName="WHEEL_PITCH",Scale=128,RotationAxis=AXIS_X)
    GunWheels(1)=(RotationType=ROTATION_Yaw,BoneName="WHEEL_YAW",Scale=128,RotationAxis=AXIS_X)
}
