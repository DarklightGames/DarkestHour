//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// An interaction that prompts the player for a response.
//==============================================================================

class DHVoteInteraction extends DHPromptInteraction;

var int                 VoteId;
var class<DHVoteInfo>   VoteInfoClass;

function Initialize()
{
    local int i, KeyValue;
    local EInputKey Key;

    PromptText = default.VoteInfoClass.default.QuestionText;
    Key = IK_F1;
    KeyValue = int(Key);

    Options.Length = default.VoteInfoClass.default.Options.Length;

    for (i = 0; i < default.VoteInfoClass.default.Options.Length; ++i)
    {
        Options[i].Text = default.VoteInfoClass.default.Options[i].Text;
        Options[i].Key = EInputKey(KeyValue + i);
    }

    super.Initialize();
}

function string GetPromptText()
{
    return default.VoteInfoClass.default.QuestionText;
}

function OnOptionSelected(int Index)
{
    local DHPlayer PC;

    PC = DHPlayer(ViewportOwner.Actor);

    if (PC != none)
    {
        PC.ServerSendVote(VoteId, Index);
    }

    super.OnOptionSelected(Index);
}
