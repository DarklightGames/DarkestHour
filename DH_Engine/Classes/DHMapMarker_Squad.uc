//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHMapMarker_Squad extends DHMapMarker
    abstract;

var int BroadcastedMessageIndex;

static function OnMapMarkerPlaced(DHPlayer PC, DHGameReplicationInfo.MapMarker Marker)
{
    if (PC != none && PC.SquadReplicationInfo != none)
    {
        PC.SquadReplicationInfo.BroadcastSquadLocalizedMessage(PC.GetTeamNum(), PC.GetSquadIndex(), class'DHSquadOrderMessage', default.BroadcastedMessageIndex);
    }
}

defaultproperties
{
    BroadcastedMessageIndex=0
    GroupIndex=0
    bShouldShowOnCompass=true
    OverwritingRule=UNIQUE_PER_GROUP
    Scope=SQUAD
    Permissions_CanSee(0)=(LevelSelector=SQUAD,RoleSelector=ALL)
    Permissions_CanRemove(0)=(LevelSelector=SQUAD,RoleSelector=SL)
    Permissions_CanPlace(0)=(LevelSelector=SQUAD,RoleSelector=SL)
}
