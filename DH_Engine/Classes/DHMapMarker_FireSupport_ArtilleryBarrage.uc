//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHMapMarker_FireSupport_ArtilleryBarrage extends DHMapMarker_FireSupport
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

defaultproperties
{
    MarkerName="Off-map artillery barrage"
    IconMaterial=Material'InterfaceArt_tex.OverheadMap.overheadmap_Icons'
    IconCoords=(X1=0,Y1=64,X2=63,Y2=127)
    IconColor=(R=255,G=255,B=255,A=128)
    Scope=PERSONAL
    OverwritingRule=UNIQUE
    ArtilleryType=AT_HighExplosives
    ArtilleryRange=AR_OffMap
    GroupIndex=6
}
