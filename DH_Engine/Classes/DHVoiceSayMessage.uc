//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHVoiceSayMessage extends DHLocalMessage
    abstract;

static function string AssembleString(HUD myHUD, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional string MessageString)
{
    local color ConsoleColor, NameColor;
    local DHPlayerReplicationInfo MyPRI;
    local string SquadMemberID;

    if (RelatedPRI_1 == none || RelatedPRI_1.PlayerName == "")
    {
        return "";
    }

    ConsoleColor = GetDHConsoleColor(RelatedPRI_1, false);

    if (myHUD != none && myHUD.PlayerOwner != none)
    {
        MyPRI = DHPlayerReplicationInfo(myHUD.PlayerOwner.PlayerReplicationInfo);
    }

    if (class'DHPlayerReplicationInfo'.static.IsInSameSquad(MyPRI, DHPlayerReplicationInfo(RelatedPRI_1)))
    {
        NameColor = class'DHColor'.default.SquadColor;
        SquadMemberID = GetSquadMemberID(DHPlayerReplicationInfo(RelatedPRI_1));
        if (SquadMemberID != "") SquadMemberID $= " ";
    }
    else
    {
        NameColor = ConsoleColor;
    }

    return default.MessagePrefix @
           class'GameInfo'.static.MakeColorCode(NameColor) $
           SquadMemberID $
           RelatedPRI_1.PlayerName $
           class'GameInfo'.static.MakeColorCode(ConsoleColor) @
           ":" @
           MessageString;
}

defaultproperties
{
    MessagePrefix="[VOICE]"
    bComplexString=true
    bBeep=true
}
