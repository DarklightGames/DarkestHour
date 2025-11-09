//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMapMarker_Enemy_Artillery extends DHMapMarker_Enemy
    abstract;

defaultproperties
{
    IconMaterial=Texture'DH_InterfaceArt2_tex.artillery'
    MarkerName="Enemy Artillery"
    LifetimeSeconds=300
    SpottingConsoleCommand="SPEECH ENEMY 8"
}
