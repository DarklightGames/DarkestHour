//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_CV33MG extends DHVehicleMG;

defaultproperties
{
    // MG mesh
    bMatchSkinToVehicle=true
    Mesh=SkeletalMesh'DH_CV33_anm.cv33_turret_ext'

    BeginningIdleAnim="cv33_turret_idle_close"

    FireAttachBone="GUN"
    FireEffectOffset=(X=-25.0,Y=0.0,Z=25.0)
    FireEffectScale=0.75

    // Movement
    MaxPositiveYaw=2366         // 13 degrees
    MaxNegativeYaw=-2366        // 13 degrees
    CustomPitchUpLimit=2730     // 15 degrees
    CustomPitchDownLimit=63352  // 12 degrees

    // Ammo
    ProjectileClass=class'DH_Weapons.DH_Breda38Bullet'
    InitialPrimaryAmmo=150
    NumMGMags=5
    FireInterval=0.1    // 600rpm
    TracerProjectileClass=class'DH_Weapons.DH_Breda38BulletTracer'
    TracerFrequency=7

    // Weapon fire
    FireSoundClass=SoundGroup'DH_MN_InfantryWeapons_sound.Breda38FireLoop'
    FireEndSound=SoundGroup'DH_MN_InfantryWeapons_sound.Breda38FireLoopEnd'
    ShakeRotMag=(X=10.0,Y=10.0,Z=10.0)
    ShakeOffsetMag=(X=0.01,Y=0.01,Z=0.01)
    WeaponFireAttachmentBone="MUZZLE_L"
    WeaponFireOffset=0

    bHasMultipleBarrels=true
    Barrels(0)=(MuzzleBone="MUZZLE_L",EffectEmitterClass=class'DH_Effects.DH_VehicleFiat1435MGEmitter')    // TODO: replace emitter with a correctly timed one
    Barrels(1)=(MuzzleBone="MUZZLE_R",EffectEmitterClass=class'DH_Effects.DH_VehicleFiat1435MGEmitter')
    AmbientEffectEmitterClass=class'DH_Vehicles.DH_VehicleMGMultiBarrelEmitterController'

    // Collision
    // NOTE: Normally on vehicle MGs, these values are not set, but the CV33 has a collision mesh
    //      that is not the same as the visual mesh, so we need to set these values because the
    //      collision mesh actors use the collision settings of the weapon.
    bCollideActors=true
    bBlockActors=true
    bProjTarget=true
    bBlockNonZeroExtentTraces=true
    bBlockZeroExtentTraces=true

    // Collision Attachments
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_CV33_stc.collision.cv33_turret_hatch_collision',AttachBone="hatch")
    CollisionStaticMeshes(1)=(CollisionStaticMesh=StaticMesh'DH_CV33_stc.collision.cv33_turret_pitch_collision',AttachBone="mg_pitch")

    GunnerAttachmentBone="GUN"
}
