//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DHVoiceSayMessage extends DHLocalMessage
    abstract;

static function string AssembleString(HUD myHUD, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional string MessageString)
{
    local color ConsoleColor, NameColor;
    local DHPlayerReplicationInfo MyPRI, OtherPRI;

    if (RelatedPRI_1 == none || RelatedPRI_1.PlayerName == "")
    {
        return "";
    }

    MyPRI = DHPlayerReplicationInfo(myHUD.PlayerOwner.PlayerReplicationInfo);
    OtherPRI = DHPlayerReplicationInfo(RelatedPRI_1);
    ConsoleColor = GetDHConsoleColor(RelatedPRI_1, 0, false);

    if (MyPRI != none && OtherPRI != none && MyPRI.SquadIndex != -1 && MyPRI.SquadIndex == OtherPRI.SquadIndex)
    {
        NameColor = class'DHColor'.default.SquadColor;
    }
    else
    {
        NameColor = ConsoleColor;
    }

    return default.MessagePrefix @ class'GameInfo'.static.MakeColorCode(NameColor) $ RelatedPRI_1.PlayerName $ class'GameInfo'.static.MakeColorCode(ConsoleColor) @ ":" @ MessageString;
}

defaultproperties
{
    MessagePrefix="[VOICE]"
    bComplexString=true
    bBeep=true
}

