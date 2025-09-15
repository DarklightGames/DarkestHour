//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_PantherACannon extends DH_PantherDCannon;

defaultproperties
{
    Mesh=SkeletalMesh'DH_Panther_anm.PANTHER_A_TURRET_EXT'
    Skins(0)=Texture'DH_Panther_tex.PANTHER_A_EXT'
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Panther_stc.PANTHER_A_TURRET_COLLISION')
    CollisionStaticMeshes(1)=(CollisionStaticMesh=StaticMesh'DH_Panther_stc.PANTHER_A_PITCH_COLLISION',AttachBone="GUN_PITCH")
    CollisionStaticMeshes(2)=(CollisionStaticMesh=StaticMesh'DH_Panther_stc.PANTHER_A_BARREL_COLLISION',AttachBone="BARREL")
    PoweredRotationsPerSecond=0.04  // ??
    PitchBone="GUN_PITCH"
    YawBone="GUN_YAW"

    AltFireAttachmentBone="MG_MUZZLE"
    AltFireOffset=(X=-8,Y=0,Z=0)
}
