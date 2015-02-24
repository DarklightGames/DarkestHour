//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_GiveChuteTrigger extends Trigger;

function Touch(Actor Other)
{
    local int i;

    if (IsRelevant(Other))
    {
        if (ReTriggerDelay > 0.0)
        {
            if (Level.TimeSeconds - TriggerTime < ReTriggerDelay)
            {
                return;
            }

            TriggerTime = Level.TimeSeconds;
        }

        Other = FindInstigator(Other);

        // Broadcast the Trigger message to all matching actors
        TriggerEvent(Event, self, Other.Instigator);

        if (Pawn(Other) != none && Pawn(Other).Controller != none)
        {
            for (i = 0; i < 4; i++)
            {
                if (Pawn(Other).Controller.GoalList[i] == self)
                {
                    Pawn(Other).Controller.GoalList[i] = none;
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

        if (DH_Pawn(Other.Instigator) != none)
        {
            DH_Pawn(Other.Instigator).GiveChute();
        }
    }
}

defaultproperties
{
    ReTriggerDelay=0.5 // Matt: added to prevent spamming calls to pawn's GiveChute, each of which checks through inventory
}
