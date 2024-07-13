//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Model35MortarCannon extends DHATGunCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_Model35Mortar_anm.model35mortar_tube_ext'

    WeaponFireAttachmentBone="muzzle"
    // Skins(0)=Texture'DH_M116_tex.M116.m116_body'
    // Skins(1)=Texture'DH_M116_tex.M116.m116_spring'
    // GunnerAttachmentBone="com_player"

    // Collision meshes
    // CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_M116_stc.Collision.m116_gun_coll',AttachBone="Gun")
    //CollisionStaticMeshes(1)=(CollisionStaticMesh=StaticMesh'DH_M116_stc.Collision.m116_turret_coll',AttachBone="Turret")

    // Animation
    ShootIntermediateAnim="shoot_close"

    // Gun Wheels
    GunWheels(0)=(RotationType=ROTATION_Yaw,BoneName="YAW_WHEEL",Scale=-128.0,RotationAxis=AXIS_Y)

    // Turret movement
    ManualRotationsPerSecond=0.0125
    MaxPositiveYaw=782.6    // +/- 4.3 degrees
    MaxNegativeYaw=-782.6
    YawStartConstraint=-782.6
    YawEndConstraint=782.6
    CustomPitchUpLimit=15470 // 85 degrees
    CustomPitchDownLimit=7280 // +40 degrees
    RotationsPerSecond=0.0125

    // Cannon ammo
    ProjectileDescriptions(0)="HE"
    ProjectileDescriptions(1)="Smoke"

    nProjectileDescriptions(0)="HE"
    nProjectileDescriptions(1)="Smoke"

    PrimaryProjectileClass=class'DH_Weapons.DH_Kz8cmGrW42ProjectileHE'
    SecondaryProjectileClass=class'DH_Weapons.DH_Kz8cmGrW42ProjectileSmoke'
    InitialPrimaryAmmo=30  // TODO: REPLACE
    InitialSecondaryAmmo=5  // TODO: REPLACE
    MaxPrimaryAmmo=30
    MaxSecondaryAmmo=5

    Spread=0.020
    SecondarySpread=0.00125

    // Weapon fire
    WeaponFireOffset=16.0  // TODO: REPLACE
    AddedPitch=-15  // TODO: REPLACE

    // Sounds
    //CannonFireSound(0)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire01'
    //CannonFireSound(1)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire02'
    //CannonFireSound(2)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire03'
    ReloadStages(0)=(Sound=Sound'Vehicle_reloads.Reloads.SU_76_Reload_01',Duration=2.0)
    ReloadStages(1)=(Sound=Sound'Vehicle_reloads.Reloads.SU_76_Reload_02',Duration=2.0)
    ReloadStages(2)=(Sound=Sound'Vehicle_reloads.Reloads.SU_76_Reload_03',Duration=1.0)
    ReloadStages(3)=(Sound=Sound'Vehicle_reloads.Reloads.SU_76_Reload_04',Duration=1.0)

    bIsArtillery=true
    ResupplyInterval=12.0

    // No 
    YawBone="YAW"
}
