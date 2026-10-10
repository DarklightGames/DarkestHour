//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHAdminMessage extends LocalMessage
    abstract;

var localized string KickedFromSquadMessage;
var localized string PromotedToSquadLeaderMessage;
var localized string PlacedSpawnMessage;
var localized string DestroyedSpawnMessage;
var localized string DestroyedAllSpawnsMessage;
var localized string AdminTeleportedMessage;
var localized string AlliedTeamNameGenitive;
var localized string AxisTeamNameGenitive;
var localized string AdminLoggedInMessage;
var localized string AdminLoggedOutMessage;
var localized string PlayerMessagesRestrictionMessage;
var localized string PlayerVoiceRestrictionMessage;
var localized string PlayerNameRestrictionMesssage;
var localized string PlayerVehicleAccessRestrictionMessage;

static function string GetSquadName(int TeamIndex, int SquadIndex, DHSquadReplicationInfo SRI)
{
    if (SRI != none)
    {
        return SRI.GetSquadName(TeamIndex, SquadIndex);
    }
}

static function string GetTeamName(int TeamIndex)
{
    switch (TeamIndex)
    {
        case 0:
            return default.AxisTeamNameGenitive;
        case 1:
            return default.AlliedTeamNameGenitive;
    }
}

static function string GetString(optional int S, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local int ExtraValue;

    Class'UInteger'.static.ToShorts(S, S, ExtraValue);

    switch (S)
    {
        case 0:
            return Repl(Repl(Repl(default.KickedFromSquadMessage,
                                  "{0}", RelatedPRI_1.PlayerName),
                                  "{1}", RelatedPRI_2.PlayerName),
                                  "{2}", static.GetSquadName(RelatedPRI_2.Team.TeamIndex, ExtraValue, DHSquadReplicationInfo(OptionalObject)));
        case 1:
            return Repl(Repl(Repl(default.PromotedToSquadLeaderMessage,
                                  "{0}", RelatedPRI_1.PlayerName),
                                  "{1}", RelatedPRI_2.PlayerName),
                                  "{2}", static.GetSquadName(RelatedPRI_2.Team.TeamIndex, ExtraValue, DHSquadReplicationInfo(OptionalObject)));
        case 2:
            return Repl(Repl(default.PlacedSpawnMessage, "{0}", RelatedPRI_1.PlayerName), "{1}", static.GetTeamName(ExtraValue));
        case 3:
            return Repl(Repl(default.DestroyedSpawnMessage, "{0}", RelatedPRI_1.PlayerName), "{1}", static.GetTeamName(ExtraValue));
        case 4:
            return Repl(Repl(default.DestroyedAllSpawnsMessage, "{0}", RelatedPRI_1.PlayerName), "{1}", static.GetTeamName(ExtraValue));
        case 5:
            return Repl(default.AdminTeleportedMessage, "{0}", RelatedPRI_1.PlayerName);
        case 6:
            return Repl(default.AdminLoggedInMessage, "{0}", RelatedPRI_1.PlayerName);
        case 7:
            return Repl(default.AdminLoggedOutMessage, "{0}", RelatedPRI_1.PlayerName);
        case 8:
            return default.PlayerMessagesRestrictionMessage;
        case 9:
            return default.PlayerVoiceRestrictionMessage;
        case 10:
            return default.PlayerNameRestrictionMesssage;
        case 11:
            return default.PlayerVehicleAccessRestrictionMessage;
        default:
            break;
    }

    return "";
}

defaultproperties
{
    DrawColor=(R=255,G=165,B=0,A=255)

    KickedFromSquadMessage="Admin '{0}' kicked '{1}' from squad '{2}'."
    PromotedToSquadLeaderMessage="Admin '{0}' promoted '{1}' to lead squad '{2}'."
    PlacedSpawnMessage="Admin '{0}' has placed a spawn on {1} team."
    DestroyedSpawnMessage="Admin '{0}' has destroyed an admin-placed spawn on {1} team."
    DestroyedAllSpawnsMessage="Admin '{0}' destroyed all admin-placed spawns on {1} team."
    AdminTeleportedMessage="Admin '{0}' has teleported."
    AdminLoggedInMessage="{0} logged in as a server administrator."
    AdminLoggedOutMessage="{0} gave up administrator abilities."
    AlliedTeamNameGenitive="Allied"
    AxisTeamNameGenitive="Axis"
    PlayerMessagesRestrictionMessage="You're not allowed to send messages on this server."
    PlayerVoiceRestrictionMessage="You're not allowed to speak in the voice chat on this server."
    PlayerNameRestrictionMesssage="You're not allowed to change your name on this server."
    PlayerVehicleAccessRestrictionMessage="Your access to vehicles has been revoked on this server."

    bIsSpecial=false
    bIsConsoleMessage=true
    LifeTime=8.0
}
