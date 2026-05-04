//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M1919A4_M2_MG extends DH_M1919A4MG;

defaultproperties
{
    Mesh=SkeletalMesh'DH_M1919A4_anm.M1919A4_M2_TURRET_EXT'

    MaxNegativeYaw=-8192        // -45 degrees
    MaxPositiveYaw=8192         // +45 degrees
    CustomPitchUpLimit=3640     // +20 degrees
    CustomPitchDownLimit=61895  // -20 degrees

    YawBone="PINTLE_YAW"
    PitchBone="PINTLE_PITCH"

    FiringAnim="BOLT_FIRING"
    FiringIdleAnim="BOLT_IDLE"
    FiringChannel=2
    FiringBone="FIRING_ROOT"

    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_M1919A4_stc.M1919A4_GUN_COLLISION',AttachBone="PINTLE_PITCH")
}
