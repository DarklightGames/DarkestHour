//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHTeamKillInteraction extends DHPromptInteraction;

var string LastFFKillerName;

function Initialized()
{
    super.Initialized();

    PromptText = Repl(PromptText, "{0}", default.LastFFKillerName);
}

function OnOptionSelected(int Index)
{
    local DHPlayer PC;

    PC = DHPlayer(ViewportOwner.Actor);

    if (PC != none)
    {
        switch (Index)
        {
            case 0: // Forgive TK
                PC.ServerForgiveLastFFKiller();
                break;
            case 1: // Do Nothing
                break;
        }
    }

    Master.RemoveInteraction(self);
}

defaultproperties
{
    PromptText="{0} has team-killed you!"
    Options(0)=(Key=IK_F1,Text="Forgive")
    Options(1)=(Key=IK_F2,Text="Don't Forgive")
}
