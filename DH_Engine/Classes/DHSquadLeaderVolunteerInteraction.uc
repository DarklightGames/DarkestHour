//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHSquadLeaderVolunteerInteraction extends DHPromptInteraction;

var int TeamIndex;
var int SquadIndex;
var int ExpirationTime;

function Tick(float DeltaTime)
{
    local DHPlayer PC;

    PC = DHPlayer(ViewportOwner.Actor);

    if (PC == none ||
        PC.GameReplicationInfo == none ||
        PC.GetTeamNum() != TeamIndex ||
        PC.GetSquadIndex() != SquadIndex ||
        PC.GameReplicationInfo.ElapsedTime >= ExpirationTime)
    {
        Master.RemoveInteraction(self);
    }
}

function OnOptionSelected(int Index)
{
    local DHPlayer PC;

    PC = DHPlayer(ViewportOwner.Actor);

    if (PC != none)
    {
        switch (Index)
        {
            case 0:
                PC.ServerSquadLeaderVolunteer(default.TeamIndex, default.SquadIndex);
                break;
            case 2:
                PC.bIgnoreSquadLeaderVolunteerPrompts = true;
                break;
        }
    }

    Master.RemoveInteraction(self);
}

// Override for a more dynamic prompt text (this is called every frame)
function string GetPromptText()
{
    local DHPlayer PC;

    PC = DHPlayer(ViewportOwner.Actor);

    if (PC != none)
    {
        return Repl(PromptText, "{time}", class'TimeSpan'.static.ToString(ExpirationTime - PC.GameReplicationInfo.ElapsedTime));
    }

    return super.GetPromptText();
}

defaultproperties
{
    PromptText="Your squad needs a leader! Volunteer to be squad leader? ({time})"
    Options(0)=(Key=IK_F1,Text="Volunteer")
    Options(1)=(Key=IK_F2,Text="Decline")
    Options(2)=(Key=IK_F3,Text="Ignore All")
    bRequiresTick=true
}

