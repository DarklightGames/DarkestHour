//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_PantherAMountedMG extends DH_PanzerIVMountedMG;

defaultproperties
{
    Mesh=SkeletalMesh'DH_Panther_anm.PANTHER_A_MG_EXT'
    Skins(0)=Texture'DH_Panther_tex.PANTHER_A_EXT'
    MaxPositiveYaw=4500
    MaxNegativeYaw=-4500
    CustomPitchUpLimit=2730
    CustomPitchDownLimit=64000
    NumMGMags=9
    FireEffectOffset=(X=-50.0,Y=0.0,Z=30.0) // positions fire on co-driver's hatch
    PitchBone="PITCH"
    YawBone="YAW"
    WeaponFireAttachmentBone="MUZZLE"
    WeaponFireOffset=-8
}
