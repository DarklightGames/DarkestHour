//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHVoteInfo_TeamSurrender extends DHVoteInfo;

var() config int    EndRoundDelaySeconds;       // The time delay before the round ends after the vote has passed.
var() config int    RoundTimeRequiredSeconds;   // How soon the vote can be nominated after a round begins.

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
    VoteResults = Class'UInteger'.static.FromBytes(int(!bVotePassed),
                                                   Options[0].Voters.Length,
                                                   VotesThresholdCount);

    // Inform the team that the vote has concluded.
    for (C = Level.ControllerList; C != none; C = C.nextController)
    {
        PC = DHPlayer(C);

        if (PC != none && C.GetTeamNum() == TeamIndex)
        {
            PC.ReceiveLocalizedMessage(Class'DHTeamSurrenderVoteMessage', VoteResults);
            PC.bSurrendered = false;
        }
    }

    SendMetricsEvent("surrender", int(!bVotePassed));

    if (bVotePassed)
    {
        // Inform both teams and end the round after a brief delay.
        G.DelayedEndRound(default.EndRoundDelaySeconds,
                          REASON_Surrendered,
                          int(!bool(TeamIndex)),
                          Class'DHEnemyInformationMsg',
                          1,
                          Class'DHFriendlyinformationmsg',
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
        Class'DarkestHourGame'.static.BroadcastTeamLocalizedMessage(Level,
                                                                    PC.GetTeamNum(),
                                                                    Class'DHTeamSurrenderVoteMessage',
                                                                    Class'UInteger'.static.FromBytes(2, NominationsRemaining),
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

    if (GRI.DelayedRoundWinnerTeamIndex < 2)
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
    if (!Class'DH_LevelInfo'.static.DHDebugMode() &&
        GRI.bIsInSetupPhase)
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
    if (VM.GetVoteTime(Class'DHVoteInfo_TeamSurrender', TeamIndex) > GRI.ElapsedTime)
    {
        PC.ClientTeamSurrenderResponse(6);
        return false;
    }

    return true;
}

defaultproperties
{
    QuestionText="Do you want to retreat to fight another day?"

    bIsGlobalVote=false
    bNominatorsVoteAutomatically=true
    // Players notoriously refuse to surrender even when they're getting their
    // asses handed to them and the team is screaming at each other and
    // completely demoralized. Plus some people are dummies and don't vote.
    // This has been adjusted many times.
    VotesThresholdPercent=0.66666666
    CooldownSeconds=300
    EndRoundDelaySeconds=15
    RoundTimeRequiredSeconds=900
    NominationsThresholdPercent=0.15
}
