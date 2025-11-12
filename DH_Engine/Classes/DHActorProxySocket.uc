//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHActorProxySocket extends Actor
    notplaceable;

var() bool  bLimitLocalRotation;    // When true, the local rotation of the actor proxy is limited to the specified yaw range.
var() Range LocalRotationYawRange;  // Limits the local rotation of the actor proxy attached to this hint.
var() bool  bShouldDestroyOccupant;

var private Actor Occupant;         // The current actor that is occupying this socket.
var private DHActorProxy Proxy;     // The proxy actor that is snapped to this socket.

replication
{
    reliable if (Role == ROLE_Authority)
        Occupant;
}

function Destroyed()
{
    super.Destroyed();

    if (bShouldDestroyOccupant && Occupant != None)
    {
        Occupant.Destroy();
    }
}

simulated function bool IsOccupied()
{
    return Occupant != None;
}

function Actor GetOccupant()
{
    return Occupant;
}

function SetOccupant(Actor Occupant)
{
    if (self.Occupant != Occupant)
    {
        self.Occupant = Occupant;
        OnOccupantChanged();
    }
}

simulated function DHActorProxy GetProxy()
{
    return Proxy;
}

simulated function SetProxy(DHActorProxy Proxy)
{
    if (self.Proxy != Proxy)
    {
        self.Proxy = Proxy;
        OnProxyChanged();
    }
}

function OnOccupantChanged();
simulated function OnProxyChanged();

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
