//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHLocalMessage extends LocalMessage
    abstract;

var localized string MessagePrefix;
var localized string SpecPrefix;
var localized string SquadLeaderID;
var localized string SquadAssistantID;
var           string SquadMemberIDFormat;

static function string GetSquadMemberID(DHPlayerReplicationInfo PRI)
{
    if (PRI == none || PRI.SquadIndex < 0 || PRI.SquadMemberIndex < 0)
    {
        return "";
    }

    if (PRI.IsSquadLeader())
    {
        return Repl(default.SquadMemberIDFormat, "{0}", default.SquadLeaderID);
    }
    else if (PRI.IsAssistantLeader())
    {
        return Repl(default.SquadMemberIDFormat, "{0}", default.SquadAssistantID);
    }
    else
    {
        return Repl(default.SquadMemberIDFormat, "{0}", PRI.SquadMemberIndex + 1);
    }
}

static function string AssembleString(HUD myHUD, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional string MessageString)
{
    return MessageString;
}

static function Color GetDHConsoleColor(PlayerReplicationInfo RelatedPRI_1, bool bSimpleColours)
{
    if (RelatedPRI_1 != none &&
        RelatedPRI_1.Team != none &&
        RelatedPRI_1.Team.TeamIndex >= 0 &&
        RelatedPRI_1.Team.TeamIndex < arraycount(Class'DHColor'.default.TeamColors))
    {
        return Class'DHColor'.default.TeamColors[RelatedPRI_1.Team.TeamIndex];
    }

    return default.DrawColor;
}

defaultproperties
{
    SquadMemberIDFormat="[{0}]"
    SquadAssistantID="A"
    SquadLeaderID="SL"

    bIsSpecial=false
    LifeTime=8
    PosY=0.7
}
