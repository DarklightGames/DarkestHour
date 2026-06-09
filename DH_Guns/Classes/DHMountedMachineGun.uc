//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMountedMachineGun extends DHMountedGun
    abstract;

defaultproperties
{
    // In order for the collision meshes to actually work, for some reason there needs to be karma shapes.
    // However, we don't actually want the gun to move, so we set the max speed and angular speed to 0.
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KMaxSpeed=0.0
        KMaxAngularSpeed=0.0
    End Object
    KParams=KParams0
}
