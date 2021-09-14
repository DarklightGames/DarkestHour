//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DHFireSupportMessage extends ROCriticalMessage;

var localized string RequestConfirmedText;
var localized string ArtilleryRequestingLocked;
var localized string RadiomanNotification;
var localized string ArtilleryOperatorNotification;

static function string GetString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
    local class<DHMapMarker>              MapMarkerClass;
    local int                             Seconds;
    local DHGameReplicationInfo           GRI;
    local DHPlayerReplicationInfo         PRI;
    local DHSquadReplicationInfo          SRI;
    local DHPlayer                        PC;
    local string                          SquadName;

    switch (Switch)
    {
        case 0:
            // Location has been marked.
            MapMarkerClass = class<DHMapMarker>(OptionalObject);

            if (MapMarkerClass != none
              && (MapMarkerClass.default.Type == MT_OffMapArtilleryRequest
                || MapMarkerClass.default.Type == MT_OnMapArtilleryRequest))
            {
                return default.RequestConfirmedText;
            }

            break;
        case 1:
            // You cannot do another fire support request for another {seconds} seconds.
            PC = DHPlayer(OptionalObject);

            if (PC != none && PC.GameReplicationInfo != none)
            {
                GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
                Seconds = PC.ArtilleryRequestsUnlockTime - GRI.ElapsedTime;
                return Repl(default.ArtilleryRequestingLocked, "{seconds}", Seconds);
            }

            break;
        case 2:
            // {squad} squad leader has marked a target for artillery barrage.
            // off-map fire support (called by radio)
            PC = DHPlayer(OptionalObject);                // radioman
            PRI = DHPlayerReplicationInfo(RelatedPRI_2);  // artillery spotter

            if (PRI != none && PC != none)
            {
                SRI = PC.SquadReplicationInfo;
                SquadName = SRI.GetSquadName(PRI.Team.TeamIndex, PRI.SquadIndex);
                return Repl(default.RadiomanNotification, "{squad}", SquadName);
            }

            break;
        case 3:
            // A new {type} target has been marked.
            // on-map fire support (mortars/Priests/LeIGs etc.)
            MapMarkerClass = class<DHMapMarker>(OptionalObject);

            if (MapMarkerClass != none
              && (MapMarkerClass.default.Type == MT_OffMapArtilleryRequest
                || MapMarkerClass.default.Type == MT_OnMapArtilleryRequest))
            {
                return Repl(default.ArtilleryOperatorNotification, "{type}", MapMarkerClass.default.MarkerName);
            }

            break;
    }

    return "";
}

defaultproperties
{
    RequestConfirmedText="Fire support request has been marked."
    ArtilleryRequestingLocked="You cannot mark another fire support request for another {seconds} seconds."
    RadiomanNotification="{squad} squad leader has marked a target for fire support."
    ArtilleryOperatorNotification="A new {type} target has been marked."
}

