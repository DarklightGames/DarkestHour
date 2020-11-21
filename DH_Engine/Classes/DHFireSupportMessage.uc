//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DHFireSupportMessage extends ROCriticalMessage;

var localized string RequestConfirmedText;
var localized string ArtilleryRequestingLocked;
var localized string RadiomanNotification;

static function string GetString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
    local class<DHMapMarker_FireSupport> MapMarkerClass;
    local int  Seconds;
    local DHGameReplicationInfo GRI;
    local DHPlayer PC;
    local string SquadName;
    local DHSquadReplicationInfo SRI;

    switch (Switch)
    {
        case 0:
            MapMarkerClass = class<DHMapMarker_FireSupport>(OptionalObject);
            if (MapMarkerClass == none)
            {
                return "";
            }
            else
            {
                return Repl(default.RequestConfirmedText, "{type}", MapMarkerClass.default.TypeName);
            }
            break;
        case 1:
            PC = DHPlayer(OptionalObject);
            if (PC != none && PC.GameReplicationInfo != none)
            { 
                GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
                Seconds = PC.ArtilleryRequestsUnlockTime - GRI.ElapsedTime;
                return Repl(default.ArtilleryRequestingLocked, "{seconds}", Seconds);
            }
            break;
        case 2:
            PC = DHPlayer(OptionalObject);
            if (PC != none && PC.GameReplicationInfo != none)
            {
                GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
                SRI = PC.SquadReplicationInfo;
                SquadName = SRI.GetSquadName(PC.GetTeamNum(), PC.GetSquadIndex());
                return Repl(default.RadiomanNotification, "{squad}", SquadName);
            }
    }
    return "";
}

defaultproperties
{
    RequestConfirmedText="Artillery request ({type}) has been sent"
    ArtilleryRequestingLocked="You cannot request on-map artillery for another {seconds} seconds."
    RadiomanNotification="{squad} squad leader has marked a target for artillery."
}

