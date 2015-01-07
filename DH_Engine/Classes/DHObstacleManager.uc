//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHObstacleManager extends Actor;

var array<DHObstacle>   Obstacles;
var byte                Bitfield[128];
var byte                SavedBitfield[128];
var DHObstacleInfo      Info;

var config bool bDebug;

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        Bitfield;
}

simulated function PostBeginPlay()
{
    local DHObstacle Obstacle;
    local int i;

    super.PostBeginPlay();

    Log("DHObstacleManager::PostBeginPlay");

    foreach AllActors(class'DHObstacleInfo', Info)
    {
        break;
    }

    if (Info == none)
    {
        Error("DHObstacleInfo could not be found!");

        return;
    }

    if (Role == ROLE_Authority)
    {
        foreach AllActors(class'DHObstacle', Obstacle)
        {
            Obstacle.Index = Obstacles.Length;

            for (i = 0; i < Info.Types.Length; ++i)
            {
                if (Obstacle.StaticMesh != Info.Types[i].IntactStaticMesh)
                {
                    continue;
                }

                Obstacle.TypeIndex = i;
                Obstacle.IntactStaticMesh = Obstacle.StaticMesh;

                if (Info.Types[i].ClearedStaticMeshes.Length > 0)
                {
                    Obstacle.ClearedStaticMesh = Info.Types[i].ClearedStaticMeshes[Obstacle.Index % Info.Types[i].ClearedStaticMeshes.Length];
                }

                //TODO: these are probably only relevant on the client
                Obstacle.ClearSound = Info.Types[i].ClearSound;

                if (Info.Types[i].ClearEmitterClasses.Length > 0)
                {
                    Obstacle.ClearEmitterClass = Info.Types[i].ClearEmitterClasses[Obstacle.Index % Info.Types[i].ClearEmitterClasses.Length];
                }

                break;
            }

            if (Obstacle.TypeIndex == 255)
            {
                Log("Obstacle with static mesh" @ Obstacle.StaticMesh @ "was unable to be matched to obstacle info!");

                continue;
            }

            Obstacles[Obstacles.Length] = Obstacle;

            Obstacle.RemoteRole = ROLE_SimulatedProxy;
        }
    }
}

function DebugObstacles(optional int Option)
{
    local int i;

    if (!bDebug)
    {
        return;
    }

    switch (Option)
    {
        case 0: // Make all obstacles intact
            for (i = 0; i < Obstacles.Length; ++i)
            {
                SetCleared(Obstacles[i], false);
            }
            break;
        case 1: // Clear all obstacles
            for (i = 0; i < Obstacles.Length; ++i)
            {
                SetCleared(Obstacles[i], true);
            }
            break;
        case 2: // Randomly make all obstacles intact or cleared (50/50 chance)
            for (i = 0; i < Obstacles.Length; ++i)
            {
                SetCleared(Obstacles[i], FRand() >= 0.5);
            }
            break;
        case 4: // Reset obstacles as though a new round has started
            Reset();
            break;
        case 3: // Print out the amount number of obstacles
            Level.Game.Broadcast(self, "Obstacle Count:" @ Obstacles.Length);
            break;
    }

    Level.Game.Broadcast(self, "DebugObstacles" @ Option);
}

function ClearObstacle(int Index)
{
    if (Index < 0 || Index >= Obstacles.Length)
    {
        return;
    }

    SetCleared(Obstacles[Index], true);
}

simulated function bool IsClearedInBitfield(int Index)
{
    local int ByteIndex;
    local byte Mask;

    GetBitfieldIndexAndMask(Index, ByteIndex, Mask);

    return (Bitfield[ByteIndex] & Mask) == Mask;
}

simulated function GetBitfieldIndexAndMask(int Index, out int ByteIndex, out byte Mask)
{
    ByteIndex = Index / 8;
    Mask = (1 << (Index % 8));
}

simulated event PostNetReceive()
{
    local int i, j, ObstacleIndex;
    local bool bDidStateChange;
    local bool bIsCleared;
    local bool bWasCleared;
    local byte Mask;

    super.PostNetReceive();

    if (Role < ROLE_Authority)
    {
        //compare current bitfield to previous bitfield
        for (i = 0; i < arraycount(Bitfield); ++i)
        {
            if (Bitfield[i] == SavedBitfield[i])
            {
                //no change
                continue;
            }

            //byte has changed, drill down and find what bit(s) changed
            for (j = 0; j < 8; ++j)
            {
                Mask = (1 << j);

                bIsCleared = (Bitfield[i] & Mask) == Mask;
                bWasCleared = (SavedBitfield[i] & Mask) == Mask;
                bDidStateChange = bIsCleared != bWasCleared;

                if (bDidStateChange)
                {
                    ObstacleIndex = (i * 8) + j;

                    if (ObstacleIndex >= Obstacles.Length)
                    {
                        break;
                    }

                    Obstacles[ObstacleIndex].SetCleared(bIsCleared);
                }
            }

            SavedBitfield[i] = Bitfield[i];
        }
    }
}

simulated function Reset()
{
    local int i;
    local DHObstacle Obstacle;

    super.Reset();

    if (bDebug)
    {
        Level.Game.Broadcast(self, "DHObstacleManager::Reset");
    }

    if (Role == ROLE_Authority)
    {
        for (i = 0; i < Obstacles.Length; ++i)
        {
            Obstacle = Obstacles[i];

            SetCleared(Obstacle, false);

            if (FRand() < Obstacle.SpawnClearedChance)
            {
                SetCleared(Obstacle, true);
            }
        }
    }
}

function SetCleared(DHObstacle Obstacle, bool bIsCleared)
{
    local int ByteIndex;
    local byte Mask;

    Obstacle.SetCleared(bIsCleared);

    if (Level.NetMode != NM_Client)
    {
        GetBitfieldIndexAndMask(Obstacle.Index, ByteIndex, Mask);

        if (bIsCleared)
        {
            Bitfield[ByteIndex] = (Bitfield[ByteIndex] | Mask);
        }
        else
        {
            Bitfield[ByteIndex] = (Bitfield[ByteIndex] & ~Mask);
        }
    }
}

defaultproperties
{
    bDebug=true
    bHidden=true
    bAlwaysRelevant=true
    RemoteRole=ROLE_SimulatedProxy
    bOnlyDirtyReplication=true
    bSkipActorPropertyReplication=true
    bNetNotify=true
}
