//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMortar extends DHATGun
    abstract;

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
}
