//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMapMarker_Friendly_Supplies extends DHMapMarker_Friendly
    abstract;

static function bool CanBeUsed(DHGameReplicationInfo GRI)
{
    return GRI != none && GRI.bAreConstructionsEnabled;
}

defaultproperties
{
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.supply_cache'
    MarkerName="Request Supplies"
    LifetimeSeconds=300
}

