//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHObstacleManager extends Actor
    notplaceable;

const BITFIELD_COUNT = 8;
const BITFIELD_LENGTH = 32;
const BITS_PER_FIELD = 256; //BITFIELD_LENGTH * 8
const MAX_OBSTACLES = 2048; //BITFIELD_COUNT * BITS_PER_FIELD;
const OBSTACLE_TYPE_INDEX_INVALID = -1;

// In order to keep network traffic down while keeping the number of managed
// obstacles high, we've split up the bitfields that hold the intact status of
// the obstacles.
//
// This creates a ton of problems below; since Epic decided not to include
// pass-by-reference and static array copying functionality, we have to have a
// lot of ugly code duplication to handle drawing data from multiple sources.

var byte            Bitfield0[BITFIELD_LENGTH];
var byte            Bitfield1[BITFIELD_LENGTH];
var byte            Bitfield2[BITFIELD_LENGTH];
var byte            Bitfield3[BITFIELD_LENGTH];
var byte            Bitfield4[BITFIELD_LENGTH];
var byte            Bitfield5[BITFIELD_LENGTH];
var byte            Bitfield6[BITFIELD_LENGTH];
var byte            Bitfield7[BITFIELD_LENGTH];

var byte            SavedBitfield0[BITFIELD_LENGTH];
var byte            SavedBitfield1[BITFIELD_LENGTH];
var byte            SavedBitfield2[BITFIELD_LENGTH];
var byte            SavedBitfield3[BITFIELD_LENGTH];
var byte            SavedBitfield4[BITFIELD_LENGTH];
var byte            SavedBitfield5[BITFIELD_LENGTH];
var byte            SavedBitfield6[BITFIELD_LENGTH];
var byte            SavedBitfield7[BITFIELD_LENGTH];

var DHObstacleInfo  Info;

var config bool     bDebug;

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        Bitfield0, Bitfield1, Bitfield2, Bitfield3, Bitfield4, Bitfield5, Bitfield6, Bitfield7;
}

simulated function PostBeginPlay()
{
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
    local int BitfieldIndex;
    local int ByteIndex;
    local byte Mask;

    GetBitfieldIndexAndMask(Index, BitfieldIndex, ByteIndex, Mask);

    switch (BitfieldIndex)
    {
        case 0:
            return (Bitfield0[ByteIndex] & Mask) == Mask;
        case 1:
            return (Bitfield1[ByteIndex] & Mask) == Mask;
        case 2:
            return (Bitfield2[ByteIndex] & Mask) == Mask;
        case 3:
            return (Bitfield3[ByteIndex] & Mask) == Mask;
        case 4:
            return (Bitfield4[ByteIndex] & Mask) == Mask;
        case 5:
            return (Bitfield5[ByteIndex] & Mask) == Mask;
        case 6:
            return (Bitfield6[ByteIndex] & Mask) == Mask;
        case 7:
            return (Bitfield7[ByteIndex] & Mask) == Mask;
        default:
            return false;
    }
}

simulated function GetBitfieldIndexAndMask(int Index, out int BitfieldIndex, out int ByteIndex, out byte Mask)
{
    BitfieldIndex = Index / BITS_PER_FIELD;
    ByteIndex = (Index / 8) % BITFIELD_LENGTH;
    Mask = 1 << (Index % 8);
}

simulated event PostNetBeginPlay()
{
    local int i, j, k, l, ObstacleIndex;
    local byte Mask;
    local bool bIsCleared;
    local byte Bitfield[BITFIELD_LENGTH];
    local byte SavedBitfield[BITFIELD_LENGTH];

    super.PostNetBeginPlay();

    if (Role < ROLE_Authority)
    {
        for (k = 0; k < BITFIELD_COUNT; ++k)
        {
            // Copy bitfield into temporary bitfield to be evaluated below
            switch (k)
            {
                case 0:
                    for (l = 0; l < arraycount(Bitfield0); ++l)
                    {
                        Bitfield[l] = Bitfield0[l];
                        SavedBitfield[l] = SavedBitfield0[l];
                    }
                    break;
                case 1:
                    for (l = 0; l < arraycount(Bitfield1); ++l)
                    {
                        Bitfield[l] = Bitfield1[l];
                        SavedBitfield[l] = SavedBitfield1[l];
                    }
                    break;
                case 2:
                    for (l = 0; l < arraycount(Bitfield2); ++l)
                    {
                        Bitfield[l] = Bitfield2[l];
                        SavedBitfield[l] = SavedBitfield2[l];
                    }
                    break;
                case 3:
                    for (l = 0; l < arraycount(Bitfield3); ++l)
                    {
                        Bitfield[l] = Bitfield3[l];
                        SavedBitfield[l] = SavedBitfield3[l];
                    }
                    break;
                case 4:
                    for (l = 0; l < arraycount(Bitfield4); ++l)
                    {
                        Bitfield[l] = Bitfield4[l];
                        SavedBitfield[l] = SavedBitfield4[l];
                    }
                    break;
                case 5:
                    for (l = 0; l < arraycount(Bitfield5); ++l)
                    {
                        Bitfield[l] = Bitfield5[l];
                        SavedBitfield[l] = SavedBitfield5[l];
                    }
                    break;
                case 6:
                    for (l = 0; l < arraycount(Bitfield6); ++l)
                    {
                        Bitfield[l] = Bitfield6[l];
                        SavedBitfield[l] = SavedBitfield6[l];
                    }
                    break;
                case 7:
                    for (l = 0; l < arraycount(Bitfield7); ++l)
                    {
                        Bitfield[l] = Bitfield7[l];
                        SavedBitfield[l] = SavedBitfield7[l];
                    }
                    break;
            }

            for (i = 0; i < arraycount(Bitfield); ++i)
            {
                for (j = 0; j < 8; ++j)
                {
                    Mask = 1 << j;

                    bIsCleared = (Bitfield[i] & Mask) == Mask;

                    ObstacleIndex = (k * BITS_PER_FIELD) + (i * 8) + j;

                    if (ObstacleIndex >= 0 &&
                        ObstacleIndex < Info.Obstacles.Length &&
                        Info.Obstacles[ObstacleIndex] != none)
                    {
                        Info.Obstacles[ObstacleIndex].SetCleared(bIsCleared);
                    }
                }
            }
        }
    }
}

simulated event PostNetReceive()
{
    local int i, j, k, l, ObstacleIndex;
    local bool bDidStateChange;
    local bool bIsCleared;
    local bool bWasCleared;
    local byte Mask;
    local byte Bitfield[BITFIELD_LENGTH];
    local byte SavedBitfield[BITFIELD_LENGTH];

    super.PostNetReceive();

    if (Role < ROLE_Authority)
    {
        for (k = 0; k < BITFIELD_COUNT; ++k)
        {
            // Copy bitfield into temporary bitfield to be evaluated below
            switch (k)
            {
                case 0:
                    for (l = 0; l < arraycount(Bitfield); ++l)
                    {
                        Bitfield[l] = Bitfield0[l];
                        SavedBitfield[l] = SavedBitfield0[l];
                    }
                    break;
                case 1:
                    for (l = 0; l < arraycount(Bitfield); ++l)
                    {
                        Bitfield[l] = Bitfield1[l];
                        SavedBitfield[l] = SavedBitfield1[l];
                    }
                    break;
                case 2:
                    for (l = 0; l < arraycount(Bitfield); ++l)
                    {
                        Bitfield[l] = Bitfield2[l];
                        SavedBitfield[l] = SavedBitfield2[l];
                    }
                    break;
                case 3:
                    for (l = 0; l < arraycount(Bitfield); ++l)
                    {
                        Bitfield[l] = Bitfield3[l];
                        SavedBitfield[l] = SavedBitfield3[l];
                    }
                    break;
                case 4:
                    for (l = 0; l < arraycount(Bitfield); ++l)
                    {
                        Bitfield[l] = Bitfield4[l];
                        SavedBitfield[l] = SavedBitfield4[l];
                    }
                    break;
                case 5:
                    for (l = 0; l < arraycount(Bitfield); ++l)
                    {
                        Bitfield[l] = Bitfield5[l];
                        SavedBitfield[l] = SavedBitfield5[l];
                    }
                    break;
                case 6:
                    for (l = 0; l < arraycount(Bitfield); ++l)
                    {
                        Bitfield[l] = Bitfield6[l];
                        SavedBitfield[l] = SavedBitfield6[l];
                    }
                    break;
                case 7:
                    for (l = 0; l < arraycount(Bitfield); ++l)
                    {
                        Bitfield[l] = Bitfield7[l];
                        SavedBitfield[l] = SavedBitfield7[l];
                    }
                    break;
            }

            // Compare current bitfield to previous bitfield.
            for (i = 0; i < arraycount(Bitfield); ++i)
            {
                if (Bitfield[i] == SavedBitfield[i])
                {
                    // No change
                    continue;
                }

                // Byte has changed, drill down and find what bit(s) changed.
                for (j = 0; j < 8; ++j)
                {
                    Mask = 1 << j;

                    bIsCleared = (Bitfield[i] & Mask) == Mask;
                    bWasCleared = (SavedBitfield[i] & Mask) == Mask;
                    bDidStateChange = bIsCleared != bWasCleared;

                    if (bDidStateChange)
                    {
                        ObstacleIndex = (k * BITS_PER_FIELD) + (i * 8) + j;

                        if (ObstacleIndex < 0 ||
                            ObstacleIndex >= Info.Obstacles.Length ||
                            Info.Obstacles[ObstacleIndex] == none)
                        {
                            break;
                        }

                        Info.Obstacles[ObstacleIndex].SetCleared(bIsCleared);
                    }
                }

                switch (k)
                {
                    case 0:
                        for (l = 0; l < arraycount(Bitfield); ++l)
                        {
                            SavedBitfield0[l] = Bitfield[l];
                        }
                        break;
                    case 1:
                        for (l = 0; l < arraycount(Bitfield); ++l)
                        {
                            SavedBitfield1[l] = Bitfield[l];
                        }
                        break;
                    case 2:
                        for (l = 0; l < arraycount(Bitfield); ++l)
                        {
                            SavedBitfield2[l] = Bitfield[l];
                        }
                        break;
                    case 3:
                        for (l = 0; l < arraycount(Bitfield); ++l)
                        {
                            SavedBitfield3[l] = Bitfield[l];
                        }
                        break;
                    case 4:
                        for (l = 0; l < arraycount(Bitfield); ++l)
                        {
                            SavedBitfield4[l] = Bitfield[l];
                        }
                        break;
                    case 5:
                        for (l = 0; l < arraycount(Bitfield); ++l)
                        {
                            SavedBitfield5[l] = Bitfield[l];
                        }
                        break;
                    case 6:
                        for (l = 0; l < arraycount(Bitfield); ++l)
                        {
                            SavedBitfield6[l] = Bitfield[l];
                        }
                        break;
                    case 7:
                        for (l = 0; l < arraycount(Bitfield); ++l)
                        {
                            SavedBitfield7[l] = Bitfield[l];
                        }
                        break;
                }
            }
        }
    }
}

simulated function Reset()
{
    local int i;

    super.Reset();

    if (Role == ROLE_Authority)
    {
        for (i = 0; i < Info.Obstacles.Length; ++i)
        {
            SetCleared(Info.Obstacles[i], FRand() < Info.Obstacles[i].Info.SpawnClearedChance);
        }
    }
}

function SetCleared(DHObstacleInstance Obstacle, bool bIsCleared)
{
    local int BitfieldIndex;
    local int ByteIndex;
    local byte Mask;

    Obstacle.SetCleared(bIsCleared);

    if (Level.NetMode != NM_Client)
    {
        GetBitfieldIndexAndMask(Obstacle.Info.Index, BitfieldIndex, ByteIndex, Mask);

        if (bIsCleared)
        {
            switch (BitfieldIndex)
            {
                case 0:
                    Bitfield0[ByteIndex] = Bitfield0[ByteIndex] | Mask;
                    break;
                case 1:
                    Bitfield1[ByteIndex] = Bitfield1[ByteIndex] | Mask;
                    break;
                case 2:
                    Bitfield2[ByteIndex] = Bitfield2[ByteIndex] | Mask;
                    break;
                case 3:
                    Bitfield3[ByteIndex] = Bitfield3[ByteIndex] | Mask;
                    break;
                case 4:
                    Bitfield4[ByteIndex] = Bitfield4[ByteIndex] | Mask;
                    break;
                case 5:
                    Bitfield5[ByteIndex] = Bitfield5[ByteIndex] | Mask;
                    break;
                case 6:
                    Bitfield6[ByteIndex] = Bitfield6[ByteIndex] | Mask;
                    break;
                case 7:
                    Bitfield7[ByteIndex] = Bitfield7[ByteIndex] | Mask;
                    break;
            }
        }
        else
        {
            switch (BitfieldIndex)
            {
                case 0:
                    Bitfield0[ByteIndex] = Bitfield0[ByteIndex] & ~Mask;
                    break;
                case 1:
                    Bitfield1[ByteIndex] = Bitfield1[ByteIndex] & ~Mask;
                    break;
                case 2:
                    Bitfield2[ByteIndex] = Bitfield2[ByteIndex] & ~Mask;
                    break;
                case 3:
                    Bitfield3[ByteIndex] = Bitfield3[ByteIndex] & ~Mask;
                    break;
                case 4:
                    Bitfield4[ByteIndex] = Bitfield4[ByteIndex] & ~Mask;
                    break;
                case 5:
                    Bitfield5[ByteIndex] = Bitfield5[ByteIndex] & ~Mask;
                    break;
                case 6:
                    Bitfield6[ByteIndex] = Bitfield6[ByteIndex] & ~Mask;
                    break;
                case 7:
                    Bitfield7[ByteIndex] = Bitfield7[ByteIndex] & ~Mask;
                    break;
            }
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
