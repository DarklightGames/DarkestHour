//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M1919A4_M2_MG extends DH_M1919A4MG;

defaultproperties
{
    Mesh=SkeletalMesh'DH_M1919_anm.M1919A4_M2_GUN_EXT'

    YawBone="GUN_YAW"
    PitchBone="GUN_PITCH"

    FiringAnim="BOLT_FIRING"
    FiringIdleAnim="BOLT_IDLE"
    FiringChannel=2
    FiringBone="FIRING_ROOT"
}
