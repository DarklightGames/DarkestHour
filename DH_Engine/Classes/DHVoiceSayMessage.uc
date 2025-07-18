//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHVoiceSayMessage extends DHLocalMessage
    abstract;

static function string AssembleString(HUD myHUD, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional string MessageString)
{
    local Color ConsoleColor, NameColor;
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

    if (Class'DHPlayerReplicationInfo'.static.IsInSameSquad(MyPRI, DHPlayerReplicationInfo(RelatedPRI_1)))
    {
        NameColor = Class'DHColor'.default.SquadColor;
        SquadMemberID = GetSquadMemberID(DHPlayerReplicationInfo(RelatedPRI_1));
        if (SquadMemberID != "") SquadMemberID $= " ";
    }
    else
    {
        NameColor = ConsoleColor;
    }

    return default.MessagePrefix @
           Class'GameInfo'.static.MakeColorCode(NameColor) $
           SquadMemberID $
           RelatedPRI_1.PlayerName $
           Class'GameInfo'.static.MakeColorCode(ConsoleColor) @
           ":" @
           MessageString;
}

defaultproperties
{
    MessagePrefix="[VOICE]"
    bComplexString=true
    bBeep=true
}
