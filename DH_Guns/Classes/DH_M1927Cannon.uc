//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_M1927Cannon extends DHATGunCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_M1927_anm.m1927_turret'
    Skins(0)=Texture'DH_M1927_tex.world.m1927_body'
    GunnerAttachmentBone="com_player"

    WeaponFireAttachmentBone="Muzzle"

    // Animation
    ShootIntermediateAnim="shoot_close"

    // Collision meshes
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_M1927_stc.Collision.m1927_gun_collision',AttachBone="Gun")
    CollisionStaticMeshes(1)=(CollisionStaticMesh=StaticMesh'DH_M1927_stc.Collision.m1927_turret_collision',AttachBone="Turret")

    // Gun Wheels
    GunWheels(0)=(RotationType=ROTATION_Yaw,BoneName="traverse_wheel",Scale=-256.0,RotationAxis=AXIS_Y)
    GunWheels(1)=(RotationType=ROTATION_Pitch,BoneName="elevation_wheel",Scale=-256.0,RotationAxis=AXIS_Y)
    GunWheels(2)=(RotationType=ROTATION_Pitch,BoneName="spotting_scope",Scale=1.0,RotationAxis=AXIS_Y)

    // Turret movement
    RotationsPerSecond=0.01
    MaxPositiveYaw=546.0 // 3 degrees
    MaxNegativeYaw=-546.0 // -3 degrees
    YawStartConstraint=-546.0 // -3 degrees
    YawEndConstraint=546.0 // 3 degrees
    CustomPitchUpLimit=4550 // +25 degrees
    CustomPitchDownLimit=64444 // -6 degrees

    // Cannon ammo
    ProjectileDescriptions(0)="HE"
    ProjectileDescriptions(1)="HEAT"

    nProjectileDescriptions(0)="OF-350"
    nProjectileDescriptions(1)="BP-350M"

    PrimaryProjectileClass=class'DH_Guns.DH_M1927CannonShellHE'
    SecondaryProjectileClass=class'DH_Guns.DH_LeIG18CannonShellHEAT'

    InitialPrimaryAmmo=28
    InitialSecondaryAmmo=4
    MaxPrimaryAmmo=28
    MaxSecondaryAmmo=4

    Spread=0.020
    SecondarySpread=0.00125

    // Weapon fire
    WeaponFireOffset=0
    AddedPitch=0

    // Sounds
    CannonFireSound(0)=Sound'Vehicle_Weapons.T34_76.76mm_fire01'
    CannonFireSound(1)=Sound'Vehicle_Weapons.T34_76.76mm_fire02'
    CannonFireSound(2)=Sound'Vehicle_Weapons.T34_76.76mm_fire03'
    ReloadStages(0)=(Sound=Sound'Vehicle_reloads.Reloads.SU_76_Reload_01',Duration=3)
    ReloadStages(1)=(Sound=Sound'Vehicle_reloads.Reloads.SU_76_Reload_02',Duration=3)
    ReloadStages(2)=(Sound=Sound'Vehicle_reloads.Reloads.SU_76_Reload_03',Duration=3)
    ReloadStages(3)=(Sound=Sound'Vehicle_reloads.Reloads.SU_76_Reload_04',Duration=1)

    bIsArtillery=true
    ResupplyInterval=25.0
}
