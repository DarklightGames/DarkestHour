//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHMapMarker_Squad_Move extends DHMapMarker_Squad
    abstract;

defaultproperties
{
    BroadcastedMessageIndex=3
    MarkerName="Squad Move"
    IconColor=(R=165,G=2,B=255,A=255)
    IconMaterial=Material'DH_InterfaceArt2_tex.move'
    bShouldDrawBeeLine=true
}
