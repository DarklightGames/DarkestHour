//=============================================================================
// DH_GiveChuteTrigger
// Automatically gives players parachutes
// To be attached to aircraft spawn areas
//=============================================================================

class DH_GiveChuteTrigger extends Trigger;

function Touch(actor Other)
{
    local int i;
    local Pawn EventInstigator;

    if (IsRelevant(Other))
    {
        Other = FindInstigator(Other);

        if (ReTriggerDelay > 0)
        {
            if (Level.TimeSeconds - TriggerTime < ReTriggerDelay)
                return;
            TriggerTime = Level.TimeSeconds;
        }
        // Broadcast the Trigger message to all matching actors.
        TriggerEvent(Event, self, Other.Instigator);

        if ((Pawn(Other) != none) && (Pawn(Other).Controller != none))
        {
            for (i=0;i<4;i++)
                if (Pawn(Other).Controller.GoalList[i] == self)
                {
                    Pawn(Other).Controller.GoalList[i] = none;
                    break;
                }
        }

        if ((Message != "") && (Other.Instigator != none))
            // Send a string message to the toucher.
            Other.Instigator.ClientMessage(Message);

        if (bTriggerOnceOnly)
            // Ignore future touches.
            SetCollision(false);
        else if (RepeatTriggerTime > 0)
            SetTimer(RepeatTriggerTime, false);

        EventInstigator = Other.Instigator;

        //DHPlayer(EventInstigator.Controller).ClientMessage("Trigger activated");
        DH_Pawn(EventInstigator).GiveChute();
    }
}

defaultproperties
{
}
