//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHMapMarker_Squad_Move extends DHMapMarker_Squad
    abstract;

static function OnMapMarkerPlaced(DHPlayer PC, DHGameReplicationInfo.MapMarker Marker)
{
    if (PC != none && PC.SquadReplicationInfo != none)
    {
        PC.SquadReplicationInfo.BroadcastSquadLocalizedMessage(PC.GetTeamNum(), PC.GetSquadIndex(), class'DHSquadOrderMessage', 3);
    }
}

defaultproperties
{
    MarkerName="Squad Move"
    IconColor=(R=165,G=2,B=255,A=255)
    IconMaterial=Material'DH_InterfaceArt2_tex.Icons.move'
    bShouldDrawBeeLine=true
}
