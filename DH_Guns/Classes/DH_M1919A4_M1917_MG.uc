//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// [ ] add ammo box
// [ ] third person animations
// [ ] calibrate sight
// [ ] figure out pitch limits
// [ ] first person reload animations
// [ ] ejector bone
// [ ] collision meshes
//==============================================================================

class DH_M1919A4_M1917_MG extends DH_M1919A4MG;

defaultproperties
{   
    Mesh=SkeletalMesh'DH_M1919A4_anm.M1919A4_M1917_TURRET_EXT'

    YawBone="TURRET_YAW"
    PitchBone="TURRET_PITCH"

    // This thing can spin 360 degrees, but for the case of our game we want to
    // keep things constrained so that the placements rules can be permissive without
    // allowing the player to clip into walls.
    MaxNegativeYaw=-8192    // -45 degrees
    MaxPositiveYaw=8192     // +45 degrees
    CustomPitchUpLimit=3640     // +20 degrees
    CustomPitchDownLimit=61895  // -20 degrees

    // TODO: animations might need to be different? leave these here for now.
    FiringAnim="BOLT_FIRING"
    FiringIdleAnim="BOLT_IDLE"
    FiringChannel=2
    FiringBone="FIRING_ROOT"
}
