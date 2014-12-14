//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DHObstacleManager extends Actor
    placeable;

var array<DHObstacle>   Obstacles;
var byte                Bitfield[128];
var byte                SavedBitfield[128];

var config bool bDebug;

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        Bitfield;
}

simulated function PostBeginPlay()
{
    local DHObstacle Obstacle;

    super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        foreach AllActors(class'DHObstacle', Obstacle)
        {
            Obstacle.Index = Obstacles.Length;

            Obstacles[Obstacles.Length] = Obstacle;

            if (FRand() < Obstacle.SpawnClearedChance)
            {
                SetCleared(Obstacle, true);
            }

            // Now that the obstacle has an index in the server's obstacle list,
            // it is safe to replicate this actor.
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

    Level.Game.Broadcast(self, "Debugging Obstacles:" @ Option);

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
    }
}

function ClearObstacle(int Index)
{
    if (Index < 0 || Index >= Obstacles.Length)
    {
        return;
    }

    SetCleared(Obstacles[Index], true);
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

    super.Reset();

    if (Role == ROLE_Authority)
    {
        for (i = 0; i < arraycount(Bitfield); ++i)
        {
            Bitfield[i] = 0;
            //TODO: not right, needs to run a full re-calc on cleared status
        }
    }
}

function SetCleared(DHObstacle Obstacle, bool bIsCleared)
{
    local int ByteIndex;
    local byte Mask;

    Obstacle.SetCleared(bIsCleared);

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

defaultproperties
{
    bDebug=true
    bHidden=true
    bStatic=true
    bNoDelete=true
    bAlwaysRelevant=true
    RemoteRole=ROLE_SimulatedProxy
    bOnlyDirtyReplication=true
    bSkipActorPropertyReplication=true
    bNetNotify=true
}

