//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHChatHandler extends UnrealChatHandler;

// Modified to prevent any possibility of this actor being registered as the next in the BroadcastHandler chain, which would create a feedback loop
// Similarly we also stop this function being passed on to the NextBroadcastHandler if that is the same actor that we are supposed to be registering
function RegisterBroadcastHandler(BroadcastHandler NewBH)
{
    if (NextBroadcastHandler == none)
    {
        if (NewBH != self)
        {
            NextBroadcastHandler = NewBH;
            default.NextBroadcastHandlerClass = NewBH.Class;
        }
        else
        {
            Warn(Tag @ "RegisterBroadcastHandler: TRIED TO REGISTER SELF as NextBroadcastHandler !!!");
        }
    }
    else
    {
        if (NextBroadcastHandler == NewBH)
        {
            Warn(Tag @ "RegisterBroadcastHandler: TRIED TO REGISTER" @ NewBH.Tag @ "as NextBroadcastHandler, when it's already recorded as NextBroadcastHandler !!!");
        }

        NextBroadcastHandler.RegisterBroadcastHandler(NewBH);
    }
}
