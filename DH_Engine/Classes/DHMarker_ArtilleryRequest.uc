//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHMarker_ArtilleryRequest extends DHMarker_Artillery abstract;

var int TeamIndex;          // AXIS or ALLIES
var int SquadIndex;

defaultproperties
{
    MarkerName="Generic artillery request"
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.developer'
    IconColor=(R=204,G=,B=255,A=255)
    IconCoords=(X1=0,Y1=0,X2=31,Y2=31)
    TeamIndex = -1;
    SquadIndex = -1;
}

