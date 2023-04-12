//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHSquadPromotionRequestInteraction extends DHPromptInteraction;

var int SquadPromotionRequestID;
var string SenderPlayerName;
var string SenderSquadName;

function Initialized()
{
    super.Initialized();

    PromptText = Repl(PromptText, "{0}", default.SenderPlayerName);
    PromptText = Repl(PromptText, "{1}", class'GameInfo'.static.MakeColorCode(class'DHColor'.default.SquadColor) $
                                         default.SenderSquadName $
                                         class'GameInfo'.static.MakeColorCode(class'UColor'.default.White));
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
                PC.ServerAcceptSquadPromotionRequest(default.SquadPromotionRequestID);
                break;
            case 1: // Decline
                PC.ServerDenySquadPromotionRequest(default.SquadPromotionRequestID);
                break;
            case 2: // Ignore All
                PC.ServerDenySquadPromotionRequest(default.SquadPromotionRequestID);
                PC.bIgnoreSquadPromotionRequestPrompts = true;
                break;
        }
    }

    Master.RemoveInteraction(self);
}

defaultproperties
{
    PromptText="{0} wants to promote you to leader of {1} squad."
    Options(0)=(Key=IK_F5,Text="Accept")
    Options(1)=(Key=IK_F2,Text="Decline")
    Options(2)=(Key=IK_F3,Text="Ignore All")
}
