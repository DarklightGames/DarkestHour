//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHSquadLeaderAssistantVolunteerInteraction extends DHPromptInteraction;

var int TeamIndex;
var int SquadIndex;
var int VolunteerIndex;

function Tick(float DeltaTime)
{
    local DHPlayer PC;
    local DHPlayerReplicationInfo VolunteerPRI;

    if (ViewportOwner != none)
    {
        PC = DHPlayer(ViewportOwner.Actor);

        if (PC != none)
        {
            VolunteerPRI = PC.GetSquadAssistantVolunteer(VolunteerIndex);

            if (Class'DHPlayerReplicationInfo'.static.IsInSameSquad(DHPlayerReplicationInfo(PC.PlayerReplicationInfo), VolunteerPRI) &&
                !VolunteerPRI.bIsSquadAssistant)
            {
                return;
            }
        }
    }

    Master.RemoveInteraction(self);
}

function OnOptionSelected(int Index)
{
    local DHPlayer PC;

    if (ViewportOwner != none)
    {
        PC = DHPlayer(ViewportOwner.Actor);

        if (PC != none)
        {
            switch (Index)
            {
                case 0:
                    PC.ServerSquadMakeAssistant(PC.GetSquadAssistantVolunteer(VolunteerIndex));
                    break;
                case 2:
                    PC.bIgnoreSquadLeaderAssistantVolunteerPrompts = true;
                    break;
            }
        }
    }

    Master.RemoveInteraction(self);
}

// Override for a more dynamic prompt text (this is called every frame)
function string GetPromptText()
{
    local string S;
    local DHPlayer PC;
    local DHPlayerReplicationInfo VolunteerPRI;

    S = PromptText;

    if (ViewportOwner != none)
    {
        PC = DHPlayer(ViewportOwner.Actor);

        if (PC != none)
        {
            VolunteerPRI = PC.GetSquadAssistantVolunteer(VolunteerIndex);
        }
    }

    if (VolunteerPRI != none)
    {
        S = Repl(S, "{volunteer}", Class'GameInfo'.static.MakeColorCode(Class'DHColor'.default.SquadColor) $ VolunteerPRI.PlayerName $ Class'GameInfo'.static.MakeColorCode(Class'UColor'.default.White));
    }

    return S;
}

function RemoveInteraction()
{
    local DHPlayer PC;

    if (ViewportOwner != none)
    {
        PC = DHPlayer(ViewportOwner.Actor);

        if (PC != none)
        {
            PC.RemoveSquadAssistantVolunteer(VolunteerIndex);
        }
    }

    Master.RemoveInteraction(self);
}

defaultproperties
{
    PromptText="{volunteer} has volunteered to be the squad's assistant."
    Options(0)=(Key=IK_F1,Text="Accept")
    Options(1)=(Key=IK_F2,Text="Decline")
    Options(2)=(Key=IK_F3,Text="Ignore All")
    bRequiresTick=true
    VolunteerIndex=-1
}
