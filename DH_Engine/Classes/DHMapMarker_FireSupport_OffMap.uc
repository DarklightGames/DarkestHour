//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHMapMarker_FireSupport_OffMap extends DHMapMarker_FireSupport
    abstract;

static function bool CanRemoveMarker(DHPlayerReplicationInfo PRI, DHGameReplicationInfo.MapMarker Marker)
{
    local DHPlayer PC;

    PC = DHPlayer(PRI.Owner);

    // off-map artillery request can only be removed if there are no ongoing artillery strikes
    // (keep in mind that off-map artillery requests are personal anyway) 
    return DHGameReplicationInfo(PC.GameReplicationInfo).ArtyStrikeLocation[PRI.Team.TeamIndex] == vect(0,0,0);
}

// Only allow artillery roles and the SL who made the mark to see artillery requests.
static function bool CanSeeMarker(DHPlayerReplicationInfo PRI, DHGameReplicationInfo.MapMarker Marker)
{
    local DHPlayer PC;

    if (PRI == none)
    {
        return false;
    }

    PC = DHPlayer(PRI.Owner);

    return PC != none && PC.IsSL(); // off-map artillery markers are personal
}

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

defaultproperties
{
    TypeName="HE"
    IconMaterial=Material'InterfaceArt_tex.OverheadMap.overheadmap_Icons'
    IconCoords=(X1=0,Y1=64,X2=63,Y2=127)
    IconColor=(R=255,G=255,B=255,A=128)
    OverwritingRule=UNIQUE
    Scope=PERSONAL
    GroupIndex=-1
}
