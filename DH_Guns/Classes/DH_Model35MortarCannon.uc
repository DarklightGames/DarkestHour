//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// [1] https://texashistory.unt.edu/ark:/67531/metapth46561/
//==============================================================================

class DH_Model35MortarCannon extends DHATGunCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_Model35Mortar_anm.model35mortar_tube_ext'
    Skins(0)=Texture'DH_Model35Mortar_tex.Model35.Model35Mortar_ext'

    WeaponFireAttachmentBone="MUZZLE"
    // Skins(0)=Texture'DH_M116_tex.M116.m116_body'
    // Skins(1)=Texture'DH_M116_tex.M116.m116_spring'
    GunnerAttachmentBone="YAW"

    // Collision meshes
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Model35Mortar_stc.Collision.model35mortar_tube_collision',AttachBone="PITCH")

    // Animation
    ShootIntermediateAnim="shoot_close" // TODO: this thing has no shoot animation

    // Gun Wheels
    GunWheels(0)=(RotationType=ROTATION_Yaw,BoneName="YAW_WHEEL",Scale=-720,RotationAxis=AXIS_Y)    // [1] 0.5 degrees per turn.
    GunWheels(2)=(RotationType=ROTATION_PITCH,BoneName="PITCH_WHEEL",Scale=533,RotationAxis=AXIS_X) // [1] 12 mils per turn.
    GunWheels(1)=(RotationType=ROTATION_Pitch,BoneName="SIGHT_TOP",Scale=1.0,RotationAxis=AXIS_Y)   // Counter-rotates the sight so it stays level.

    // Turret movement
    ManualRotationsPerSecond=0.0125
    MaxPositiveYaw=782.6    // +/- 4.3 degrees
    MaxNegativeYaw=-782.6
    YawStartConstraint=-782.6
    YawEndConstraint=782.6
    CustomPitchUpLimit=8190
    CustomPitchDownLimit=65535
    RotationsPerSecond=0.0125

    // Cannon ammo
    ProjectileDescriptions(0)="HE"
    ProjectileDescriptions(1)="Smoke"

    nProjectileDescriptions(0)="HE"
    nProjectileDescriptions(1)="Smoke"

    PrimaryProjectileClass=class'DH_Guns.DH_Model35MortarProjectileHE'
    SecondaryProjectileClass=class'DH_Weapons.DH_Kz8cmGrW42ProjectileSmoke'
    InitialPrimaryAmmo=30  // TODO: REPLACE
    InitialSecondaryAmmo=5  // TODO: REPLACE
    MaxPrimaryAmmo=30
    MaxSecondaryAmmo=5

    Spread=0.020
    SecondarySpread=0.00125

    // Weapon fire
    WeaponFireOffset=16.0  // TODO: REPLACE
    AddedPitch=0  // TODO: REPLACE

    // Sounds
    CannonFireSound(0)=SoundGroup'DH_WeaponSounds.Mortars.8cmFireSG'
    CannonFireSound(1)=SoundGroup'DH_WeaponSounds.Mortars.8cmFireSG'
    CannonFireSound(2)=SoundGroup'DH_WeaponSounds.Mortars.8cmFireSG'
    ReloadStages(0)=(Sound=Sound'Vehicle_reloads.Reloads.SU_76_Reload_01',Duration=2.0)
    ReloadStages(1)=(Sound=Sound'Vehicle_reloads.Reloads.SU_76_Reload_02',Duration=2.0)
    ReloadStages(2)=(Sound=Sound'Vehicle_reloads.Reloads.SU_76_Reload_03',Duration=1.0)
    ReloadStages(3)=(Sound=Sound'Vehicle_reloads.Reloads.SU_76_Reload_04',Duration=1.0)

    bIsArtillery=true
    ResupplyInterval=12.0

    // No 
    YawBone="YAW"
    PitchBone="PITCH"

    DriverAnimationChannelBone="CAMERA_COM"
    DriverAnimationChannel=2    // 1 is used for the pitching driver

    ProjectileRotationMode=PRM_MuzzleBone
}
