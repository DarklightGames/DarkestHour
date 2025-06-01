//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMapMarker_Enemy_Vehicle extends DHMapMarker_Enemy
    abstract;

defaultproperties
{
    MarkerName="Enemy Vehicle"
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.truck_topdown'
    LifetimeSeconds=120
    SpottingConsoleCommand="SPEECH ENEMY 5"
}
