//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHVoteInfo_TeamSurrender extends DHVoteInfo;

var bool bOldAllowSurrender;

function StartVote()
{
    local DHGameReplicationInfo GRI;

    super.StartVote();

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI != none)
    {
        // TODO: It's quite likely that client already has this information
        GRI.bSurrenderVoteInProgress = true;
    }
}

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
    local DarkestHourGame G;
    local int VotesNeededToWin;
    local DHPlayer PC;
    local Controller C;
    local DHGameReplicationInfo GRI;

    G = DarkestHourGame(Level.Game);

    if (G == none)
    {
        return;
    }

    VotesNeededToWin = Ceil(VoterCount * 0.5);

    if (Options[0].Votes >= VotesNeededToWin)
    {
        // Inform both teams and end the round after a brief delay.
        G.DelayedEndRound(G.default.SurrenderRoundTime,
                          "The {0} won the round because the other team has surrendered",
                          int(!bool(TeamIndex)),
                          class'DHEnemyInformationMsg',
                          1,
                          class'DHFriendlyinformationmsg',
                          0);
    }
    else
    {
        // Inform the team that the surrender vote failed.
        for (C = Level.ControllerList; C != none; C = C.nextController)
        {
            PC = DHPlayer(C);

            if (PC != none && C.GetTeamNum() == TeamIndex)
            {
                // "Your team voted to continue fighting."
                PC.ReceiveLocalizedMessage(class'DHTeamSurrenderVoteMessage', 0);
                PC.bSurrendered = false;
            }
        }
    }

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI != none)
    {
        GRI.bSurrenderVoteInProgress = false;
    }
}

static function OnNominated(PlayerController Player)
{
    local DHPlayer PC;

    PC = DHPlayer(Player);

    if (PC != none)
    {
        PC.ClientTeamSurrenderResponse(-1);
    }
}

static function OnNominationRemoved(PlayerController Player)
{
    local DHPlayer PC;

    PC = DHPlayer(Player);

    if (PC != none)
    {
        PC.bSurrendered = false;
    }
}

static function bool CanNominate(PlayerController Player, DarkestHourGame Game)
{
    local DHGameReplicationInfo GRI;
    local DHVoteManager VM;
    local DHPlayer PC;
    local byte TeamIndex;
    local int TeamSizes[2];

    PC = DHPlayer(Player);

    if (PC == none || Game == none)
    {
        return false;
    }

    VM = Game.VoteManager;
    GRI = DHGameReplicationInfo(Game.GameReplicationInfo);

    if (VM == none || GRI == none)
    {
        PC.ClientTeamSurrenderResponse(0);
        return false;
    }

    // Round is not in play.
    if (!Game.IsInState('RoundInPlay'))
    {
        PC.ClientTeamSurrenderResponse(2);
        return false;
    }

    if (GRI.RoundWinnerTeamIndex < 2)
    {
        PC.ClientTeamSurrenderResponse(7);
        return false;
    }

    TeamIndex = PC.GetTeamNum();
    Game.GetTeamSizes(TeamSizes);

    if (TeamIndex < 2 && TeamIndex < arraycount(TeamSizes))
    {
        // Surrendering can only be voted for with ~16+ people on a team.
        if (TeamSizes[TeamIndex] < default.TeamSizeMin)
        {
            PC.ClientTeamSurrenderResponse(3);
            return false;
        }
    }
    else
    {
        // Invalid team.
        PC.ClientTeamSurrenderResponse(1);
        return false;
    }

    // Vote in play.
    if (VM.GetVoteIndex(default.Class, TeamIndex) >= 0)
    {
        PC.ClientTeamSurrenderResponse(4);
        return false;
    }

    // Already voted to surender.
    if (VM.HasPlayerNominatedVote(PC))
    {
        PC.ClientTeamSurrenderResponse(5);
        return false;
    }

    // You cannot vote to surrender yet.
    if (VM.GetVoteTime(class'DHVoteInfo_TeamSurrender', TeamIndex) > GRI.ElapsedTime)
    {
        PC.ClientTeamSurrenderResponse(6);
        return false;
    }

    // TODO: Add reinforcements requirement

    return true;
}

defaultproperties
{
    QuestionText="Do you want to throw down your weapons and surrendered?"

    bIsGlobal=false
    NominationCountThreshold=6
    CooldownSeconds=300
    TeamSizeMin=16
}
