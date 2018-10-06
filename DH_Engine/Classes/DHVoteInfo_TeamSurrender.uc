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
    local DarkestHourGame G;
    local int VotesNeededToWin;
    local PlayerController PC;
    local Controller C;

    G = DarkestHourGame(Level.Game);

    if (G == none)
    {
        return;
    }

    VotesNeededToWin = int(VoterCount * 0.5);

    if (Options[0].Votes >= VotesNeededToWin)
    {
        // TODO: having these as
        Level.Game.Broadcast(self, "The round ended because a team voted to surrender.", 'Say');

        G.EndRound(int(!bool(TeamIndex)));
    }
    else
    {
        for (C = Level.ControllerList; C != none; C = C.nextController)
        {
            PC = PlayerController(C);

            if (PC != none && C.GetTeamNum() == TeamIndex)
            {
//                PC.ReceiveLocalizedMessage(class'DHTeamSurrenderVoteMessage', 0
            }
        }
    }
}

defaultproperties
{
    QuestionText="Do you want to throw down your weapons and surrender?"
}

