//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHTeamSurrenderInteraction extends DHPromptInteraction;

function OnOptionSelected(int Index)
{
    local DHPlayer PC;

    PC = DHPlayer(ViewportOwner.Actor);

    if (PC != none)
    {
        switch (Index)
        {
            case 0:
                PC.ServerVote(true, self);
                break;
            case 2:
                PC.ServerVote(false, self);
                break;
        }
    }

    Master.RemoveInteraction(self);
}

defaultproperties
{
    PromptText="Do you want the team to surrender?"
    Options(0)=(Key=IK_F1,Text="Yes")
    Options(1)=(Key=IK_F2,Text="No")
}

