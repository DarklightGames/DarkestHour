//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHAdminMessage extends LocalMessage
    abstract;

var localized string KickedFromSquadMessage;
var localized string PromotedToSquadLeaderMessage;

static function string GetSquadName(int TeamIndex, int SquadIndex, DHSquadReplicationInfo SRI)
{
    if (SRI != none)
    {
        return SRI.GetSquadName(TeamIndex, SquadIndex);
    }
}

static function string GetString(optional int S, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local int ExtraValue;

    class'UInteger'.static.ToShorts(S, S, ExtraValue);

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

    bIsSpecial=false
    bIsConsoleMessage=true
    LifeTime=8.0
}
