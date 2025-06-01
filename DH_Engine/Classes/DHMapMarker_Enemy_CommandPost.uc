//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMapMarker_Enemy_CommandPost extends DHMapMarker_Enemy
    abstract;

static function bool CanBeUsed(DHGameReplicationInfo GRI)
{
    return GRI != none && GRI.bAreConstructionsEnabled;
}

defaultproperties
{
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.platoon_hq'
    MarkerName="Enemy Command Post"
    LifetimeSeconds=600
    SpottingConsoleCommand="SPEECH SUPPORT 6"
}
