//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMapMarker_Enemy_Tank extends DHMapMarker_Enemy
    abstract;

defaultproperties
{
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.tank'
    MarkerName="Enemy Tank"
    LifetimeSeconds=120
    SpottingConsoleCommand="SPEECH ENEMY 6"
}
