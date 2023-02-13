//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMapMarker_FireSupport_OffMap extends DHMapMarker
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

    return PRI != none && PC != none && !PC.IsPositionOfParadrop(Marker.WorldLocation);
}

static function OnMapMarkerPlaced(DHPlayer PC, DHGameReplicationInfo.MapMarker Marker)
{
    super.OnMapMarkerPlaced(PC, Marker);

    // Tell the player to find a radio so that they can call in off-map support
    PC.QueueHint(54, true);

    PC.ServerSaveArtilleryTarget(Marker.WorldLocation);
}

static function OnMapMarkerRemoved(DHPlayer PC, DHGameReplicationInfo.MapMarker Marker)
{
    PC.ServerSaveArtilleryTarget(vect(0, 0, 0));
}

defaultproperties
{
    MarkerName="Long-Range Fire Support"
    IconMaterial=Material'InterfaceArt_tex.OverheadMap.overheadmap_Icons'
    IconCoords=(X1=0,Y1=64,X2=63,Y2=127)
    IconColor=(R=255,G=255,B=255,A=128)
    Type=MT_OffMapArtilleryRequest
    Scope=PERSONAL
    OverwritingRule=UNIQUE
    GroupIndex=3
    Cooldown=3
    OnPlacedExternalNotifications(0)=(RoleSelector=ERS_RADIOMAN,Message=class'DHFireSupportMessage',MessageIndex=2)
    OnPlacedMessage=class'DHFireSupportMessage'
    OnPlacedMessageIndex=0
}
