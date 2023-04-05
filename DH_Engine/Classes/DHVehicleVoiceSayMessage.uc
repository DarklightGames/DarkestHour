//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHVehicleVoiceSayMessage extends DHLocalMessage
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
    ConsoleColor = GetDHConsoleColor(RelatedPRI_1, false);

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

static function color GetDHConsoleColor(PlayerReplicationInfo RelatedPRI_1, bool bSimpleColours)
{
    return default.DrawColor;
}

defaultproperties
{
    DrawColor=(B=170,G=30,R=170,A=255)
    MessagePrefix="[VOICE]"
    bComplexString=true
    bBeep=true
}
