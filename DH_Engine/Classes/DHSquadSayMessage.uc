//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHSquadSayMessage extends DHLocalMessage
    abstract;

static function string AssembleString(HUD myHUD, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional string MessageString)
{
    local string SquadMemberID;

    if (RelatedPRI_1 == none || RelatedPRI_1.PlayerName == "")
    {
        return "";
    }

    SquadMemberID = GetSquadMemberID(DHPlayerReplicationInfo(RelatedPRI_1));
    if (SquadMemberID != "") SquadMemberID $= " ";

    return default.MessagePrefix @
           SquadMemberID $
           RelatedPRI_1.PlayerName @
           ":" @
           class'GameInfo'.static.MakeColorCode(class'UColor'.default.White) $
           MessageString;
}

static function Color GetDHConsoleColor(PlayerReplicationInfo RelatedPRI_1, bool bSimpleColours)
{
    return default.DrawColor;
}

defaultproperties
{
    DrawColor=(R=0,G=204,B=0,A=255)
    MessagePrefix="[SQUAD]"
    bComplexString=true
    bBeep=true
}
