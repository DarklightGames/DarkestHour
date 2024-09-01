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
    GunnerAttachmentBone="YAW"

    // Collision meshes
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Model35Mortar_stc.Collision.model35mortar_tube_collision',AttachBone="PITCH")

    // Animation
    ShootIntermediateAnim="shoot_close" // TODO: this thing has no shoot animation

    // Gun Wheels
    GunWheels(0)=(RotationType=ROTATION_Yaw,BoneName="YAW_WHEEL",Scale=-720,RotationAxis=AXIS_Y)    // [1] 0.5 degrees per turn.
    GunWheels(1)=(RotationType=ROTATION_PITCH,BoneName="PITCH_WHEEL",Scale=533,RotationAxis=AXIS_X) // [1] 12 mils per turn.
    GunWheels(2)=(RotationType=ROTATION_Pitch,BoneName="SIGHT_TOP",Scale=1.0,RotationAxis=AXIS_Y)   // Counter-rotates the sight so it stays level.

    // Turret movement
    ManualRotationsPerSecond=0.0125
    MaxPositiveYaw=782.6    // +/- 4.3 degrees
    MaxNegativeYaw=-782.6
    YawStartConstraint=-782.6
    YawEndConstraint=782.6
    CustomPitchUpLimit=9102
    CustomPitchDownLimit=65535
    RotationsPerSecond=0.0125

    // Cannon ammo
    ProjectileDescriptions(0)="HE (3.3kg)"
    ProjectileDescriptions(1)="Smoke"
    ProjectileDescriptions(2)="HE (6.8kg)"

    nProjectileDescriptions(0)="Amatolo 3.3kg"
    nProjectileDescriptions(1)="Fumogeno 6.6kg"
    nProjectileDescriptions(2)="Amatolo 6.8kg"

    PrimaryProjectileClass=class'DH_Guns.DH_Model35MortarProjectileHE'
    SecondaryProjectileClass=class'DH_Guns.DH_Model35MortarProjectileSmoke'
    TertiaryProjectileClass=class'DH_Guns.DH_Model35MortarProjectileHEBig'
    InitialPrimaryAmmo=28  // TODO: REPLACE
    InitialSecondaryAmmo=5  // TODO: REPLACE
    InitialTertiaryAmmo=2
    MaxPrimaryAmmo=28
    MaxSecondaryAmmo=5
    MaxTertiaryAmmo=2

    Spread=0.00125
    SecondarySpread=0.00125
    TertiarySpread=0.00125

    // Weapon fire
    WeaponFireOffset=16.0  // TODO: REPLACE
    AddedPitch=0  // TODO: REPLACE

    // Sounds
    CannonFireSound(0)=SoundGroup'DH_MortarSounds.Fire.81mm_mortar_fire'
    CannonFireSound(1)=Sound'DH_MortarSounds.Fire.81mm_mortar_fire'
    CannonFireSound(2)=Sound'DH_MortarSounds.Fire.81mm_mortar_fire'

    // TODO: figure out what to do with this.
    // ReloadStages(0)=(Sound=Sound'Vehicle_reloads.Reloads.SU_76_Reload_03',Duration=1.0)

    bIsArtillery=true
    ResupplyInterval=12.0

    // No 
    YawBone="YAW"
    PitchBone="PITCH"

    DriverAnimationChannelBone="CAMERA_COM"
    DriverAnimationChannel=2    // 1 is used for the pitching driver

    ProjectileRotationMode=PRM_MuzzleBone

    ShakeOffsetMag=(X=10.0,Y=10.0,Z=10.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=4.0
    ShakeRotMag=(X=100.0,Y=100.0,Z=800.0)
    ShakeRotRate=(X=12500.0,Y=12500.0,Z=12500.0)
    ShakeRotTime=5.0
}
