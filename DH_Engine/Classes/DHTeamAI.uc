//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHTeamAI extends ROTeamAI;

// Modified to avoid "accessed none" errors on O when using bots
function bool DefendHere(Bot B, GameObjective O)
{
    local SquadAI S;

    for (S = Squads; S != none; S = S.NextSquad)
    {
        if (S.SquadObjective == O && S.Size < S.MaxSquadSize)
        {
            S.AddBot(B);

            return true;
        }
    }

    if (O != none && O.DefenderTeamIndex == Team.TeamIndex)
    {
        O.DefenseSquad = AddSquadWithLeader(B, O);
    }
    else
    {
        AddSquadWithLeader(B, O);
    }

    return true;
}
