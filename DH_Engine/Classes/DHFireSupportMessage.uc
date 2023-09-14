//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHFireSupportMessage extends ROCriticalMessage;

var localized string OnMapArtilleryRequestConfirmedText;
var localized string OffMapArtilleryRequestConfirmedText;
var localized string OnMapArtilleryRequestingLocked;
var localized string RadiomanNotification;
var localized string ArtilleryOperatorNotification;
var localized string ErrorText;

static function string GetString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
    local class<DHMapMarker>      MapMarkerClass;
    local DHPlayerReplicationInfo PRI_1;
    local DHPlayerReplicationInfo PRI_2;
    local DHPlayer                PC;
    local UInteger                LockExpiry;
    local string                  S;

    switch (Switch)
    {
        case 0:
            // Location has been marked.
            MapMarkerClass = class<DHMapMarker>(OptionalObject);

            if (MapMarkerClass != none)
            {
                switch (MapMarkerClass.default.Type)
                {
                    case MT_OffMapArtilleryRequest:
                        return default.OffMapArtilleryRequestConfirmedText;
                    case MT_OnMapArtilleryRequest:
                        return default.OnMapArtilleryRequestConfirmedText;
                }
            }

            break;
        case 1:
            // You cannot do another fire support request for another {seconds} seconds.
            LockExpiry = UInteger(OptionalObject);

            if (LockExpiry != none)
            {
                return Repl(default.OnMapArtilleryRequestingLocked, "{seconds}", LockExpiry.Value);
            }

            break;
        case 2:
            // {squad} squad has marked a target for long-range fire support.
            // off-map fire support (called by radio)
            PRI_1 = DHPlayerReplicationInfo(RelatedPRI_1); // artillery spotter
            PRI_2 = DHPlayerReplicationInfo(RelatedPRI_2); // radioman

            if (PRI_2 != none)
            {
                PC = DHPlayer(PRI_2.Owner);
            }

            if (PC != none && PC.SquadReplicationInfo != none && PRI_1 != none)
            {
                return Repl(default.RadiomanNotification, "{squad}", PC.SquadReplicationInfo.GetSquadName(PRI_1.Team.TeamIndex, PRI_1.SquadIndex));
            }

            break;
        case 3:
            // {squad} squad has marked a {type} target for fire support.
            // on-map fire support (mortars/Priests/LeIGs etc.)
            PRI_1 = DHPlayerReplicationInfo(RelatedPRI_1); // artillery spotter
            PRI_2 = DHPlayerReplicationInfo(RelatedPRI_2); // radioman

            if (PRI_2 != none)
            {
                PC = DHPlayer(PRI_2.Owner);
            }

            MapMarkerClass = class<DHMapMarker>(OptionalObject);

            if (MapMarkerClass != none && PRI_1 != none && PC != none && PC.SquadReplicationInfo != none)
            {
                S = default.ArtilleryOperatorNotification;
                S = Repl(S, "{type}", MapMarkerClass.default.MarkerName);
                S = Repl(S, "{squad}", PC.SquadReplicationInfo.GetSquadName(PRI_1.Team.TeamIndex, PRI_1.SquadIndex));

                return S;
            }

            break;
        case 4:
            return default.ErrorText;
        default:
            break;
    }

    return "";
}

defaultproperties
{
    OnMapArtilleryRequestConfirmedText="Fire support target has been marked."
    OffMapArtilleryRequestConfirmedText="Long-range fire support target has been marked."
    OnMapArtilleryRequestingLocked="You cannot place another fire support marker for another {seconds} seconds."
    RadiomanNotification="{squad} squad has marked a target for long-range fire support."
    ArtilleryOperatorNotification="{squad} squad has marked a {type} target for fire support."
    ErrorText="Could not place fire support marker."
}

