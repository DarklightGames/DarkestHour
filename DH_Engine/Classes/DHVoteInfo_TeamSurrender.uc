//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHVoteInfo_TeamSurrender extends DHVoteInfo;

var int TeamIndex;

function array<PlayerController> GetEligibleVoters()
{
    local array<PlayerController> EligibleVoters;
    local Controller C;
    local PlayerController PC;

    for (C = Level.ControllerList; C != none; C = C.nextController)
    {
        PC = PlayerController(C);

        if (PC != none && PC.GetTeamNum() == TeamIndex)
        {
            EligibleVoters[Voters.Length] = PC;
        }
    }

    return EligibleVoters;
}

function OnVoteEnded()
{
    local int i;

    Level.Game.Broadcast(self, "VOTE ENDED");

    for (i = 0; i < Options.Length; ++i)
    {
        Level.Game.Broadcast(self, "[" $ Options[i].Text $ "]" @ Options[i].Votes);
    }
}

defaultproperties
{
    QuestionText="Do you want to throw down your weapons and surrender?"
}

