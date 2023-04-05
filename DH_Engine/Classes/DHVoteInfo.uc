//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHVoteInfo extends Info
    abstract;

struct Option
{
    var localized string Text;
    var array<PlayerController> Voters;
};

var int                        VoteId;
var int                        TeamIndex;
var int                        VoterCount;
var array<Option>              Options;
var array<PlayerController>    Voters;
var array<PlayerController>    Nominators;
var DateTime                   StartedAt;
var DateTime                   EndedAt;

var class<DHPromptInteraction> VoteInteractionClass;
var localized string           QuestionText;

// Rules
var bool  bIsGlobalVote;               // Do both teams participate?
var int   CooldownSeconds;             // The time between the votes
var float DurationSeconds;             // How until the vote closes
var float VotesThresholdPercent;       // votes needed to pass
var float NominationsThresholdPercent; // Nominations needed to start the vote

// Should nominators receive the prompt or vote automatically?
var bool  bNominatorsVoteAutomatically;
var int   NominatorsDefaultOption;

// Gets the list of eligible voters.
function array<PlayerController> GetEligibleVoters();

function string GetQuestionText()
{
    return default.QuestionText;
}

function Destroyed()
{
    EndedAt = class'DateTime'.static.Now(self);
    OnVoteEnded();
}

function StartVote()
{
    local int i, TempVoterCount;
    local DHPlayer PC;

    if (VoteId == -1)
    {
        Error("Attempted to start a vote without being registered via DarkestHourGame");
        return;
    }

    Options = GetOptions();

    if (Options.Length == 0)
    {
        Error("No voting options.");
        return;
    }

    Voters = GetEligibleVoters();

    if (Voters.Length == 0)
    {
        Error("No eligible voters.");
        return;
    }

    VoterCount = Voters.Length;

    StartedAt = class'DateTime'.static.Now(self);
    OnVoteStarted();

    if (bNominatorsVoteAutomatically)
    {
        i = 0; while (i < Voters.Length)
        {
            if (Voters[i] != none && class'UArray'.static.IndexOf(Nominators, Voters[i]) >= 0)
            {
                TempVoterCount = Voters.Length;

                RecieveVote(Voters[i], NominatorsDefaultOption);

                if (Voters.Length < TempVoterCount)
                {
                    continue;
                }
            }

            ++i;
        }
    }

    for (i = 0; i < Voters.Length; ++i)
    {
        PC = DHPlayer(Voters[i]);

        if (PC != none)
        {
            PC.ClientReceiveVotePrompt(Class, VoteId);
        }
    }

    GotoState('Open');
}

function RecieveVote(PlayerController Voter, int OptionIndex)
{
    local int VoterIndex;

    if (Voter == none || OptionIndex < 0 || OptionIndex >= Options.Length)
    {
        return;
    }

    VoterIndex = class'UArray'.static.IndexOf(Voters, Voter);

    if (VoterIndex == -1)
    {
        Warn("Recieved vote from ineligible voter.");
        return;
    }

    Voters.Remove(VoterIndex, 1);

    Options[OptionIndex].Voters[Options[OptionIndex].Voters.Length] = Voter;

    OnVoteReceieved(Voter, OptionIndex);

    if (Voters.Length == 0)
    {
        // All eligible voters have voted, end the voting!
        Destroy();
    }
}

function OnVoteReceieved(PlayerController Voter, int OptionIndex)
{
    // "Your vote has been receieved."
    Voter.ReceiveLocalizedMessage(class'DHVoteMessage', 0);
}

state Open
{
    event BeginState()
    {
        SetTimer(DurationSeconds, false);
    }

    function Timer()
    {
        Destroy();
    }
}

function int GetTotalVotes()
{
    local int i, TotalVotes;

    for (i = 0; i < Options.Length; ++i)
    {
        TotalVotes += Options[i].Voters.Length;
    }

    return TotalVotes;
}

function array<Option> GetOptions()
{
    return default.Options;
}

static function bool CanNominate(PlayerController Player, DarkestHourGame Game)
{
    return true;
}

function SendMetricsEvent(string VoteType, int Result)
{
    local DarkestHourGame G;
    local DHGameReplicationInfo GRI;
    local array<string> VoterIDs;
    local array<string> NominatorIDs;
    local JSONArray Votes, TeamStats;
    local JSONObject RoundState;
    local int i, j, TeamSizes[2], ObjectiveCount[2];
    local byte ObjTeamIndex;

    G = DarkestHourGame(Level.Game);
    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (G == none || GRI == none || StartedAt == none || EndedAt == none)
    {
        return;
    }

    GRI.GetTeamSizes(TeamSizes);

    if (arraycount(TeamSizes) > arraycount(GRI.SpawnsRemaining) ||
        arraycount(TeamSizes) > arraycount(GRI.TeamMunitionPercentages) ||
        arraycount(TeamSizes) > arraycount(ObjectiveCount))
    {
        Warn("Trying to access an invalid array index");
        return;
    }

    // Get voter IDs
    Votes = class'JSONArray'.static.Create();

    for (i = 0; i < Options.Length; ++i)
    {
        VoterIDs.Length = 0;

        for (j = 0; j < Options[i].Voters.Length; ++j)
        {
            if (Options[i].Voters[j] != none)
            {
                VoterIDs[VoterIDs.Length] = Options[i].Voters[j].GetPlayerIDHash();
            }
        }

        Votes.Add((new class'JSONObject')
                      .PutInteger("option_id", i)
                      .Put("voter_ids", class'JSONArray'.static.FromStrings(VoterIDs)));
    }

    // Get nominator IDs
    for (i = 0; i < Nominators.Length; ++i)
    {
        if (Nominators[i] != none)
        {
            NominatorIDs[NominatorIDs.Length] = Nominators[i].GetPlayerIDHash();
        }
    }

    // Get the amount of objectives each team controls
    for (i = 0; i < arraycount(GRI.DHObjectives); ++i)
    {
        if (GRI.DHObjectives[i] == none)
        {
            continue;
        }

        ObjTeamIndex = GRI.DHObjectives[i].GetTeamIndex();

        if (TeamIndex < arraycount(ObjectiveCount))
        {
            ++ObjectiveCount[ObjTeamIndex];
        }
    }

    // Get the current round situation
    // TODO: Make this a generic object that can be attached to other events.
    TeamStats = class'JSONArray'.static.Create();

    for (i = 0; i < arraycount(TeamSizes); ++i)
    {
        TeamStats.Add((new class'JSONObject')
                  .PutInteger("team_index", i)
                  .PutInteger("size", TeamSizes[i])
                  .PutInteger("reinforcements", GRI.SpawnsRemaining[i])
                  .PutFloat("munitions", GRI.TeamMunitionPercentages[i])
                  .PutInteger("objectives_owned", ObjectiveCount[i]));
    }

    RoundState = (new class'JSONObject')
                     .PutInteger("round_time", GRI.ElapsedTime)
                     .Put("teams", TeamStats);

    // Send away
    G.Metrics.AddEvent("vote", (new class'JSONObject')
                                   .PutString("vote_type", VoteType)
                                   .PutString("started_at", StartedAt.IsoFormat())
                                   .PutString("ended_at", EndedAt.IsoFormat())
                                   .PutInteger("team_index", TeamIndex)
                                   .PutInteger("result_id", Result)
                                   .Put("votes", Votes)
                                   .Put("nominator_ids", class'JSONArray'.static.FromStrings(NominatorIDs))
                                   .Put("round_state", RoundState));
}

// The number of players that cast a vote.
function int GetVoterCount()
{
    return VoterCount;
}

function int GetVotesThresholdCount(DarkestHourGame Game)
{
    if (Game == none)
    {
        return -1;
    }

    if (StartedAt != none)
    {
        return Ceil(GetVoterCount() * GetVotesThresholdPercent());
    }
    else
    {
        Warn("Vote hasn't started yet; voter count is invalid.");
        return -1;
    }
}

static function int GetNominationsThresholdCount(DarkestHourGame Game, byte TeamIndex)
{
    local int TeamSizes[2];

    if (Game == none)
    {
        return -1;
    }

    if (default.bIsGlobalVote)
    {
        return Ceil(GetNominationsThresholdPercent() * Game.GetNumPlayers());
    }

    if (TeamIndex < arraycount(TeamSizes))
    {
        Game.GetTeamSizes(TeamSizes);
        return Ceil(GetNominationsThresholdPercent() * TeamSizes[TeamIndex]);
    }
    else
    {
        Warn("Invalid team index.");
        return -1;
    }
}

function OnVoteStarted();
function OnVoteEnded();
static function OnNominated(PlayerController Player, LevelInfo Level, optional int NominationsRemaining);
static function OnNominationRemoved(PlayerController Player);
static function int GetCooldownSeconds() { return default.CooldownSeconds; }
static function float GetVotesThresholdPercent() { return default.VotesThresholdPercent; }
static function float GetNominationsThresholdPercent() { return default.NominationsThresholdPercent; }

defaultproperties
{
    VoteId=-1
    DurationSeconds=30
    Options(0)=(Text="Yes")
    Options(1)=(Text="No")

    bIsGlobalVote=true
    TeamIndex=-1

    VotesThresholdPercent=0.5
}
