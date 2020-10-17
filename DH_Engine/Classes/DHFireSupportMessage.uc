//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DHFireSupportMessage extends ROCriticalMessage;

var localized string RequestConfirmedText;
var localized string ArtilleryRequestingLocked;

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
        case 1:
            PC = DHPlayer(OptionalObject);
            if (PC != none && PC.GameReplicationInfo != none)
            { 
                GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
                Seconds = PC.ArtilleryRequestsUnlockTime - GRI.ElapsedTime;
                return Repl(default.ArtilleryRequestingLocked, "{seconds}", Seconds);
            }
    }
    return "";
}

defaultproperties
{
    RequestConfirmedText="Artillery request ({type}) has been sent"
    ArtilleryRequestingLocked="You cannot request on-map artillery for another {seconds} seconds."
}

