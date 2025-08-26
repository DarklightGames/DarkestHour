//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHConstructionSupplyAttachment_Vehicle extends DHConstructionSupplyAttachment;

// Overridden as vehicle's should collect initial supply amount from main supply cache
function SetInitialSupply(optional int Amount)
{
    local DHGameReplicationInfo GRI;
    local int SupplyCollected;

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI != none)
    {
        SupplyCollected = GRI.CollectSupplyFromMainCache(GetTeamIndex(), default.SupplyCountMax);

        if (SupplyCollected >= 0)
        {
            SetSupplyCount(float(SupplyCollected));
        }
        else
        {
            SetSupplyCount(float(SupplyCountMax));
        }
    }
}

simulated function string GetHumanReadableName()
{
    local ROVehicle ROV;

    ROV = ROVehicle(Base);

    if (ROV != none)
    {
        return ROV.VehicleNameString @ super.GetHumanReadableName();
    }

    return super.GetHumanReadableName();
}

defaultproperties
{
    bIsAttachedToVehicle=true
    SupplyCount=2000.0
    SupplyCountMax=2000
    bCanBeResupplied=true
    MapIconAttachmentClass=None
    // We want vehicle supply caches to be drawn from later than static ones.
    SortOrder=1
}
