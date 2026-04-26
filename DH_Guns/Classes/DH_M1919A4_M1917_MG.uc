//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M1919A4_M1917_MG extends DH_M1919A4MG;

defaultproperties
{   
    // Mesh=SkeletalMesh'DH_M1919_anm.M1919A4_M1917_GUN_INT'
    //Mesh=SkeletalMesh'DH_M1919_anm.M1919A4_M1917_GUN_EXT'

    YawBone="M1917_YAW"
    PitchBone="M1917_PITCH"

    // TODO: no yaw limits.
    MaxNegativeYaw=-2184    // -12 degrees
    MaxPositiveYaw=2184     // +12 degrees
    CustomPitchUpLimit=3640     // +20 degrees
    CustomPitchDownLimit=61895  // -20 degrees

    // TODO: animations might need to be different? leave these here for now.
    FiringAnim="BOLT_FIRING"
    FiringIdleAnim="BOLT_IDLE"
    FiringChannel=2
    FiringBone="FIRING_ROOT"
}
