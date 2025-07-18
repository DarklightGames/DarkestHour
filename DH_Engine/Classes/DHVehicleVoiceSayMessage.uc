//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHVehicleVoiceSayMessage extends DHLocalMessage
    abstract;

static function string AssembleString(HUD myHUD, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional string MessageString)
{
    local Color ConsoleColor, NameColor;
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
        NameColor = Class'DHColor'.default.SquadColor;
    }
    else
    {
        NameColor = ConsoleColor;
    }

    return default.MessagePrefix @ Class'GameInfo'.static.MakeColorCode(NameColor) $ RelatedPRI_1.PlayerName $ Class'GameInfo'.static.MakeColorCode(ConsoleColor) @ ":" @ MessageString;
}

static function Color GetDHConsoleColor(PlayerReplicationInfo RelatedPRI_1, bool bSimpleColours)
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
