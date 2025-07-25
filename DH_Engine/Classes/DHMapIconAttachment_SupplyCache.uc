//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMapIconAttachment_SupplyCache extends DHMapIconAttachment
    notplaceable;

simulated delegate bool IsCacheConstructed() { return true; }
function Setup();

function BaseChange()
{
    AttachedTo = Base;
}

simulated function PostNetReceive()
{
    local DHConstruction Construction;

    if (AttachedTo != none)
    {
        Construction = DHConstruction(AttachedTo);

        if (Construction != none)
        {
            IsCacheConstructed = Construction.IsConstructed;
        }

        // Shut down the net receive once we got the base actor on the client.
        bNetNotify = false;
    }
}

function EVisibleFor GetVisibility()
{
    return VISIBLE_Team;
}

function EVisibleFor GetVisibilityInDangerZone()
{
    return VISIBLE_All;
}

simulated function Color GetIconColor(DHPlayer PC)
{
    local byte PlayerTeamIndex;

    if (PC != none)
    {
        PlayerTeamIndex = PC.GetTeamNum();

        if (PlayerTeamIndex > 1)
        {
            if (GetTeamIndex() < arraycount(Class'DHColor'.default.TeamColors))
            {
                return Class'DHColor'.default.TeamColors[GetTeamIndex()];
            }
        }
        else if (PlayerTeamIndex != GetTeamIndex() && GetTeamIndex() < 2)
        {
            return Class'UColor'.default.Red;
        }
    }

    if (IsCacheConstructed())
    {
        return Class'DHColor'.default.FriendlyColor;
    }
    else
    {
        return Class'UColor'.default.Gray;
    }
}

defaultproperties
{
    IconMaterial=Texture'DH_InterfaceArt2_tex.Supply_Cache'
    IconScale=0.03
    bNetNotify=true
}
