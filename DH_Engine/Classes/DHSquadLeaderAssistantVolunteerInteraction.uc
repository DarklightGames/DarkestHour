//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHSquadLeaderAssistantVolunteerInteraction extends DHPromptInteraction;

var int TeamIndex;
var int SquadIndex;
var DHPlayerReplicationInfo VolunteerPRI;

function Tick(float DeltaTime)
{
    local DHPlayer PC;

    PC = DHPlayer(ViewportOwner.Actor);

    if (PC == none ||
        PC.GameReplicationInfo == none ||
        PC.GetTeamNum() != TeamIndex ||
        PC.GetSquadIndex() != SquadIndex ||
        VolunteerPRI == none ||
        VolunteerPRI.Team == none ||
        VolunteerPRI.Team.TeamIndex != TeamIndex ||
        VolunteerPRI.SquadIndex != SquadIndex ||
        VolunteerPRI.bIsSquadAssistant)
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
                PC.ServerSquadMakeAssistant(VolunteerPRI);
                break;
            case 2:
                PC.bIgnoreSquadLeaderAssistantVolunteerPrompts = true;
                break;
        }
    }

    Master.RemoveInteraction(self);
}

// Override for a more dynamic prompt text (this is called every frame)
function string GetPromptText()
{
    local string S;

    S = PromptText;

    if (VolunteerPRI != none)
    {
        S = Repl(S, "{volunteer}", class'GameInfo'.static.MakeColorCode(class'DHColor'.default.SquadColor) $ VolunteerPRI.PlayerName $ class'GameInfo'.static.MakeColorCode(class'UColor'.default.White));
    }

    return S;
}

defaultproperties
{
    PromptText="{volunteer} has volunteered to be the squad's assistant."
    Options(0)=(Key=IK_F1,Text="Accept")
    Options(1)=(Key=IK_F2,Text="Decline")
    Options(2)=(Key=IK_F3,Text="Ignore All")
    bRequiresTick=true
}

