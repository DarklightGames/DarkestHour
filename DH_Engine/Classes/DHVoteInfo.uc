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

// Gets the list of eligible voters.
function array<PlayerController>    GetEligibleVoters();

function string GetQuestionText()
{
    return default.QuestionText;
}

function PostBeginPlay()
{
    local int i;
    local DHPlayer PC;

    Voters = GetEligibleVoters();

    if (Voters.Length == 0)
    {
        Error("No eligible voters.");
        return;
    }

    Options = GetOptions();

    if (Options.Length == 0)
    {
        Error("No voting options.");
        return;
    }

    for (i = 0; i < Voters.Length; ++i)
    {
        PC = DHPlayer(Voters[i]);

        if (PC != none)
        {
            PC.ClientRecieveVotePrompt(Class);
        }
    }
}

function array<Option> GetOptions();

function RecieveVote(PlayerController Voter, int OptionIndex)
{
    local int VoterIndex;

    if (Voter == none)
    {
        return;
    }

    VoterIndex = class'UArray'.static.IndexOf(Voters, Voter);

    if (VoterIndex == -1)
    {
        Warn("Recieved vote from ineligible voter.");
        return;
    }

    // TODO: ensure that option index is good to go
    Voters.Remove(VoterIndex, 1);

    OnVoteReceieved(Voter, OptionIndex);
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

function OnVoteEnded();

// Vote % needed to win
// bTeamVote or Global?
// Voted true #
// voted false #

defaultproperties
{
    DurationSeconds=30
}
