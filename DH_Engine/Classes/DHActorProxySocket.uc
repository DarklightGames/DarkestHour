//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHActorProxySocket extends Actor;

var() bool  bLimitLocalRotation;    // When true, the local rotation of the actor proxy is limited to the specified yaw range.
var() Range LocalRotationYawRange;  // Limits the local rotation of the actor proxy attached to this hint.
var() bool  bShouldDestroyOccupant;

var Actor   Occupant;               // The current actor that is occupying this socket.

replication
{
    reliable if (Role == ROLE_Authority)
        Occupant;
}

function Destroyed()
{
    super.Destroyed();

    // TODO: only destroy occupant if 

    if (bShouldDestroyOccupant && Occupant != None)
    {
        Occupant.Destroy();
    }
}

simulated function bool IsOccupied()
{
    return Occupant != None;
}

defaultproperties
{
    RemoteRole=ROLE_DumbProxy

    bCollideActors=true
	bCollideWorld=false
	bIgnoreEncroachers=true
	bProjTarget=true
	bBlockHitPointTraces=true

    CollisionRadius=16.0
    CollisionHeight=32.0
    bBlockNonZeroExtentTraces=true
    bBlockZeroExtentTraces=true
    bBlockProjectiles=false
    bBlockActors=false
    bBlockKarma=false
}
