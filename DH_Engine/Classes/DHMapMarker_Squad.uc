//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMapMarker_Squad extends DHMapMarker
    abstract;

var int BroadcastedMessageIndex;

static function OnMapMarkerPlaced(DHPlayer PC, DHGameReplicationInfo.MapMarker Marker)
{
    super.OnMapMarkerPlaced(PC, Marker);

    if (PC != none && PC.SquadReplicationInfo != none)
    {
        PC.SquadReplicationInfo.BroadcastSquadLocalizedMessage(PC.GetTeamNum(), PC.GetSquadIndex(), class'DHSquadOrderMessage', default.BroadcastedMessageIndex);
    }
}

defaultproperties
{
    GroupIndex=0
    bShouldShowOnCompass=true
    Type=MT_Movement
    OverwritingRule=UNIQUE_PER_GROUP
    Scope=SQUAD
    Permissions_CanSee(0)=(LevelSelector=SQUAD,RoleSelector=ERS_ALL)
    Permissions_CanRemove(0)=(LevelSelector=SQUAD,RoleSelector=ERS_SL)
    Permissions_CanPlace(0)=ERS_SL
}
