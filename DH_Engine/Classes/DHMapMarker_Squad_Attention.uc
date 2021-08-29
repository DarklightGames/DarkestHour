//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHMapMarker_Squad_Attention extends DHMapMarker_Squad
    abstract;

static function OnMapMarkerPlaced(DHPlayer PC, DHGameReplicationInfo.MapMarker Marker)
{
    if (PC != none && PC.SquadReplicationInfo != none)
    {
        PC.SquadReplicationInfo.BroadcastSquadLocalizedMessage(PC.GetTeamNum(), PC.GetSquadIndex(), class'DHSquadOrderMessage', 4);
    }
}

defaultproperties
{
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.attention'
    IconColor=(R=231,G=119,B=40,A=255)
    MarkerName="Squad Attention"
}
