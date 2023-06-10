//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHVoteInfo_TeamSurrender extends DHVoteInfo;

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
            EligibleVoters[EligibleVoters.Length] = PC;
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
        GRI.SetSurrenderVoteInProgress(TeamIndex, true);
    }
}

function OnVoteEnded()
{
    local DarkestHourGame G;
    local int VoteResults, VotesThresholdCount;
    local DHPlayer PC;
    local Controller C;
    local DHGameReplicationInfo GRI;
    local bool bVotePassed;

    G = DarkestHourGame(Level.Game);

    if (G == none || VoterCount == 0)
    {
        return;
    }

    VotesThresholdCount = GetVotesThresholdCount(G);

    bVotePassed = Options[0].Voters.Length >= VotesThresholdCount;
    VoteResults = class'UInteger'.static.FromBytes(int(!bVotePassed),
                                                   Options[0].Voters.Length,
                                                   VotesThresholdCount);

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
        G.DelayedEndRound(G.default.SurrenderEndRoundDelaySeconds,
                          "The {0} won the round because the other team has retreated",
                          int(!bool(TeamIndex)),
                          class'DHEnemyInformationMsg',
                          1,
                          class'DHFriendlyinformationmsg',
                          0);
    }

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI != none)
    {
        GRI.SetSurrenderVoteInProgress(TeamIndex, false);
    }
}

// Overriden to ignore non-voters in the final results.
function int GetVoterCount()
{
    local int i, Count;

    for (i = 0; i < Options.Length; ++i)
    {
        Count += Options[i].Voters.Length;
    }

    return Count;
}

static function OnNominated(PlayerController Player, LevelInfo Level, optional int NominationsRemaining)
{
    local DHPlayer PC;

    PC = DHPlayer(Player);

    if (Level != none && PC != none && PC.PlayerReplicationInfo != none)
    {
        PC.bSurrendered = true;

        // DHPlayer wants to surrender.
        class'DarkestHourGame'.static.BroadcastTeamLocalizedMessage(Level,
                                                                    PC.GetTeamNum(),
                                                                    class'DHTeamSurrenderVoteMessage',
                                                                    class'UInteger'.static.FromBytes(2, NominationsRemaining),
                                                                    PC.PlayerReplicationInfo);
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
    if (!class'DH_LevelInfo'.static.DHDebugMode() &&
        GRI.bIsInSetupPhase)
    {
        PC.ClientTeamSurrenderResponse(10);
        return false;
    }

    // You cannot vote to surrender this early.
    if (GetRoundTimeRequiredSeconds() >= GRI.ElapsedTime)
    {
        PC.ClientTeamSurrenderResponse(9);
        return false;
    }

    // Vote in play.
    if (VM.GetVoteIndex(default.Class, TeamIndex) >= 0)
    {
        PC.ClientTeamSurrenderResponse(4);
        return false;
    }

    // You've already surrendered.
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

static function float GetNominationsThresholdPercent()
{
    return FMax(0.0, class'DarkestHourGame'.default.SurrenderNominationsThresholdPercent);
}

static function float GetVotesThresholdPercent()
{
    return FMax(0.0, class'DarkestHourGame'.default.SurrenderVotesThresholdPercent);
}

static function float GetReinforcementsRequiredPercent()
{
    return FMax(0.0, class'DarkestHourGame'.default.SurrenderReinforcementsRequiredPercent);
}

static function int GetRoundTimeRequiredSeconds()
{
    return Max(0, class'DarkestHourGame'.default.SurrenderRoundTimeRequiredSeconds);
}

static function int GetCooldownSeconds()
{
    return Max(0, class'DarkestHourGame'.default.SurrenderCooldownSeconds);
}

defaultproperties
{
    QuestionText="Do you want to retreat to fight another day?"

    bIsGlobalVote=false
    bNominatorsVoteAutomatically=true
    // Players notoriously refuse to surrender even when they're getting their
    // asses handed to them and the team is screaming at each other and
    // completely demoralized. Plus some people are dummies and don't vote.
    // For everyone's sanity, we set this at 40%.
    VotesThresholdPercent=0.4
}
