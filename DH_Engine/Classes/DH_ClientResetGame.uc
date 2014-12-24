//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ClientResetGame extends Actor; // Matt: spawned by server if ResetGame option is used - replicates to net clients to remove any temporary client-only actors, e.g. smoke effects


simulated function PostBeginPlay()
{
    local Actor A;

    if (Role < ROLE_Authority)
    {
        foreach AllActors(class'Actor', A)
        {
            if (A.Role == ROLE_Authority && A.LifeSpan != 0.0)
            {
                Log("DH_ClientResetGame.PostBeginPlay: destroying" @ A.Tag @ " LifeSpan =" @ A.LifeSpan); // Matt: TEMP - delete before release
                A.Destroy();
            }
        }
    }

    if (Role < ROLE_Authority || Level.NetMode == NM_Standalone) 
    {
        Destroy(); // the client version of this actor has done it's job (& this actor has no business existing on a standalone)
    }

    super.PostBeginPlay();
}

defaultproperties
{
    bAlwaysRelevant=true
    bSkipActorPropertyReplication=true
    LifeSpan = 5.0 // means server version of this actor will be auto-destroyed after a few seconds, once it has had time to replicate to clients
}
