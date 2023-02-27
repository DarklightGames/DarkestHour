//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_M116Cannon extends DHATGunCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_M116_anm.m116_turret'
    Skins(0)=Texture'DH_M116_tex.M116.m116_body'
    Skins(1)=Texture'DH_M116_tex.M116.m116_spring'
    GunnerAttachmentBone="com_player"

    // Collision meshes
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_M116_stc.Collision.m116_gun_coll',AttachBone="Gun")
    //CollisionStaticMeshes(1)=(CollisionStaticMesh=StaticMesh'DH_M116_stc.Collision.m116_turret_coll',AttachBone="Turret")

    // Animation
    ShootIntermediateAnim="shoot_close"

    // Gun Wheels
    GunWheels(0)=(RotationType=ROTATION_Yaw,BoneName="traverse_wheel",Scale=-128.0,RotationAxis=AXIS_Z)

    // Turret movement
    ManualRotationsPerSecond=0.015625
    MaxPositiveYaw=546.0
    MaxNegativeYaw=-546.0
    YawStartConstraint=-546.0
    YawEndConstraint=546.0
    CustomPitchUpLimit=8192 // 45 degrees
    CustomPitchDownLimit=65358 // -5 degrees
    RotationsPerSecond=0.015625

    // Cannon ammo
    ProjectileDescriptions(0)="HE"
    ProjectileDescriptions(1)="HEAT"

    nProjectileDescriptions(0)="HE M48"
    nProjectileDescriptions(1)="HEAT M66"

    PrimaryProjectileClass=class'DH_Guns.DH_M116CannonShellHE'
    SecondaryProjectileClass=class'DH_Guns.DH_LeIG18CannonShellHEAT'
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
    CannonFireSound(0)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire01'
    CannonFireSound(1)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire02'
    CannonFireSound(2)=SoundGroup'DH_ArtillerySounds.ATGun.57mm_fire03'
    ReloadStages(0)=(Sound=Sound'Vehicle_reloads.Reloads.SU_76_Reload_01',Duration=4.0)
    ReloadStages(1)=(Sound=Sound'Vehicle_reloads.Reloads.SU_76_Reload_02',Duration=4.0)
    ReloadStages(2)=(Sound=Sound'Vehicle_reloads.Reloads.SU_76_Reload_03',Duration=2.0)
    ReloadStages(3)=(Sound=Sound'Vehicle_reloads.Reloads.SU_76_Reload_04',Duration=1.0)

    bIsArtillery=true
}
