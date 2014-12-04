//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHObstacle extends Actor;

var     int         Index;

var     StaticMesh  IntactStaticMesh;
var()   StaticMesh  ClearedStaticMesh;
var()   Sound       ClearSound;
var()   float       SpawnClearedChance;

simulated function bool IsCleared()
{
    return IsInState('Cleared');
}

function PostBeginPlay()
{
    super.PostBeginPlay();

    IntactStaticMesh = StaticMesh;

    if (Level.NetMode == NM_Client)
    {
        bTearOff = true;
    }
}

event Touch(Actor Other)
{
    local SVehicle V;

    if (Level.NetMode != NM_Client)
    {
        V = SVehicle(Other);

        //TODO: destruction requires a certain speed?
        if (V != none)
        {
            SetCleared(true);
        }
    }
}

state Intact
{
    function BeginState()
    {
        local DHObstacleManager OM;

        SetStaticMesh(IntactStaticMesh);
        KSetBlockKarma(false);

        if (Role == ROLE_Authority)
        {
            OM = DarkestHourGame(Level.Game).ObstacleManager;

            if (OM != none)
            {
                OM.SetCleared(self, false);
            }
        }
    }
}

state Cleared
{
    function BeginState()
    {
        local DHObstacleManager OM;

        if (Level.NetMode != NM_DedicatedServer)
        {
            Log(ClearSound);

            PlayOwnedSound(ClearSound, SLOT_None);
        }

        SetStaticMesh(ClearedStaticMesh);
        KSetBlockKarma(true);

        if (Role == ROLE_Authority)
        {
            OM = DarkestHourGame(Level.Game).ObstacleManager;

            if (OM != none)
            {
                OM.SetCleared(self, true);
            }
        }
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
    bCanBeDamaged=true
    bCollideActors=true
    bCollideWorld=false
    bWorldGeometry=false
    bStatic=false
    bStaticLighting=true
    DrawType=DT_StaticMesh
    SpawnClearedChance=0.0
}

