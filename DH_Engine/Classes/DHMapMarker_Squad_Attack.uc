//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMapMarker_Squad_Attack extends DHMapMarker_Squad
    abstract;

defaultproperties
{
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.attack'
    IconColor=(R=255,G=211,B=0,A=255)
    MarkerName="Squad Attack"
    bShouldDrawBeeLine=true
    BroadcastedMessageIndex=1
}
