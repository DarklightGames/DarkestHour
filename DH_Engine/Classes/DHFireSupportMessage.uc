//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
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
    local DHSquadReplicationInfo  SRI;
    local DHPlayer                PC;
    local string                  SquadName;
    local UInteger                LockExpiry;

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
            // {squad} squad leader has marked a target for artillery barrage.
            // off-map fire support (called by radio)
            PRI_1 = DHPlayerReplicationInfo(RelatedPRI_1); // artillery spotter
            PRI_2 = DHPlayerReplicationInfo(RelatedPRI_2); // radioman

            if (PRI_1 != none && PRI_2 != none)
            {
                PC = DHPlayer(PRI_2.Owner);
                if(PC != none)
                {
                    SRI = PC.SquadReplicationInfo;
                    if(SRI != none)
                    {
                        SquadName = SRI.GetSquadName(PRI_1.Team.TeamIndex, PRI_1.SquadIndex);
                        return Repl(default.RadiomanNotification, "{squad}", SquadName);
                    }
                }
            }

            break;
        case 3:
            // A new {type} target has been marked.
            // on-map fire support (mortars/Priests/LeIGs etc.)
            MapMarkerClass = class<DHMapMarker>(OptionalObject);

            if (MapMarkerClass != none)
            {
                return Repl(default.ArtilleryOperatorNotification, "{type}", MapMarkerClass.default.MarkerName);
            }

            break;
        case 4:
            return default.ErrorText;
            break;
        default:
            break;
    }

    return "";
}

defaultproperties
{
    OnMapArtilleryRequestConfirmedText="Requested on-map fire support."
    OffMapArtilleryRequestConfirmedText="Marked an off-map support target."
    OnMapArtilleryRequestingLocked="You cannot place another on-map fire support mark for another {seconds} seconds."
    RadiomanNotification="{squad} squad leader has marked a target for fire support."
    ArtilleryOperatorNotification="A new {type} target has been marked."
    ErrorText="Could not place fire support marker."
}

