//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// This is an actor that acts as snapping point for specific constructions.
// These are meant to be attached to other actors. For example, the foxhole
// construction may add one of these on either side of the "pit" so that
// a stationary machine-gun can be placed on it, overriding the usual rules
// that would disallow placement for other reasons.
//
// These are not replicated and are expected to be created on the server
// and client independently.
//==============================================================================

class DHActorProxySocket extends Actor;

var() bool  bLimitLocalRotation;    // When true, the local rotation of the actor proxy is limited to the specified yaw range.
var() Range LocalRotationYawRange;  // Limits the local rotation of the actor proxy attached to this hint.

var Actor   Occupant;               // The current actor that is occupying this socket.

replication
{
    reliable if (Role == ROLE_Authority)
        Occupant;
}

function Destroyed()
{
    super.Destroyed();

    if (Occupant != None)
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
