//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMapMarker_Squad_Defend extends DHMapMarker_Squad
    abstract;

defaultproperties
{
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.defend'
    IconColor=(R=4,G=80,B=255,A=255)
    MarkerName="Squad Defend"
    bShouldDrawBeeLine=true
    BroadcastedMessageIndex=2
}

