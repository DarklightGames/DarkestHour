//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMortar extends DHATGun
    abstract;

var DHConstructionSocket Socket;
var DHConstructionSocketParameters Params;

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        Socket;
}

simulated function PostBeginPlay()
{
    local DHConstructionSocket Socket;

    super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        Socket = Spawn(Class'DHConstructionSocket', self,, Location, Rotation);

        if (Socket != none)
        {
            Socket.Setup(Params);
            Socket.SetBase(self);
            Socket.SetRelativeLocation(vect(0, 0, 0));
            Socket.SetRelativeRotation(rot(0, 0, 0));
        }
    }
}

simulated function Destroyed()
{
    super.Destroyed();

    if (Socket != none)
    {
        Socket.Destroy();
    }
}

state Rotating
{
    function EndState()
    {
        local Rotator NewRotation;

        super.EndState();

        // For now, neutralize the roll of a mortar so that we don't have to
        // counteract aiming errors introduced by the uneven surfaces.
        NewRotation = Rotation;
        NewRotation.Roll = 0;
        SetRotation(NewRotation);
    }
}

defaultproperties
{
    bCanBeRotated=true
    bIsArtilleryVehicle=true
    bTeamLocked=false
    MapIconMaterial=Texture'DH_InterfaceArt2_tex.mortar_topdown'

    Begin Object Class=DHConstructionSocketParameters Name=MortarPitSocketParams
        TagFilters(0)=(Operation=Include,Tag=CT_MortarPit)
    End Object
    Params=MortarPitSocketParams
}
