//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMapMarker_Enemy_ATGun extends DHMapMarker_Enemy
    abstract;

defaultproperties
{
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.at_small'
    MarkerName="Enemy AT Gun"
    LifetimeSeconds=300
    SpottingConsoleCommand="SPEECH ENEMY 8"
}

