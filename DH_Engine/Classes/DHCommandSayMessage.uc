//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHCommandSayMessage extends DHLocalMessage
    abstract;

static function string AssembleString(HUD myHUD, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional string MessageString)
{
    if (RelatedPRI_1 == none || RelatedPRI_1.PlayerName == "")
    {
        return "";
    }

    // TODO: show name of squad here too, maybe.
    return default.MessagePrefix @ RelatedPRI_1.PlayerName @ ":" @ Class'GameInfo'.static.MakeColorCode(Class'UColor'.default.White) $ MessageString;
}

static function Color GetDHConsoleColor(PlayerReplicationInfo RelatedPRI_1, bool bSimpleColours)
{
    return default.DrawColor;
}

defaultproperties
{
    MessagePrefix="[COMMAND]"
    bComplexString=true
    bBeep=true
    DrawColor=(R=225,G=105,B=45,A=255)
}

