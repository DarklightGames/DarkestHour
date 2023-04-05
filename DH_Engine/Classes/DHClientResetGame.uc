//===================================================================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//===================================================================================================================

class DHClientResetGame extends Actor;

/*
Matt: this actor is a way of getting all net clients to destroy or reset any actors that need it, as Reset() function is normally only called on server
Gets spawned & replicated to clients if the ResetGame option is used, or a round ends & a new one starts on the same map
Finds all client-authoritative actors, i.e. non-replicated actors existing independently on client (e.g. locally spawned effects), & calls Reset() on them
Then client actor's Reset() function can handle whatever is needed, e.g. for smoke effects it destroys itself so smoke clouds don't persist into new round
Note that Reset also gets called on those actors in single player mode, where it will have the same desired result
Also using it to make sure local player's WeaponUnlockTime is reset for new round

TODO: think this actor can be replaced by using ClientReset(), which gets called on PlayerControllers whenever a round starts, including if ResetGame is used
That function is already doing a foreach AllActors iteration to call Reset() on specified client actors
Instead of certain specified class literals, I believe it can be used to simply call Reset() on all actors on the client
They will only do anything if they have a Reset() function & it is simulated, which should only be the actors we want to reset/destroy
ClientReset() would also be ideal for making sure the local player's WeaponUnlockTime is reset, as they are both in DHPlayer
A change required would be in DHGame's state RoundInPlay BeginState() function, as it currently doesn't call ClientReset() on any spectating players
*/

simulated function PostBeginPlay()
{
    local DHPlayer PC;
    local Actor    A;

    if (Role < ROLE_Authority)
    {
        // Find all non-replicated actors existing independently on client & call Reset() on them
        foreach AllActors(class'Actor', A)
        {
            if (A.Role == ROLE_Authority)
            {
                A.Reset();
            }
        }

        // Make sure local player's WeaponUnlockTime is reset
        PC = DHPlayer(Level.GetLocalPlayerController());

        if (PC != none)
        {
            PC.WeaponUnlockTime = PC.default.WeaponUnlockTime;
        }
    }

    // Destroy a clientside actor as it's done it's job (& this actor has no business existing on a standalone)
    if (Role < ROLE_Authority || Level.NetMode == NM_Standalone)
    {
        Destroy();
    }

    super.PostBeginPlay();
}

defaultproperties
{
    bAlwaysRelevant=true
    bNetTemporary=true // client actor gets torn off as soon as it replicates, as all it needs to do is reach the client to do its stuff
    LifeSpan=5.0       // means server version of this actor will be auto-destroyed after a few seconds, giving it time to replicate to clients
    bSkipActorPropertyReplication=true
    bHidden=true
}
