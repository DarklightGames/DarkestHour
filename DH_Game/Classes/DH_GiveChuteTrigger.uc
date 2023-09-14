//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_GiveChuteTrigger extends Trigger;

// Modified to give a touching player a parachute & static line
function Touch(Actor Other)
{
    local Pawn P;
    local int  i;

    // Do nothing unless a little time has passed since last trigger, to avoid spamming
    if (ReTriggerDelay > 0.0 && (Level.TimeSeconds - TriggerTime) < ReTriggerDelay)
    {
        return;
    }

    if (IsRelevant(Other))
    {
        if (ReTriggerDelay > 0.0)
        {
            TriggerTime = Level.TimeSeconds;
        }

        Other = FindInstigator(Other);

        // Broadcast the Trigger message to all matching actors
        TriggerEvent(Event, self, Other.Instigator);

        P = Pawn(Other);

        if (P != none && P.Controller != none)
        {
            for (i = 0; i < 4; ++i)
            {
                if (P.Controller.GoalList[i] == self)
                {
                    P.Controller.GoalList[i] = none;
                    break;
                }
            }
        }

        // Send a string message to the toucher
        if (Message != "" && Other.Instigator != none)
        {
            Other.Instigator.ClientMessage(Message);
        }

        if (bTriggerOnceOnly)
        {
            SetCollision(false); // ignore future touches
        }
        else if (RepeatTriggerTime > 0.0)
        {
            SetTimer(RepeatTriggerTime, false);
        }

        // Give the player a parachute & static line
        if (DHPawn(Other.Instigator) != none)
        {
            DHPawn(Other.Instigator).GiveChute();
        }
    }
}

defaultproperties
{
    ReTriggerDelay=0.5 // added to prevent spamming calls to pawn's GiveChute, each of which checks through inventory
}
