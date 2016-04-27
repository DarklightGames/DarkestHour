//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHDebugTracer extends RODebugTracer;

var bool bTimerDestroys;

simulated function PostBeginPlay()
{
    if (Level.NetMode == NM_DedicatedServer || Level.NetMode == NM_ListenServer)
    {
        SetTimer(1.0, false); // delay allowing actor to replicate to clients, before tearing off actor
    }

    super.PostBeginPlay();
}

function Timer()
{
    if (!bTimerDestroys)
    {
        bTearOff = true; // replicated actor on clients gets torn off and net channel closed (after short delay)

        if (Level.NetMode == NM_DedicatedServer) // on dedicated server, allow time for bTearOff to replicate & then destroy actor on server
        {
            bTimerDestroys = true;
            SetTimer(1.0, false);
        }
    }
    else
    {
        Destroy();
    }
}

defaultproperties
{
}
