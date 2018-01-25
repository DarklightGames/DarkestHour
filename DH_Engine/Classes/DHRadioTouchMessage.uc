//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHRadioTouchMessage extends ROTouchMessagePlus
    abstract;

var localized string NoTargetMessage;
var localized string CallArtilleryMessage;
var localized string NotSquadLeader;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local PlayerController PC;

    PC = PlayerController(OptionalObject);

    switch (Switch)
    {
        case 0:
            return default.NoTargetMessage;
        case 1:
            return class'DarkestHourGame'.static.ParseLoadingHintNoColor(default.CallArtilleryMessage, PC);
        case 2:
            return default.NotSquadLeader;
    }

    return "";
}

defaultproperties
{
    NoTargetMessage="No target marked. Use binoculars to mark a target."
    CallArtilleryMessage="Press [%USE%] to call artillery."
    NotSquadLeader="You must be a squad leader to use the radio."
}

