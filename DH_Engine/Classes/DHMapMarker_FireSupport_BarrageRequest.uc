//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHMapMarker_FireSupport_BarrageRequest extends DHMapMarker_FireSupport
    abstract;

static function string GetCaptionString(DHPlayer PC, DHGameReplicationInfo.MapMarker Marker)
{
    return "";
}

static function OnMapMarkerPlaced(DHPlayer PC, DHGameReplicationInfo.MapMarker Marker)
{
    PC.ServerSaveArtilleryTarget(Marker.WorldLocation);
}

static function OnMapMarkerRemoved(DHPlayer PC, DHGameReplicationInfo.MapMarker Marker)
{
    PC.ServerSaveArtilleryTarget(vect(0,0,0));
}

static function bool CanRemoveMarker(DHPlayerReplicationInfo PRI, DHGameReplicationInfo.MapMarker Marker)
{
    local DHPlayer PC;

    PC = DHPlayer(PRI.Owner);

    return DHGameReplicationInfo(PC.GameReplicationInfo).ArtyStrikeLocation[PRI.Team.TeamIndex] == vect(0,0,0);
}

defaultproperties
{
    MarkerName="Barrage Request"
    TypeName="HE"

    IconMaterial=Material'InterfaceArt_tex.OverheadMap.overheadmap_Icons'
    IconCoords=(X1=0,Y1=64,X2=63,Y2=127)
    IconColor=(R=255,G=255,B=255,A=128)
}
