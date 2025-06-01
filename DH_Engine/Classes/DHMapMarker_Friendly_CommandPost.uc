//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMapMarker_Friendly_CommandPost extends DHMapMarker_Friendly
    abstract;

static function bool CanBeUsed(DHGameReplicationInfo GRI)
{
    return GRI != none && GRI.bAreConstructionsEnabled;
}

defaultproperties
{
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.platoon_hq'
    MarkerName="Request Command Post"
    LifetimeSeconds=300
}
