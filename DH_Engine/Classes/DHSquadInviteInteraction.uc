//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHSquadInviteInteraction extends DHPromptInteraction;

var string SenderName;
var string SquadName;
var int TeamIndex;
var int SquadIndex;

function Initialized()
{
    super.Initialized();

    PromptText = Repl(PromptText, "{0}", class'GameInfo'.static.MakeColorCode(class'DHColor'.default.SquadColor) $ default.SenderName $ class'GameInfo'.static.MakeColorCode(class'UColor'.default.White));
    PromptText = Repl(PromptText, "{1}", class'GameInfo'.static.MakeColorCode(class'DHColor'.default.SquadColor) $ default.SquadName $ class'GameInfo'.static.MakeColorCode(class'UColor'.default.White));
}

function OnOptionSelected(int Index)
{
    local DHPlayer PC;

    PC = DHPlayer(ViewportOwner.Actor);

    if (PC != none)
    {
        switch (Index)
        {
            case 0: // Accept
                PC.ServerSquadJoin(default.TeamIndex, default.SquadIndex, true);
                break;
            case 1: // Decline
                break;
            case 2: // Ignore All
                PC.bIgnoreSquadInvitations = true;
                break;
        }
    }

    Master.RemoveInteraction(self);
}

defaultproperties
{
    PromptText="{0} has invited you to join {1} squad."
    Options(0)=(Key=IK_F1,Text="Accept")
    Options(1)=(Key=IK_F2,Text="Decline")
    Options(2)=(Key=IK_F3,Text="Ignore All")
}
