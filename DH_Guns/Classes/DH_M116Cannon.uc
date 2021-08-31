//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================
// [ ] increase pitching speed (yaw & pitch are tied together in this way?")
// [X] make clock image
// [ ] make specific round types
// [ ] calibrate range table
// [x] fix breeching animation (seems fine in blender)
// [x] increase camera height when raised
// [x] hook up traverse wheel
// [x] move player a bit further up
// [x] exit positions
// [ ] final mesh export
// [ ] add spring to mesh

// branch in general:
// [ ] make RMB the thing that activates the map for use

class DH_M116Cannon extends DHATGunCannon;

defaultproperties
{
    // Cannon mesh
    Mesh=SkeletalMesh'DH_M116_anm.m116_turret'
    Skins(0)=Texture'DH_M116_tex.M116.m116_body'
    GunnerAttachmentBone="com_player"

    // Collision meshes
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_M116_stc.Collision.m116_gun_coll',AttachBone="Gun")
    CollisionStaticMeshes(1)=(CollisionStaticMesh=StaticMesh'DH_M116_stc.Collision.m116_turret_coll',AttachBone="Turret")

    // Animation
    ShootIntermediateAnim="shoot_close"

    // Gun Wheels
    GunWheels(0)=(RotationType=ROTATION_Yaw,BoneName="traverse_wheel",Scale=-128.0)

    // Turret movement
    ManualRotationsPerSecond=0.011111
    MaxPositiveYaw=546.0
    MaxNegativeYaw=-546.0
    YawStartConstraint=-546.0
    YawEndConstraint=546.0
    CustomPitchUpLimit=8192 // 45 degrees
    CustomPitchDownLimit=65358 // -5 degrees
    RotationsPerSecond=0.005 // ~3 degrees per second

    // Cannon ammo
    ProjectileDescriptions(0)="HE"
    ProjectileDescriptions(1)="HEAT"

    nProjectileDescriptions(0)="Igr.38 Sprgr"   // TOD: get names of this
    nProjectileDescriptions(1)="Igr.38 HL/A"

    ProjectileClass=class'DH_Guns.DH_LeIG18CannonShellHE'   // TODO: replace with m116 versions
    PrimaryProjectileClass=class'DH_Guns.DH_LeIG18CannonShellHE'
    SecondaryProjectileClass=class'DH_Guns.DH_LeIG18CannonShellHEAT'
    InitialPrimaryAmmo=60  // TODO: REPLACE
    InitialSecondaryAmmo=25  // TODO: REPLACE
    MaxPrimaryAmmo=60
    MaxSecondaryAmmo=25
    SecondarySpread=0.00125  // TODO: REPLACE

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
