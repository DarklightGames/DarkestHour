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
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Hetzer_stc.Collision.Hetzer_MG_collision')
    WeaponFireAttachmentBone="MUZZLE"
    FireEffectOffset=(X=-4.0)
    AmbientEffectEmitterClass=Class'DH_Vehicles.DH_HetzerVehicleMGEmitter'
    CustomPitchUpLimit=1092         // + 6 degrees
    CustomPitchDownLimit=63716      // -10 degrees
    BeginningIdleAnim="MG_idle_close"
    PitchBone="PITCH"
    YawBone="YAW"
    bLimitYaw=false
}
