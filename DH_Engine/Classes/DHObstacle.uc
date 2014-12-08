//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHObstacle extends Actor;

var     int             Index;

var     StaticMesh      IntactStaticMesh;
var()   StaticMesh      ClearedStaticMesh;
var()   sound           ClearSound;
var()   float           SpawnClearedChance;
var()   bool            bCanBeClearedWithWireCutters;
var()   class<Emitter>  ClearEmitter;

replication
{
    reliable if ((bNetDirty || bNetInitial) && Role == ROLE_Authority)
        Index, IntactStaticMesh, ClearedStaticMesh;
}

simulated function bool IsCleared()
{
    return IsInState('Cleared');
}

function PostBeginPlay()
{
    super.PostBeginPlay();

    IntactStaticMesh = StaticMesh;
}

simulated function PostNetBeginPlay()
{
    local DHObstacleManager OM;

    if (Role != ROLE_Authority)
    {
        foreach AllActors(class'DHObstacleManager', OM)
        {
            OM.Obstacles[Index] = self;
        }
    }
}

simulated state Intact
{
    simulated function BeginState()
    {
        Log("Obstacle" @ Index @ "Intact");

        SetStaticMesh(IntactStaticMesh);
        KSetBlockKarma(false);
    }

    event Touch(Actor Other)
    {
        local DarkestHourGame G;

        if (Role == ROLE_Authority)
        {
            if (SVehicle(Other) != none)
            {
                G = DarkestHourGame(Level.Game);

                if (G != none && G.ObstacleManager != none)
                {
                    //TODO: destruction requires a certain speed?
                    G.ObstacleManager.SetCleared(self, true);
                }
            }
        }

        super.Touch(Other);
    }
}

simulated state Cleared
{
    simulated function BeginState()
    {
        Log("Obstacle" @ Index @ "Cleared");

        if (Level.NetMode != NM_DedicatedServer)
        {
            //TODO: this is super quiet for some reason
            if (ClearSound != none)
            {
                PlayOwnedSound(ClearSound, SLOT_None);
            }

            if (ClearEmitter != none)
            {
                Spawn(ClearEmitter, none, '', Location, Rotation);
            }
        }

        SetStaticMesh(ClearedStaticMesh);
        KSetBlockKarma(false);
    }
}

simulated function SetCleared(bool bIsCleared)
{
    if (bIsCleared)
    {
        GotoState('Cleared');
    }
    else
    {
        GotoState('Intact');
    }
}

defaultproperties
{
    bBlockPlayers=true
    bBlockActors=true
    bBlockKarma=true
    bBlockProjectiles=true
    bBlockHitPointTraces=true
    bBlockNonZeroExtentTraces=true
    bCanBeDamaged=true
    bCollideActors=true
    bCollideWorld=false
    bWorldGeometry=false
    bStatic=false
    bStaticLighting=true
    DrawType=DT_StaticMesh
    bNetTemporary=true
    bAlwaysRelevant=true
    RemoteRole=ROLE_None

    SpawnClearedChance=0.0
    bCanBeClearedWithWireCutters=true
}

