//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// Standing version of the Maxim gun that can be placed on ledges and have the
// player stand on them.
//==============================================================================

class DH_MaximM191030Gun_Standing extends DH_MaximM191030Gun;

defaultproperties
{
    BeginningIdleAnim="IDLE_STANDING"
    bCanBeRotated=false
    CollisionRadius=12.0
    CollisionHeight=16.0
    // TODO: replace
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_MaximM191030MGPawn_Standing',WeaponBone="TURRET_PLACEMENT")
    // TODO: replace with one with a flattened base.
    VehicleHudImage=Texture'DH_Fiat1435_tex.fiat1435_tripod_icon'

    // TODO: get new ones
    ExitPositions(0)=(X=0,Y=0,Z=50)         // Failsafe exit position (ontop of the gun)
    ExitPositions(1)=(X=-80,Y=0,Z=0)       // Main exit position (behind the gun)
    ExitPositions(2)=(X=0,Y=-80.0,Z=0)     // Beside the gun
    ExitPositions(3)=(X=0,Y=+80.0,Z=0)     
    ExitPositions(4)=(X=-80,Y=-80.0,Z=0)
    ExitPositions(5)=(X=-80,Y=80.0,Z=0)

    // In order for the collision meshes to actually work, for some reason there needs to be karma shapes.
    // However, we don't actually want the gun to move, so we set the max speed and angular speed to 0.
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KMaxSpeed=0.0
        KMaxAngularSpeed=0.0
    End Object
    KParams=KParams0
}
