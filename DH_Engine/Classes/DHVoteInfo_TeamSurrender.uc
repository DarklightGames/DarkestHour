//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHVoteInfo_TeamSurrender extends DHVoteInfo;

var bool  bOldAllowSurrender;
var int   RoundTimeRequiredSeconds;
var float ReinforcementsRequiredPercent;

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

function OnVoteStarted()
{
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI != none)
    {
        GRI.bIsSurrenderVoteInProgress = true;
    }
}

function OnVoteEnded()
{
    local DarkestHourGame G;
    local int VoteResults;
    local DHPlayer PC;
    local Controller C;
    local DHGameReplicationInfo GRI;
    local bool bVotePassed;

    G = DarkestHourGame(Level.Game);

    if (G == none)
    {
        return;
    }

    bVotePassed = Options[0].Voters.Length >= Ceil(VoterCount * VotePassedThresholdPercent);
    VoteResults = class'UInteger'.static.FromShorts(int(!bVotePassed),
                                                    Ceil(Options[0].Voters.Length / VoterCount * 100));

    // Inform the team that the vote has concluded.
    for (C = Level.ControllerList; C != none; C = C.nextController)
    {
        PC = DHPlayer(C);

        if (PC != none && C.GetTeamNum() == TeamIndex)
        {
            PC.ReceiveLocalizedMessage(class'DHTeamSurrenderVoteMessage', VoteResults);
            PC.bSurrendered = false;
        }
    }

    SendMetricsEvent("surrender", int(!bVotePassed));

    if (bVotePassed)
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

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI != none)
    {
        GRI.bIsSurrenderVoteInProgress = false;
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

    // Surrender vote is disabled.
    if (!GRI.bIsSurrenderVoteEnabled)
    {
        PC.ClientTeamSurrenderResponse(3);
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

    if (TeamIndex > 1)
    {
        // Invalid team.
        PC.ClientTeamSurrenderResponse(1);
        return false;
    }

    // You cannot vote to surrender during the setup phase.
    if (GRI.bIsInSetupPhase)
    {
        PC.ClientTeamSurrenderResponse(10);
        return false;
    }

    // You cannot vote to surrender this early.
    if (default.RoundTimeRequiredSeconds >= GRI.ElapsedTime)
    {
        PC.ClientTeamSurrenderResponse(9);
        return false;
    }

    // Reinforcements are above the limit.
    if (GRI.SpawnsRemaining[TeamIndex] >= 0 &&
        GRI.SpawnsRemaining[TeamIndex] >= Game.SpawnsAtRoundStart[TeamIndex] * default.ReinforcementsRequiredPercent)
    {
        PC.ClientTeamSurrenderResponse(8);
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

    // The team has voted to surrender recently.
    if (VM.GetVoteTime(class'DHVoteInfo_TeamSurrender', TeamIndex) > GRI.ElapsedTime)
    {
        PC.ClientTeamSurrenderResponse(6);
        return false;
    }

    return true;
}

defaultproperties
{
    QuestionText="Do you want to throw down your weapons and surrender?"

    bIsGlobal=false
    bNominatorsVoteAutomatically=true

    CooldownSeconds=300
    RoundTimeRequiredSeconds=900
    ReinforcementsRequiredPercent=0.5

    NominationThresholdPercent=0.25
    VotePassedThresholdPercent=0.6
}
