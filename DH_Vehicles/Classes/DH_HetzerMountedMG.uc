//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_HetzerMountedMG extends DH_StuH42MountedMG;

defaultproperties
{
    Mesh=SkeletalMesh'DH_Hetzer_anm.HETZER_MG_EXT'
    Skins(0)=Texture'DH_Hetzer_tex.hetzer_body_ext'
    Skins(1)=Texture'Weapons3rd_tex.German.mg34_world'
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Hetzer_stc.Collision.HETZER_MG_COLLISION_YAW',AttachBone="YAW")
    CollisionStaticMeshes(1)=(CollisionStaticMesh=StaticMesh'DH_Hetzer_stc.Collision.HETZER_MG_COLLISION_HATCH_L',AttachBone="HATCH_L")
    CollisionStaticMeshes(2)=(CollisionStaticMesh=StaticMesh'DH_Hetzer_stc.Collision.HETZER_MG_COLLISION_HATCH_R',AttachBone="HATCH_R")
    WeaponFireAttachmentBone="MUZZLE"
    FireEffectOffset=(X=-4.0)
    AmbientEffectEmitterClass=Class'DH_Vehicles.DH_HetzerVehicleMGEmitter'
    CustomPitchUpLimit=1092         // + 6 degrees
    CustomPitchDownLimit=63716      // -10 degrees
    BeginningIdleAnim="idle"
    PitchBone="PITCH"
    YawBone="YAW"
    bLimitYaw=false
    GunnerAttachmentBone="ROOT"
}
