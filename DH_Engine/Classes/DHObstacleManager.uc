//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHObstacleManager extends Actor
    notplaceable;

const MAX_OBSTACLES = 1024;
const BITFIELD_LENGTH = 128;
const OBSTACLE_TYPE_INDEX_INVALID = 255;

var byte            Bitfield[BITFIELD_LENGTH];

var byte            SavedBitfield[BITFIELD_LENGTH];
var DHObstacleInfo  Info;
var bool            bPlayEffects;

var config bool     bDebug;

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
            if (Info.Obstacles.Length >= MAX_OBSTACLES)
            {
                Warn(Obstacle @ " discarded, exceeds limit of manageable DHObstacle actors");

                Obstacle.Destroy();

                continue;
            }

            Obstacle.Index = Info.Obstacles.Length;

            for (i = 0; i < Info.Types.Length; ++i)
            {
                if (Obstacle.StaticMesh != Info.Types[i].IntactStaticMesh)
                {
                    continue;
                }

                Obstacle.TypeIndex = i;

                break;
            }

            if (Obstacle.TypeIndex == OBSTACLE_TYPE_INDEX_INVALID)
            {
                Log("Obstacle with static mesh" @ Obstacle.StaticMesh @ "was unable to be matched to obstacle info!");

                continue;
            }

            Info.Obstacles[Info.Obstacles.Length] = Obstacle;

            //trigger replication
            Obstacle.RemoteRole = ROLE_SimulatedProxy;
        }
    }
}

function DebugObstacles(optional int Option)
{
    local int i;

    switch (Option)
    {
        case 0: // Make all obstacles intact
            for (i = 0; i < Info.Obstacles.Length; ++i)
            {
                SetCleared(Info.Obstacles[i], false);
            }
            break;
        case 1: // Clear all obstacles
            for (i = 0; i < Info.Obstacles.Length; ++i)
            {
                SetCleared(Info.Obstacles[i], true);
            }
            break;
        case 2: // Randomly make all obstacles intact or cleared (50/50 chance)
            for (i = 0; i < Info.Obstacles.Length; ++i)
            {
                SetCleared(Info.Obstacles[i], FRand() >= 0.5);
            }
            break;
        case 3: // Print out the amount number of obstacles
            Level.Game.Broadcast(self, "Obstacle Count:" @ Info.Obstacles.Length);
            break;
        case 4: // Reset obstacles as though a new round has started
            Reset();
            break;
    }

    Level.Game.Broadcast(self, "DebugObstacles" @ Option);
}

function ClearObstacle(int Index)
{
    if (Index < 0 || Index >= Info.Obstacles.Length)
    {
        return;
    }

    SetCleared(Info.Obstacles[Index], true);
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

simulated event PostNetBeginPlay()
{
    default.bPlayEffects = true;

    super.PostNetBeginPlay();
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

                    if (ObstacleIndex < 0 ||
                        ObstacleIndex >= Info.Obstacles.Length ||
                        Info.Obstacles[ObstacleIndex] == none)
                    {
                        break;
                    }

                    Info.Obstacles[ObstacleIndex].SetCleared(bIsCleared);
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

    if (Role == ROLE_Authority)
    {
        for (i = 0; i < Info.Obstacles.Length; ++i)
        {
            Obstacle = Info.Obstacles[i];

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
    bDebug=false
    bHidden=true
    bAlwaysRelevant=true
    RemoteRole=ROLE_SimulatedProxy
    bOnlyDirtyReplication=true
    bSkipActorPropertyReplication=true
    bNetNotify=true
}
