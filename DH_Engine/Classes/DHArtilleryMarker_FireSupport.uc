//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHArtilleryMarker_FireSupport extends DHArtilleryMarker abstract;

var DHPlayer PC;

function string GetCaptionString()
{
    return PC.SquadReplicationInfo.GetSquadName(PC.GetTeamNum(), PC.GetSquadIndex());
}

defaultproperties
{
    MarkerName="Fire Support"
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.developer'
    IconColor=(R=204,G=,B=255,A=255)
    IconCoords=(X1=0,Y1=0,X2=31,Y2=31)
    Time = -1.0;
}

