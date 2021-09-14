//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHMapMarker_FireSupport_ArtilleryBarrage extends DHMapMarker
    abstract;

static function bool CanRemoveMarker(DHPlayerReplicationInfo PRI, DHGameReplicationInfo.MapMarker Marker)
{
    local DHPlayer PC;

    PC = DHPlayer(PRI.Owner);

    return PRI != none && PC != none 
      && !PC.IsPositionOfArtillery(Marker.WorldLocation)
      && !PC.IsPositionOfParadrop(Marker.WorldLocation);
}

static function bool CanSeeMarker(DHPlayerReplicationInfo PRI, DHGameReplicationInfo.MapMarker Marker)
{
    local DHPlayer PC;

    PC = DHPlayer(PRI.Owner);

    return PRI != none && PC != none 
      && !PC.IsPositionOfParadrop(Marker.WorldLocation);
}

static function OnMapMarkerPlaced(DHPlayer PC, DHGameReplicationInfo.MapMarker Marker)
{
    PC.ServerSaveArtilleryTarget(Marker.WorldLocation);
}
static function OnMapMarkerRemoved(DHPlayer PC, DHGameReplicationInfo.MapMarker Marker)
{
    PC.ServerSaveArtilleryTarget(vect(0, 0, 0));
}

defaultproperties
{
    MarkerName="Off-map artillery barrage"
    IconMaterial=Material'InterfaceArt_tex.OverheadMap.overheadmap_Icons'
    IconCoords=(X1=0,Y1=64,X2=63,Y2=127)
    IconColor=(R=255,G=255,B=255,A=128)
    Type=MT_OffMapArtilleryRequest
    Scope=PERSONAL
    OverwritingRule=UNIQUE
    GroupIndex=6
}
