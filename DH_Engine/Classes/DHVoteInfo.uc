//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHVoteInfo extends Info
    abstract;

struct Option
{
    var localized string Text;
    var int Votes;
};

var int                             VoteId;

var class<DHPromptInteraction>      VoteInteractionClass;

var localized string                QuestionText;
var float                           DurationSeconds;

var array<Option>                   Options;
var array<PlayerController>         Voters;
var int                             VoterCount;

// Gets the list of eligible voters.
function array<PlayerController>    GetEligibleVoters();

function string GetQuestionText()
{
    return default.QuestionText;
}

function StartVote()
{
    local int i;
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

    Options[OptionIndex].Votes += 1;

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
        SetTimer(DurationSeconds, false);
    }

    function Timer()
    {
        OnVoteEnded();
        Destroy();
    }
}

function int GetTotalVotes()
{
    local int i, TotalVotes;

    for (i = 0; i < Options.Length; ++i)
    {
        TotalVotes += Options[i].Votes;
    }

    return TotalVotes;
}

function array<Option> GetOptions()
{
    return default.Options;
}

function OnVoteEnded();

defaultproperties
{
    VoteId=-1
    DurationSeconds=30
    Options(0)=(Text="Yes")
    Options(1)=(Text="No")
}
