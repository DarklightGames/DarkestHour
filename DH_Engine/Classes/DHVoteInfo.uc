//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHVoteInfo extends Info
    abstract;

struct Option
{
    var localized string Text;
    var array<PlayerController> Voters;
};

var int                             VoteId;

var class<DHPromptInteraction>      VoteInteractionClass;

var localized string                QuestionText;
var float                           DurationSeconds;

var array<Option>                   Options;
var array<PlayerController>         Voters;
var array<PlayerController>         Nominators;
var int                             VoterCount;

var int                             CooldownSeconds;
var int                             TeamIndex;
var int                             TeamSizeMin;
var int                             NominationCountThreshold;
var int                             NominatorsDefaultOption;

var bool                            bNominatorsVoteAutomatically;
var bool                            bIsGlobal; // ignore voter's team index

var DateTime                        StartedAt;
var DateTime                        FinishedAt;

// Gets the list of eligible voters.
function array<PlayerController>    GetEligibleVoters();

function string GetQuestionText()
{
    return default.QuestionText;
}

function StartVote()
{
    local int i, VoterIndex;
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

    for (i = 0; i < Voters.Length; ++i)
    {
        // Accept the nominations as valid votes
        if (bNominatorsVoteAutomatically && Voters[i] != none)
        {
            VoterIndex = class'UArray'.static.IndexOf(Nominators, Voters[i]);

            if (VoterIndex >= 0)
            {
                RecieveVote(Voters[i], NominatorsDefaultOption);
            }
        }

        PC = DHPlayer(Voters[i]);

        if (PC != none)
        {
            PC.ClientRecieveVotePrompt(Class, VoteId);
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

    Options[OptionIndex].Voters[Voters.Length] = Voter;

    OnVoteReceieved(Voter, OptionIndex);

    if (Voters.Length == 0)
    {
        // All eligible voters have voted, end the voting!
        OnVoteEnded();
        Destroy();
    }
}

function OnVoteReceieved(PlayerController Voter, int OptionIndex)
{
    // "Your vote has been receieved."
    Voter.ReceiveLocalizedMessage(class'DHVoteMessage', 0,,, class'UInteger'.static.Create(OptionIndex));
}

state Open
{
    event BeginState()
    {
        StartedAt = class'DateTime'.static.Now(self);
        SetTimer(DurationSeconds, false);
    }

    function Timer()
    {
        FinishedAt = class'DateTime'.static.Now(self);
        OnVoteEnded();
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
    local array<string> VoterIDs;
    local array<string> NominatorIDs;
    local JSONArray Votes;
    local int i, j;

    G = DarkestHourGame(Level.Game);

    if (G == none || StartedAt == none || FinishedAt == none)
    {
        return;
    }

    // Get voter IDs
    Votes = new class'JSONArray';

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

    G.Metrics.AddEvent("vote", (new class'JSONObject')
                                   .PutString("vote_type", VoteType)
                                   .PutString("started_at", StartedAt.IsoFormat())
                                   .PutString("finished_at", FinishedAt.IsoFormat())
                                   .PutInteger("team_index", TeamIndex)
                                   .PutInteger("result_id", Result)
                                   .Put("votes", Votes)
                                   .Put("nominator_ids", class'JSONArray'.static.FromStrings(NominatorIDs)));
}

function OnVoteEnded();
static function OnNominated(PlayerController Player);
static function OnNominationRemoved(PlayerController Player);

defaultproperties
{
    VoteId=-1
    DurationSeconds=30
    Options(0)=(Text="Yes")
    Options(1)=(Text="No")

    bIsGlobal=true
    TeamIndex=-1
}
