//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHGameReplicationInfo extends ROGameReplicationInfo;

const RADIOS_MAX = 32;
const ROLES_MAX = 16;
const MORTAR_TARGETS_MAX = 2;
const VEHICLE_POOLS_MAX = 32;
const SPAWN_POINTS_MAX = 63;
const OBJECTIVES_MAX = 32;
const CONSTRUCTION_CLASSES_MAX = 32;
const VOICEID_MAX = 255;
const SUPPLY_POINTS_MAX = 15;
const MAP_MARKERS_MAX = 20;
const MAP_MARKERS_CLASSES_MAX = 16;
const ARTILLERY_TYPES_MAX = 8;
const ARTILLERY_MAX = 8;
const MINE_VOLUMES_MAX = 64;
const NO_ARTY_VOLUMES_MAX = 32;

enum EVehicleReservationError
{
    ERROR_None,
    ERROR_Fatal,
    ERROR_InvalidCredentials,
    ERROR_TeamMaxActive,
    ERROR_PoolOutOfSpawns,
    ERROR_PoolInactive,
    ERROR_PoolMaxActive,
    ERROR_NoReservations,
    ERROR_NoLicense
};

struct SpawnVehicle
{
    var int             SpawnPointIndex;
    var int             VehiclePoolIndex;
    var Vehicle         Vehicle;
};

struct SupplyPoint
{
    var byte bIsActive;
    var byte TeamIndex;
    var DHConstructionSupplyAttachment Actor;
    var class<DHConstructionSupplyAttachment> ActorClass;
};

// The request error type.
enum EArtilleryTypeError
{
    ERROR_None,
    ERROR_Fatal,
    ERROR_Unavailable,
    ERROR_Exhausted,
    ERROR_Unqualified,
    ERROR_NotEnoughSquadMembers,
    ERROR_Cooldown,
    ERROR_Ongoing,
    ERROR_SquadTooSmall,
    ERROR_Cancellable
};

struct STeamScores
{
    var int Kills;
    var int Deaths;
    var int CategoryScores[2];
};

var STeamScores         TeamScores[2];

var class<DHGameType>   GameType;

var SupplyPoint         SupplyPoints[SUPPLY_POINTS_MAX];

var DHRadio             Radios[RADIOS_MAX];

var int                 AlliedNationID;
var int                 AlliesVictoryMusicIndex;
var int                 AxisVictoryMusicIndex;

var int                 RoundEndTime;       // Length of a round in seconds (this can be modified at real time unlike RoundDuration, which it replaces)
var int                 RoundOverTime;      // The time stamp at which the round is over
var int                 SpawningEnableTime; // When spawning for the round should be enabled (default: 0)

var int                 DHRoundLimit;       // Added this so that a changing round limit can be replicated to clients.
var int                 DHRoundDuration;    // Added this so that a more flexible changing round duration can be replicated to clients (e.g change to unlimited)

var DHRoleInfo          DHAxisRoles[ROLES_MAX];
var DHRoleInfo          DHAlliesRoles[ROLES_MAX];

var DHArtillery         DHArtillery[ARTILLERY_MAX];

var byte                DHAlliesRoleLimit[ROLES_MAX];
var byte                DHAlliesRoleBotCount[ROLES_MAX];
var byte                DHAlliesRoleCount[ROLES_MAX];
var byte                DHAxisRoleLimit[ROLES_MAX];
var byte                DHAxisRoleBotCount[ROLES_MAX];
var byte                DHAxisRoleCount[ROLES_MAX];

var int                 SpawnsRemaining[2];
var float               AttritionRate[2];
var float               CurrentAlliedToAxisRatio;

// TODO: vehicle classes should have been made available in static data for client and server to read
var class<ROVehicle>    VehiclePoolVehicleClasses[VEHICLE_POOLS_MAX];
var byte                VehiclePoolIsActives[VEHICLE_POOLS_MAX];
var float               VehiclePoolNextAvailableTimes[VEHICLE_POOLS_MAX];
var byte                VehiclePoolActiveCounts[VEHICLE_POOLS_MAX];
var byte                VehiclePoolMaxActives[VEHICLE_POOLS_MAX];
var byte                VehiclePoolMaxSpawns[VEHICLE_POOLS_MAX];
var byte                VehiclePoolSpawnCounts[VEHICLE_POOLS_MAX];
var byte                VehiclePoolIsSpawnVehicles[VEHICLE_POOLS_MAX];
var byte                VehiclePoolReservationCount[VEHICLE_POOLS_MAX];
var int                 VehiclePoolIgnoreMaxTeamVehiclesFlags;

// It is impossible to get DHMineVolume to actually replicate variables so this is needed as proxy.
var byte                    DHMineVolumeIsActives[MINE_VOLUMES_MAX];
var array<RONoArtyVolume>   DHNoArtyVolumes;
var byte                    DHNoArtyVolumeIsActives[NO_ARTY_VOLUMES_MAX];

var int                 MaxTeamVehicles[2];

var float               TeamMunitionPercentages[2];

var DHSpawnPointBase    SpawnPoints[SPAWN_POINTS_MAX];

var DHObjective             DHObjectives[OBJECTIVES_MAX];
var Hashtable_string_int    DHObjectiveTable; // not replicated, but clients create their own so can be used by both client/server

var bool                bIsInSetupPhase;
var bool                bRoundIsOver;

var localized string    ForceScaleText;
var localized string    ReinforcementsInfiniteText;

var private array<string>   ConstructionClassNames;
var class<DHConstruction>   ConstructionClasses[CONSTRUCTION_CLASSES_MAX];
var DHConstructionManager   ConstructionManager;

struct STeamConstruction
{
    var class<DHConstruction> ConstructionClass;
    var byte TeamIndex;
    var byte Remaining;
    var int NextIncrementTimeSeconds;
};

var STeamConstruction   TeamConstructions[16];

var bool                bAreConstructionsEnabled;
var bool                bAllChatEnabled;

var byte                ServerTickHealth;
var int                 ServerNetHealth;

var private bool        bIsDangerZoneEnabled;
var private byte        DangerZoneNeutral;
var private byte        DangerZoneBalance;
var private byte        OldDangerZoneNeutral;
var private byte        OldDangerZoneBalance;

// Map markers
struct MapMarker
{
    var DHPlayerReplicationInfo Author;
    var class<DHMapMarker> MapMarkerClass;
    var byte LocationX;                     // Quantized representation of 0.0..1.0 - X coordinate
    var byte LocationY;                     // Quantized representation of 0.0..1.0 - Y coordinate
    var byte SquadIndex;                    // The squad index that owns the marker, or -1 if team-wide
    var int CreationTime;                   // The time this marker was created, relative to ElapsedTime
    var int ExpiryTime;                     // The expiry time, relative to ElapsedTime
    var vector WorldLocation;               // World location of the marker
};

// This handles the mutable artillery type info (classes, team indices can be fetched from static data in DH_LevelInfo).
// TODO: reset this somewhere on round begin
struct ArtilleryTypeInfo
{
    var bool                bIsAvailable;               // Whether or not this type of artillery is available (can be made available and unavailable during a round).
    var int                 UsedCount;                  // The amount of times this artillery type has been confirmed.
    var int                 Limit;                      // The amount of these types of artillery strikes that are available.
    var int                 NextConfirmElapsedTime;     // The next time, relative to ElapsedTime, that a request can confirmed for this artillery type.
    var DHArtillery         ArtilleryActor;             // Artillery actor.
};
var ArtilleryTypeInfo                   ArtilleryTypeInfos[ARTILLERY_TYPES_MAX];

// to do: add airstrikes
enum EArtilleryType
{
    ArtyType_Barrage,
    ArtyType_Paradrop,
    ArtyType_Airstrikes
};

struct SAvailableArtilleryInfoEntry
{
    var int Count;
    var EArtilleryType Type;
};

var private array<string>               MapMarkerClassNames;
var class<DHMapMarker>                  MapMarkerClasses[MAP_MARKERS_CLASSES_MAX];
var MapMarker                           AxisMapMarkers[MAP_MARKERS_MAX];
var MapMarker                           AlliesMapMarkers[MAP_MARKERS_MAX];
var byte                                bOffMapArtilleryEnabled[2];
var byte                                bOnMapArtilleryEnabled[2];

// Delayed round ending
var byte   RoundWinnerTeamIndex;
var string RoundEndReason;

var         bool bIsSurrenderVoteEnabled;
var private byte SurrenderVotesInProgress[2];

replication
{
    // Variables the server will replicate to all clients
    reliable if (bNetDirty && Role == ROLE_Authority)
        RoundEndTime,
        SpawnsRemaining,
        DHAxisRoles,
        DHAlliesRoles,
        DHAlliesRoleLimit,
        DHAlliesRoleCount,
        DHAxisRoleLimit,
        DHAxisRoleCount,
        DHAlliesRoleBotCount,
        DHAxisRoleBotCount,
        Radios,
        VehiclePoolVehicleClasses,
        VehiclePoolIsActives,
        VehiclePoolNextAvailableTimes,
        VehiclePoolActiveCounts,
        VehiclePoolMaxActives,
        VehiclePoolMaxSpawns,
        VehiclePoolSpawnCounts,
        VehiclePoolIsSpawnVehicles,
        VehiclePoolReservationCount,
        VehiclePoolIgnoreMaxTeamVehiclesFlags,
        MaxTeamVehicles,
        DHObjectives,
        AttritionRate,
        GameType,
        CurrentAlliedToAxisRatio,
        SpawnPoints,
        SpawningEnableTime,
        bIsInSetupPhase,
        bRoundIsOver,
        bAreConstructionsEnabled,
        SupplyPoints,
        AxisMapMarkers,
        AlliesMapMarkers,
        bAllChatEnabled,
        RoundOverTime,
        DHRoundLimit,
        DHRoundDuration,
        ServerTickHealth,
        ServerNetHealth,
        ArtilleryTypeInfos,
        DHArtillery,
        TeamMunitionPercentages,
        AlliesVictoryMusicIndex,
        AxisVictoryMusicIndex,
        bIsDangerZoneEnabled,
        DangerZoneNeutral,
        DangerZoneBalance,
        RoundWinnerTeamIndex,
        bIsSurrenderVoteEnabled,
        SurrenderVotesInProgress,
        TeamConstructions,
        bOffMapArtilleryEnabled,
        bOnMapArtilleryEnabled,
        DHMineVolumeIsActives,
        DHNoArtyVolumeIsActives,
        TeamScores;

    reliable if (bNetInitial && Role == ROLE_Authority)
        AlliedNationID, ConstructionClasses, MapMarkerClasses;
}

simulated event PreBeginPlay()
{
    super.PreBeginPlay();

    DHObjectiveTable = class'Hashtable_string_int'.static.Create(OBJECTIVES_MAX * 2);
}

// Modified to build SpawnPoints array
// Also to nullify all water splash effects in WaterVolumes & FluidSurfaceInfos, as they clash with splash effects in projectile classes that are more specific to the projectile
// Another problem is a big splash effect was being played for every ejected bullet shell case that hit water, looking totally wrong for such a small, relatively slow object
simulated function PostBeginPlay()
{
    local WaterVolume                   WV;
    local FluidSurfaceInfo              FSI;
    local int                           i, j;
    local DH_LevelInfo                  LI;
    local class<DHMapMarker>            MapMarkerClass;

    super.PostBeginPlay();

    foreach AllActors(class'WaterVolume', WV)
    {
        WV.PawnEntryActor = none;
        WV.PawnEntryActorName = "";
        WV.EntryActor = none;
        WV.EntryActorName = "";
        WV.EntrySound = none;
        WV.EntrySoundName = "";
        WV.ExitActor = none;
        WV.ExitSound = none;
        WV.ExitSoundName = "";
    }

    foreach AllActors(class'FluidSurfaceInfo', FSI)
    {
        FSI.TouchEffect = none;
    }

    if (Role == ROLE_Authority)
    {
        for (i = 0; i < ConstructionClassNames.Length; ++i)
        {
            if (ConstructionClassNames[i] != "")
            {
                AddConstructionClass(class<DHConstruction>(DynamicLoadObject(ConstructionClassNames[i], class'class')));
            }
        }

        LI = class'DH_LevelInfo'.static.GetInstance(Level);

        if (LI != none)
        {
            bAreConstructionsEnabled = LI.GameTypeClass.default.bAreConstructionsEnabled;
        }

        // Add usable map markers to the class list to be replicated!
        j = 0;

        for (i = 0; i < MapMarkerClassNames.Length; ++i)
        {
            MapMarkerClass = class<DHMapMarker>(DynamicLoadObject(MapMarkerClassNames[i], class'class'));

            if (MapMarkerClass != none && MapMarkerClass.static.CanBeUsed(self))
            {
                MapMarkerClasses[j++] = MapMarkerClass;
            }
        }

        RegisterMineVolumes();
    }

    RegisterNoArtyVolumes();
}

simulated function int GetTeamConstructionIndex(int TeamIndex, class<DHConstruction> ConstructionClass)
{
    local int i;

    for (i = 0; i < arraycount(TeamConstructions); ++i)
    {
        if (TeamConstructions[i].ConstructionClass == none)
        {
            continue;
        }

        if (TeamConstructions[i].TeamIndex == TeamIndex &&
            TeamConstructions[i].ConstructionClass == ConstructionClass)
        {
            return i;
        }
    }

    return -1;
}

simulated function int GetTeamConstructionNextIncrementTimeSeconds(int TeamIndex, class<DHConstruction> ConstructionClass)
{
    local int i;
    local DH_LevelInfo LI;

    i = GetTeamConstructionIndex(TeamIndex, ConstructionClass);

    if (i == -1)
    {
       return -1;
    }

    LI = class'DH_LevelInfo'.static.GetInstance(Level);

    if (LI != none && LI.TeamConstructions[i].ReplenishPeriodSeconds > 0)
    {
        return TeamConstructions[i].NextIncrementTimeSeconds;
    }

    return -1;
}

simulated function int GetTeamConstructionRemaining(int TeamIndex, class<DHConstruction> ConstructionClass)
{
    local int i;

    i = GetTeamConstructionIndex(TeamIndex, ConstructionClass);

    if (i == -1)
    {
       return -1;
    }

    return TeamConstructions[i].Remaining;
}

simulated function PostNetBeginPlay()
{
    local DHObjective Obj;
    local int i, ObjIndex;

    super.PostNetBeginPlay();

    // Loop all objectives to setup the hash table
    foreach AllActors(class'DHObjective', Obj)
    {
        if (Obj != none)
        {
            // Add tag and obj index into the table (runs on both server and client) so both can use the table
            DHObjectiveTable.Put(Obj.Tag, Obj.ObjNum);
        }
    }

    // Loop all objectives to set index variables up based on tag ones (uses hash table)
    foreach AllActors(class'DHObjective', Obj)
    {
        if (Obj != none)
        {
            // Loop through the Axis Required Objectives (by tag) and set the (by index) values up
            for (i = 0; i < Obj.AxisRequiredObjTagForCapture.Length; ++i)
            {
                if (DHObjectiveTable.Get(string(Obj.AxisRequiredObjTagForCapture[i]), ObjIndex))
                {
                    Obj.AxisRequiredObjForCapture[Obj.AxisRequiredObjForCapture.Length] = ObjIndex;
                }
            }

            // Loop through the Allies Required Objectives (by tag) and set the (by index) values up
            for (i = 0; i < Obj.AlliesRequiredObjTagForCapture.Length; ++i)
            {
                if (DHObjectiveTable.Get(string(Obj.AlliesRequiredObjTagForCapture[i]), ObjIndex))
                {
                    Obj.AlliesRequiredObjForCapture[Obj.AlliesRequiredObjForCapture.Length] = ObjIndex;
                }
            }
        }
    }
}

simulated function PostNetReceive()
{
    super.PostNetReceive();

    if (OldDangerZoneNeutral != DangerZoneNeutral || OldDangerZoneBalance != DangerZoneBalance)
    {
        DangerZoneUpdated();

        OldDangerZoneNeutral = DangerZoneNeutral;
        OldDangerZoneBalance = DangerZoneBalance;
    }
}

simulated function ObjectiveCompleted()
{
    if (bIsDangerZoneEnabled)
    {
        DangerZoneUpdated();
    }
}

function bool ObjectiveTreeNodeDepthComparatorFunction(int LHS, int RHS)
{
    return (LHS >> 16) > (RHS >> 16);
}

// This function returns all objectives (via array of indices) which meets objective spawn criteria
function GetIndicesForObjectiveSpawns(int Team, out array<int> Indices)
{
    local int i;
    local array<DHObjectiveTreeNode> Roots;
    local DHObjective Obj;
    local array<int> ObjectiveIndices;
    local UComparator_int Comparator;
    local int Depth, MinDepth;

    for (i = 0; i < arraycount(DHObjectives); ++i)
    {
        Obj = DHObjectives[i];

        if (Obj == none)
        {
            continue;
        }

        // Root objectives are those that are active
        if (Obj.IsActive())
        {
            Roots[Roots.Length] = GetObjectiveTree(Team, Obj, ObjectiveIndices);
        }
    }

    // We have the root objectives, lets tranverse the trees to find the nearest objective with spawnpoint hints defined
    for (i = 0; i < Roots.Length; ++i)
    {
        TraverseTreeNode(Team, Roots[i], Roots[i], Indices);
    }

    // Sort the indices by depth.
    Comparator = new class'UComparator_int';
    Comparator.CompareFunction = ObjectiveTreeNodeDepthComparatorFunction;
    class'USort'.static.ISort(Indices, Comparator);

    // Eliminate all indices that are below the Minimum Required Depth
    MinDepth = GetMinRequiredDepth();
    for (i = Indices.Length - 1; i >= 0; --i)
    {
        if ((Indices[i] >> 16) < MinDepth)
        {
            Indices.Remove(i, 1);
        }
    }

    // Eliminate all objective indices that do not match the lowest depth
    if (Indices.Length > 0)
    {
        Depth = Indices[0] >> 16;
    }

    for (i = Indices.Length - 1; i >= 0; --i)
    {
        if ((Indices[i] >> 16) != Depth)
        {
            Indices.Remove(i, 1);
        }
    }

    for (i = 0; i < Indices.Length; ++i)
    {
        Indices[i] = Indices[i] & 0xFFFF;
    }
}

function TraverseTreeNode(int Team, DHObjectiveTreeNode Root, DHObjectiveTreeNode Node, out array<int> ObjectiveIndices, optional int Depth)
{
    local int i;
    local bool bIsFarEnoughAway;
    local bool bNodeHasHints;
    local bool bAlreadyAdded;
    local bool bIsActive;
    local DH_LevelInfo LI;

    if (Node == none)
    {
        return;
    }

    LI = class'DH_LevelInfo'.static.GetInstance(Level);

    if (LI == none)
    {
        return;
    }

    bIsFarEnoughAway = VSize(Root.Objective.Location - Node.Objective.Location) > class'DHUnits'.static.MetersToUnreal(LI.ObjectiveSpawnDistanceThreshold);
    bNodeHasHints = Node.Objective.SpawnPointHintTags[Team] != '';
    bAlreadyAdded = class'UArray'.static.IIndexOf(ObjectiveIndices, Node.Objective.ObjNum) == -1;
    bIsActive = Node.Objective.IsActive();

    if (bNodeHasHints && bIsFarEnoughAway && bAlreadyAdded && !bIsActive)
    {
        ObjectiveIndices[ObjectiveIndices.Length] = (Depth << 16) | Node.Objective.ObjNum;
    }

    for (i = 0; i < Node.Children.Length; ++i)
    {
        TraverseTreeNode(Team, Root, Node.Children[i], ObjectiveIndices, Depth + 1);
    }
}

// Function which determines
function int GetMinRequiredDepth()
{
    local DH_LevelInfo LI;

    LI = class'DH_LevelInfo'.static.GetInstance(Level);

    if (LI == none)
    {
        Warn("Something has gone very wrong in GetMinDepth in class DHGameReplicationInfo, LevelInfo is none!");
        return 1; // return with a fair value
    }

    // If the level overrides the gametype, return the override
    if (LI.ObjectiveSpawnMinimumDepth != -1)
    {
        return LI.ObjectiveSpawnMinimumDepth;
    }

    // Otherwise return the Gametype's min depth
    return LI.GameTypeClass.default.ObjSpawnMinimumDepth;
}

function DHObjectiveTreeNode GetObjectiveTree(int Team, DHObjective Objective, out array<int> ObjectiveIndices)
{
    local int i;
    local DHObjectiveTreeNode Node;
    local DHObjectiveTreeNode Child;

    if (Objective == none)
    {
        return none;
    }

    if (class'UArray'.static.IIndexOf(ObjectiveIndices, Objective.ObjNum) != -1)
    {
        return none;
    }

    ObjectiveIndices[ObjectiveIndices.Length] = Objective.ObjNum;

    Node = new class'DHObjectiveTreeNode';
    Node.Objective = Objective;

    if (Team == AXIS_TEAM_INDEX)
    {
        for (i = 0; i < Objective.AxisRequiredObjForCapture.Length; ++i)
        {
            if (DHObjectives[Objective.AxisRequiredObjForCapture[i]].IsActive())
            {
                continue;
            }

            Child = GetObjectiveTree(Team, DHObjectives[Objective.AxisRequiredObjForCapture[i]], ObjectiveIndices);

            if (Child != none)
            {
                Node.Children[Node.Children.Length] = Child;
            }
        }
    }
    else if (Team == ALLIES_TEAM_INDEX)
    {
        for (i = 0; i < Objective.AlliesRequiredObjForCapture.Length; ++i)
        {
            if (DHObjectives[Objective.AlliesRequiredObjForCapture[i]].IsActive())
            {
                continue;
            }

            Child = GetObjectiveTree(Team, DHObjectives[Objective.AlliesRequiredObjForCapture[i]], ObjectiveIndices);

            if (Child != none)
            {
                Node.Children[Node.Children.Length] = Child;
            }
        }
    }

    return Node;
}

function int AddConstructionClass(class<DHConstruction> ConstructionClass)
{
    local int i;

    if (ConstructionClass != none)
    {
        for (i = 0; i < arraycount(ConstructionClasses); ++i)
        {
            if (ConstructionClasses[i] == none)
            {
                ConstructionClasses[i] = ConstructionClass;
                return i;
            }
        }
    }

    return -1;
}

// Modified for net client to check whether local local player has his weapons locked & it's now time to unlock them
simulated event Timer()
{
    super.Timer();

    if (Role < ROLE_Authority && DHPlayer(Level.GetLocalPlayerController()) != none)
    {
        DHPlayer(Level.GetLocalPlayerController()).CheckUnlockWeapons();
    }

    if (Role == ROLE_Authority)
    {
        UpdateNoArtyVolumeStatuses();
    }
}

//==============================================================================
// Supply Points
//==============================================================================

function int AddSupplyPoint(DHConstructionSupplyAttachment CSA)
{
    local int i;

    if (CSA != none)
    {
        for (i = 0; i < arraycount(SupplyPoints); ++i)
        {
            if (SupplyPoints[i].Actor == none)
            {
                SupplyPoints[i].bIsActive = 1;
                SupplyPoints[i].Actor = CSA;
                SupplyPoints[i].TeamIndex = CSA.GetTeamIndex();
                SupplyPoints[i].ActorClass = CSA.Class;
                return i;
            }
        }
    }

    return -1;
}

function RemoveSupplyPoint(DHConstructionSupplyAttachment CSA)
{
    local int i;

    if (CSA != none)
    {
        for (i = 0; i < arraycount(SupplyPoints); ++i)
        {
            if (SupplyPoints[i].Actor == CSA)
            {
                SupplyPoints[i].bIsActive = 0;
                SupplyPoints[i].Actor = none;
                break;
            }
        }
    }
}

// Function will collect resources from Main Cache if it exists, will return -1 if it doesn't
// Collect means it will pass the supply from the main cache (subtracting it) and give it to the vehicle (adding it)
// This is meant to be used by vehicles with vehicle supply attachements
function int CollectSupplyFromMainCache(int Team, int MaxCarryingCapacity)
{
    local int                               i, n;
    local DHConstructionSupplyAttachment    SupplyAttachment;

    for (i = 0; i < arraycount(SupplyPoints); ++i)
    {
        if (SupplyPoints[i].ActorClass == none)
        {
            continue;
        }

        // Find the main cache for the team
        if (SupplyPoints[i].ActorClass.default.bIsMainSupplyCache && SupplyPoints[i].TeamIndex == Team)
        {
            if (SupplyPoints[i].Actor != none)
            {
                SupplyAttachment = SupplyPoints[i].Actor;
            }

            // Calculate the supply we can give
            n = Clamp(SupplyAttachment.GetSupplyCount(), 0, MaxCarryingCapacity);

            // Subtract the supply we will give
            SupplyAttachment.SetSupplyCount(FClamp(SupplyAttachment.GetSupplyCount() - n, 0.0, float(SupplyAttachment.SupplyCountMax)));

            // Return the supply amount we are giving
            return n;
        }
    }

    // We did not find a main cache
    return -1;
}

// This will return supply caches that are able to generate supply (aka not full)
function int GetNumberOfGeneratingSupplyPointsForTeam(int Team)
{
    local int i, Count;

    // Count active unfilled supply points that generate supply based on team
    for (i = 0; i < arraycount(SupplyPoints); ++i)
    {
        if (SupplyPoints[i].Actor != none &&
            SupplyPoints[i].bIsActive == 1 &&
            SupplyPoints[i].TeamIndex == Team &&
            SupplyPoints[i].Actor.IsGeneratingSupplies())
        {
            ++Count;
        }
    }

    return Count;
}

// This will return supply caches (only they can generate supply)
simulated function int GetNumberOfSupplyCachesForTeam(int Team, optional bool bExcludeMainCache)
{
    local int i, Count;

    // Count active supply points based on team
    for (i = 0; i < arraycount(SupplyPoints); ++i)
    {
        if (SupplyPoints[i].Actor != none &&
            SupplyPoints[i].bIsActive == 1 &&
            SupplyPoints[i].TeamIndex == Team &&
            SupplyPoints[i].ActorClass.default.bCanGenerateSupplies)
        {
            ++Count;

            if (bExcludeMainCache && SupplyPoints[i].ActorClass.default.bIsMainSupplyCache)
            {
                --Count;
            }
        }
    }

    return Count;
}

//==============================================================================
// Spawn Points
//==============================================================================

simulated function int AddSpawnPoint(DHSpawnPointBase SP)
{
    local int i;

    if (SP == none)
    {
        return -1;
    }

    for (i = 0; i < arraycount(SpawnPoints); ++i)
    {
        if (SP == SpawnPoints[i])
        {
            return -1;
        }
    }

    for (i = 0; i < arraycount(SpawnPoints); ++i)
    {
        if (SpawnPoints[i] == none)
        {
            SpawnPoints[i] = SP;
            return i;
        }
    }

    // All spawn points slots are filled. If the new spawn point is not
    // low-priority, we can search for a spawn point to destroy and replace
    // it with.
    if (!SP.bIsLowPriority)
    {
        for (i = 0; i < arraycount(SpawnPoints); ++i)
        {
            if (SpawnPoints[i].bIsLowPriority)
            {
                SpawnPoints[i].Destroy();
                SpawnPoints[i] = SP;
                return i;
            }
        }
    }

    return -1;
}

simulated function DHSpawnPointBase GetSpawnPoint(int SpawnPointIndex)
{
    if (SpawnPointIndex < 0 || SpawnPointIndex >= arraycount(SpawnPoints))
    {
        return none;
    }

    return SpawnPoints[SpawnPointIndex];
}

simulated function DHSpawnPointBase GetMostDesirableSpawnPoint(DHPlayer PC, optional out int OutDesirability)
{
    local int i, Desirability;
    local DHSpawnPointBase SP;

    OutDesirability = -MaxInt;

    for (i = 0; i < arraycount(SpawnPoints); ++i)
    {
        if (SpawnPoints[i] != none && SpawnPoints[i].IsVisibleToPlayer(PC)) // TODO: should probably check if we can even spawn here
        {
            Desirability = SpawnPoints[i].GetDesirability();

            if (Desirability > OutDesirability)
            {
                SP = SpawnPoints[i];
                OutDesirability = Desirability;
            }
        }
    }

    return SP;
}

simulated function bool IsRallyPointIndexValid(DHPlayer PC, byte RallyPointIndex, int TeamIndex)
{
    local DHSpawnPoint_SquadRallyPoint RP;
    local DHPlayerReplicationInfo PRI;

    if (PC == none || PC.SquadReplicationInfo == none)
    {
        return false;
    }

    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

    RP = PC.SquadReplicationInfo.RallyPoints[RallyPointIndex];

    if (RP == none || PRI == none || PRI.Team.TeamIndex != RP.GetTeamIndex() || PRI.SquadIndex != RP.SquadIndex)
    {
        return false;
    }

    return true;
}

simulated function bool CanSpawnWithParameters(int SpawnPointIndex, int TeamIndex, int RoleIndex, int SquadIndex, int VehiclePoolIndex, optional bool bSkipTimeCheck)
{
    local DHSpawnPointBase SP;
    local class<DHVehicle> VehicleClass;

    if (VehiclePoolIndex != -1)
    {
        VehicleClass = class<DHVehicle>(GetVehiclePoolVehicleClass(VehiclePoolIndex));

        if (VehicleClass == none || !CanSpawnVehicle(VehiclePoolIndex, bSkipTimeCheck))
        {
            return false;
        }
    }

    SP = GetSpawnPoint(SpawnPointIndex);

    return SP != none && SP.CanSpawnWithParameters(self, TeamIndex, RoleIndex, SquadIndex, VehiclePoolIndex, bSkipTimeCheck);
}

simulated function bool CanSpawnVehicle(int VehiclePoolIndex, optional bool bSkipTimeCheck)
{
    local class<ROVehicle> VC;

    if (VehiclePoolIndex < 0 || VehiclePoolIndex >= VEHICLE_POOLS_MAX)
    {
        return false;
    }

    VC = VehiclePoolVehicleClasses[VehiclePoolIndex];

    if (!IgnoresMaxTeamVehiclesFlags(VehiclePoolIndex) && MaxTeamVehicles[VC.default.VehicleTeam] <= 0)
    {
        return false;
    }

    if (!IsVehiclePoolActive(VehiclePoolIndex))
    {
        return false;
    }

    if (!bSkipTimeCheck && ElapsedTime < VehiclePoolNextAvailableTimes[VehiclePoolIndex])
    {
        return false;
    }

    if (VehiclePoolSpawnCounts[VehiclePoolIndex] >= VehiclePoolMaxSpawns[VehiclePoolIndex])
    {
        return false;
    }

    if (VehiclePoolActiveCounts[VehiclePoolIndex] >= VehiclePoolMaxActives[VehiclePoolIndex])
    {
        return false;
    }

    return true;
}

//------------------------------------------------------------------------------
// Vehicle Pool Functions
//------------------------------------------------------------------------------

function SetVehiclePoolIsActive(byte VehiclePoolIndex, bool bIsActive)
{
    local Controller C;
    local DHPlayer PC;

    if (bIsActive)
    {
        VehiclePoolIsActives[VehiclePoolIndex] = 1;
    }
    else
    {
        VehiclePoolIsActives[VehiclePoolIndex] = 0;

        for (C = Level.ControllerList; C != none; C = C.NextController)
        {
            PC = DHPlayer(C);

            if (PC != none && PC.VehiclePoolIndex == VehiclePoolIndex)
            {
                PC.VehiclePoolIndex = -1;
                PC.bSpawnParametersInvalidated = true;
            }
        }
    }
}

simulated function bool IsVehiclePoolInfinite(byte VehiclePoolIndex)
{
    return VehiclePoolMaxSpawns[VehiclePoolIndex] == 255;
}

simulated function bool IsVehiclePoolActive(byte VehiclePoolIndex)
{
    return VehiclePoolIsActives[VehiclePoolIndex] != 0;
}

simulated function byte GetVehiclePoolSpawnsRemaining(byte VehiclePoolIndex)
{
    if (IsVehiclePoolInfinite(VehiclePoolIndex))
    {
        return 255;
    }

    return VehiclePoolMaxSpawns[VehiclePoolIndex] - VehiclePoolSpawnCounts[VehiclePoolIndex];
}

simulated function class<Vehicle> GetVehiclePoolVehicleClass(int VehiclePoolIndex)
{
    if (VehiclePoolIndex == -1 || VehiclePoolIndex >= arraycount(VehiclePoolVehicleClasses))
    {
        return none;
    }

    return VehiclePoolVehicleClasses[VehiclePoolIndex];
}

simulated function byte GetVehiclePoolAvailableReservationCount(int VehiclePoolIndex)
{
    local int Active, MaxActive, ReservationCount, VehiclePoolSpawnsRemaning;

    Active = VehiclePoolActiveCounts[VehiclePoolIndex];
    MaxActive = VehiclePoolMaxActives[VehiclePoolIndex];
    ReservationCount = VehiclePoolReservationCount[VehiclePoolIndex];
    VehiclePoolSpawnsRemaning = GetVehiclePoolSpawnsRemaining(VehiclePoolIndex);

    return Min(VehiclePoolSpawnsRemaning, (MaxActive - Active) - ReservationCount);
}

function bool ReserveVehicle(DHPlayer PC, int VehiclePoolIndex)
{
    if (PC == none || VehiclePoolIndex != -1 && GetVehicleReservationError(PC, DHRoleInfo(PC.GetRoleInfo()), PC.GetTeamNum(), VehiclePoolIndex) != ERROR_None)
    {
        return false;
    }

    PC.VehiclePoolIndex = VehiclePoolIndex;

    if (VehiclePoolIndex != -1)
    {
        ++VehiclePoolReservationCount[VehiclePoolIndex];
    }

    return true;
}

function UnreserveVehicle(DHPlayer PC)
{
    if (PC.VehiclePoolIndex != -1)
    {
        --VehiclePoolReservationCount[PC.VehiclePoolIndex];
    }

    PC.VehiclePoolIndex = -1;
}

simulated function bool IgnoresMaxTeamVehiclesFlags(int VehiclePoolIndex)
{
    if (VehiclePoolIndex >= 0)
    {
        return (VehiclePoolIgnoreMaxTeamVehiclesFlags & (1 << VehiclePoolIndex)) != 0;
    }

    return false;
}

//------------------------------------------------------------------------------
// Roles
//------------------------------------------------------------------------------

simulated function DHRoleInfo GetRole(int TeamIndex, int RoleIndex)
{
    if (RoleIndex < 0 || RoleIndex >= arraycount(DHAxisRoles))
    {
        return none;
    }

    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            return DHAxisRoles[RoleIndex];
        case ALLIES_TEAM_INDEX:
            return DHAlliesRoles[RoleIndex];
    }

    return none;
}

simulated function int GetDefaultRoleIndexForTeam(byte TeamIndex)
{
    local int i;
    local DHRoleInfo RI;

    if (TeamIndex == AXIS_TEAM_INDEX)
    {
        for (i = 0; i < arraycount(DHAxisRoles); ++i)
        {
            RI = DHAxisRoles[i];

            if (DHAxisRoleLimit[i] == 255 && RI != none && !RI.bRequiresSL && !RI.bRequiresSLorASL)
            {
                return i;
            }
        }
    }
    else if (TeamIndex == ALLIES_TEAM_INDEX)
    {
        for (i = 0; i < arraycount(DHAlliesRoles); ++i)
        {
            RI = DHAlliesRoles[i];

            if (DHAlliesRoleLimit[i] == 255 && RI != none && !RI.bRequiresSL && !RI.bRequiresSLorASL)
            {
                return i;
            }
        }
    }

    return -1;
}

simulated function int GetRoleIndexAndTeam(RORoleInfo RI, optional out byte Team)
{
    local int i;

    for (i = 0; i < arraycount(DHAxisRoles); ++i)
    {
        if (RI == DHAxisRoles[i])
        {
            Team = AXIS_TEAM_INDEX;

            return i;
        }
    }

    for (i = 0; i < arraycount(DHAlliesRoles); ++i)
    {
        if (RI == DHAlliesRoles[i])
        {
            Team = ALLIES_TEAM_INDEX;

            return i;
        }
    }

    Team = NEUTRAL_TEAM_INDEX;

    return -1;
}

simulated function GetRoleCounts(RORoleInfo RI, out int Count, out int BotCount, out int Limit)
{
    local int Index;
    local byte Team;

    Index = GetRoleIndexAndTeam(RI, Team);

    if (Index == -1)
    {
        return;
    }

    switch (Team)
    {
        case AXIS_TEAM_INDEX:
            Limit = DHAxisRoleLimit[Index];
            Count = DHAxisRoleCount[Index];
            BotCount = DHAxisRoleBotCount[Index];
            break;
        case ALLIES_TEAM_INDEX:
            Limit = DHAlliesRoleLimit[Index];
            Count = DHAlliesRoleCount[Index];
            BotCount = DHAlliesRoleBotCount[Index];
            break;
    }
}

//------------------------------------------------------------------------------
// Artillery Functions
//------------------------------------------------------------------------------

simulated function bool IsArtilleryEnabled(int TeamIndex)
{
    return bOffMapArtilleryEnabled[TeamIndex] == 1 || bOffMapArtilleryEnabled[TeamIndex] == 1;
}

function AddArtillery(DHArtillery Artillery)
{
    local int i;

    for (i = 0; i < arraycount(DHArtillery); ++i)
    {
        if (DHArtillery[i] == none)
        {
            DHArtillery[i] = Artillery;
            break;
        }
    }
}

function AddRadio(DHRadio Radio)
{
    local int i;

    for (i = 0; i < arraycount(Radios); ++i)
    {
        if (Radios[i] == none)
        {
            Radios[i] = Radio;
            break;
        }
    }
}

function RemoveRadio(DHRadio Radio)
{
    local int i;

    for (i = 0; i < arraycount(Radios); ++i)
    {
        if (Radios[i] == Radio)
        {
            Radios[i] = none;
        }
    }
}

//------------------------------------------------------------------------------
// Overhead Map Help Request Functions
//------------------------------------------------------------------------------

// Modified to avoid "accessed none" errors on PRI.Team
function AddRallyPoint(PlayerReplicationInfo PRI, vector NewLoc, optional bool bRemoveFromList)
{
    if (PRI != none && PRI.Team != none)
    {
        super.AddRallyPoint(PRI, NewLoc, bRemoveFromList);
    }
}

// Modified to avoid "accessed none" errors on PRI.Team
function AddHelpRequest(PlayerReplicationInfo PRI, int ObjectiveID, int RequestType, optional vector RequestLocation)
{
    if (PRI != none && PRI.Team != none)
    {
        super.AddHelpRequest(PRI, ObjectiveID, RequestType, RequestLocation);
    }
}

// Modified to fix incorrect RequestType used to identify resupply request (was 2, which is a defend objective request - should be 3)
function RemoveMGResupplyRequestFor(PlayerReplicationInfo PRI)
{
    local int i;

    if (PRI == none || PRI.Team == none)
    {
        return;
    }

    // Search request array to see if there's an MG resupply request for this player & clear it if there is
    if (PRI.Team.TeamIndex == AXIS_TEAM_INDEX)
    {
        for (i = 0; i < arraycount(AxisHelpRequests); ++i)
        {
            if (AxisHelpRequests[i].OfficerPRI == PRI && AxisHelpRequests[i].RequestType == 2)
            {
                AxisHelpRequests[i].OfficerPRI = none;
                AxisHelpRequests[i].RequestType = 255;
                break;
            }
        }
    }
    else if (PRI.Team.TeamIndex == ALLIES_TEAM_INDEX)
    {
        for (i = 0; i < arraycount(AlliedHelpRequests); ++i)
        {
            if (AlliedHelpRequests[i].OfficerPRI == PRI && AlliedHelpRequests[i].RequestType == 2)
            {
                AlliedHelpRequests[i].OfficerPRI = none;
                AlliedHelpRequests[i].RequestType = 255;
                break;
            }
        }
    }
}

//------------------------------------------------------------------------------
// Miscellaneous Functions
//------------------------------------------------------------------------------
// New helper function to calculate the round time remaining
// Avoids re-stating this logic in various functionality that display time remaining, e.g. scoreboard, overhead map, deploy screen & spectator HUD
simulated function int GetRoundTimeRemaining()
{
    local int SecondsRemaining;

    if (bMatchHasBegun)
    {
        SecondsRemaining = RoundEndTime - ElapsedTime;

        if (bRoundIsOver)
        {
            SecondsRemaining = RoundOverTime;
        }
    }
    else
    {
        SecondsRemaining = RoundStartTime + PreStartTime - ElapsedTime;
    }

    return Max(0, SecondsRemaining);
}

simulated function string GetTeamScaleString(int Team)
{
   local float     d;
   local int       i;

   if (Team == AXIS_TEAM_INDEX)
   {
       d = (1.0 - CurrentAlliedToAxisRatio) - (1.0 - (1.0 - CurrentAlliedToAxisRatio));
   }

   else if (Team == ALLIES_TEAM_INDEX)
   {
       d = CurrentAlliedToAxisRatio - (1.0 - CurrentAlliedToAxisRatio);
   }

   i = int(Round(d * 100));

   if (i > 0)
   {
       return "+" $ i $ "%";
   }
   else
   {
       return string(i) $ "%";
   }
}

// Modified to allow VoiceID to be greater than 32
simulated function AddPRI(PlayerReplicationInfo PRI)
{
    local byte      NewVoiceID;
    local int       i;

    if (Level.NetMode == NM_ListenServer || Level.NetMode == NM_DedicatedServer)
    {
        for (i = 0; i < PRIArray.Length; ++i)
        {
            if (PRIArray[i].VoiceID == NewVoiceID)
            {
                i = -1;
                ++NewVoiceID;
                continue;
            }
        }

        if (NewVoiceID >= VOICEID_MAX)
        {
            NewVoiceID = 0;
        }

        PRI.VoiceID = NewVoiceID;
    }

    PRIArray[PRIArray.Length] = PRI;
}

simulated function int GetTankReservationCount(int TeamIndex)
{
    local int i, Count;

    for (i = 0; i < arraycount(VehiclePoolReservationCount); ++i)
    {
        if (VehiclePoolVehicleClasses[i] != none &&
            VehiclePoolVehicleClasses[i].default.VehicleTeam == TeamIndex &&
            !IgnoresMaxTeamVehiclesFlags(i))
        {
            Count += VehiclePoolReservationCount[i];
        }
    }

    return Count;
}

simulated function int GetReservableTankCount(int TeamIndex)
{
    return MaxTeamVehicles[TeamIndex] - GetTankReservationCount(TeamIndex);
}

simulated function EVehicleReservationError GetVehicleReservationError(DHPlayer PC, DHRoleInfo RI, int TeamIndex, int VehiclePoolIndex)
{
    local class<DHVehicle> VC;

    VC = class<DHVehicle>(GetVehiclePoolVehicleClass(VehiclePoolIndex));

    if (PC == none || RI == none || VC == none || (TeamIndex != AXIS_TEAM_INDEX && TeamIndex != ALLIES_TEAM_INDEX) || (PC.Pawn != none && PC.Pawn.Health > 0) || VC.default.VehicleTeam != RI.Side)
    {
        return ERROR_Fatal;
    }

    if (!RI.default.bCanBeTankCrew && VC.default.bMustBeTankCommander)
    {
        return ERROR_InvalidCredentials;
    }

    if (GetVehiclePoolSpawnsRemaining(VehiclePoolIndex) <= 0)
    {
        return ERROR_PoolOutOfSpawns;
    }

    if (!IsVehiclePoolActive(VehiclePoolIndex))
    {
        return ERROR_PoolInactive;
    }

    if (VehiclePoolActiveCounts[VehiclePoolIndex] >= VehiclePoolMaxActives[VehiclePoolIndex])
    {
        return ERROR_PoolMaxActive;
    }

    if (GetVehiclePoolAvailableReservationCount(VehiclePoolIndex) <= 0)
    {
        return ERROR_NoReservations;
    }

    if (VC.default.bRequiresDriverLicense && !DHPlayerReplicationInfo(PC.PlayerReplicationInfo).IsPlayerLicensedToDrive(PC))
    {
        return ERROR_NoLicense;
    }

    if (!IgnoresMaxTeamVehiclesFlags(VehiclePoolIndex) && GetReservableTankCount(TeamIndex) <= 0)
    {
        return ERROR_TeamMaxActive;
    }

    return ERROR_None;
}

// Overridden to undo the exclusion of players who hadn't yet selected a role.
simulated function GetTeamSizes(out int TeamSizes[2])
{
    local int i;
    local PlayerReplicationInfo PRI;

    TeamSizes[AXIS_TEAM_INDEX] = 0;
    TeamSizes[ALLIES_TEAM_INDEX] = 0;

    for (i = 0; i < PRIArray.Length; ++i)
    {
        PRI = PRIArray[i];

        if (PRI != none &&
            PRI.Team != none &&
            (PRI.Team.TeamIndex == AXIS_TEAM_INDEX || PRI.Team.TeamIndex == ALLIES_TEAM_INDEX))
        {
            ++TeamSizes[PRI.Team.TeamIndex];
        }
    }
}

simulated function bool IsPlayerCountInRange(int Floor, int Ceiling)
{
    local int PlayerCount;

    PlayerCount = Min(PRIArray.Length, MaxPlayers);
    return PlayerCount >= Floor && PlayerCount <= Ceiling;
}

//==============================================================================
// MAP MARKERS
//==============================================================================

simulated function bool GetMapMarker(int TeamIndex, int MapMarkerIndex, optional out MapMarker MapMarker)
{
    local DHGameReplicationInfo.MapMarker MM;

    if (MapMarkerIndex < 0 || MapMarkerIndex >= MAP_MARKERS_MAX)
    {
        return false;
    }

    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            MM = AxisMapMarkers[MapMarkerIndex];
            break;
        case ALLIES_TEAM_INDEX:
            MM = AlliesMapMarkers[MapMarkerIndex];
            break;
        default:
            return false;
    }

    if (MM.MapMarkerClass == none || IsMapMarkerExpired(MM))
    {
        return false;
    }

    MapMarker = MM;

    return true;
}

// Trying to refactor this function to access AxisMapMarkers and AlliesMapMarkers directly from other objects
// will most likely cause "Context expression: Variable is too large (480 bytes, 255 max)" compilation error.
// You can't access big static arrays of structs from outside of the given object; you have to
// use a proxy function like this one to retrive elements of a static array as a dynamic array.
simulated function array<MapMarker> GetMapMarkers(DHPlayer PC)
{
    local int i;
    local array<MapMarker> MapMarkers;

    switch (PC.GetTeamNum())
    {
        case AXIS_TEAM_INDEX:
            for (i = 0; i < arraycount(AxisMapMarkers); ++i)
            {
                MapMarkers[MapMarkers.Length] = AxisMapMarkers[i];
            }
            break;
        case ALLIES_TEAM_INDEX:
            for (i = 0; i < arraycount(AlliesMapMarkers); ++i)
            {
                MapMarkers[MapMarkers.Length] = AlliesMapMarkers[i];
            }
            break;
        default:
            break;
    }

    return MapMarkers;
}

simulated function array<MapMarker> GetFireSupportMapMarkersAtLocation(DHPlayer PC, vector WorldLocation)
{
    local int i;
    local array<MapMarker> MapMarkers;
    local float Distance, DistanceThreshold;

    DistanceThreshold = class'DHUnits'.static.MetersToUnreal(class'DHMapMarker_ArtilleryHit'.default.VisibilityRange);

    MapMarkers = GetMapMarkers(PC);

    for (i = MapMarkers.Length - 1; i >= 0; --i)
    {
        Distance = VSize(MapMarkers[i].WorldLocation - WorldLocation);

        if (IsMapMarkerExpired(MapMarkers[i]) ||
            MapMarkers[i].MapMarkerClass == none ||
            MapMarkers[i].MapMarkerClass.default.Type != MT_OnMapArtilleryRequest ||
            Distance > DistanceThreshold)
        {
            MapMarkers.Remove(i, 1);
            continue;
        }
    }

    return MapMarkers;
}

simulated function bool IsMapMarkerExpired(MapMarker MM)
{
    return MM.ExpiryTime != -1 && MM.ExpiryTime <= ElapsedTime;
}

simulated function GetGlobalArtilleryMapMarkers(DHPlayer PC, out array<MapMarker> MapMarkers)
{
    local int i;
    local DHPlayerReplicationInfo PRI;
    local MapMarker Marker;
    local bool bIsArtillerySpotter;

    if (PC == none)
    {
        return;
    }

    PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);

    if (PRI == none)
    {
        return;
    }

    bIsArtillerySpotter = PRI.IsArtillerySpotter();

    switch (PC.GetTeamNum())
    {
        case AXIS_TEAM_INDEX:
            for (i = 0; i < arraycount(AxisMapMarkers); ++i)
            {
                Marker = AxisMapMarkers[i];

                if (!IsMapMarkerExpired(Marker)
                    && Marker.MapMarkerClass != none
                    && Marker.MapMarkerClass.static.CanSeeMarker(PRI, Marker)
                    && Marker.MapMarkerClass.default.Type == MT_OnMapArtilleryRequest
                    && !(bIsArtillerySpotter && Marker.SquadIndex == PRI.SquadIndex))
                {
                    MapMarkers[MapMarkers.Length] = Marker;
                }
            }
            break;
        case ALLIES_TEAM_INDEX:
            for (i = 0; i < arraycount(AlliesMapMarkers); ++i)
            {
                Marker = AlliesMapMarkers[i];

                if (!IsMapMarkerExpired(Marker)
                    && Marker.MapMarkerClass != none
                    && Marker.MapMarkerClass.static.CanSeeMarker(PRI, Marker)
                    && Marker.MapMarkerClass.default.Type == MT_OnMapArtilleryRequest
                    && !(bIsArtillerySpotter && Marker.SquadIndex == PRI.SquadIndex))
                {
                    MapMarkers[MapMarkers.Length] = Marker;
                }
            }
            break;
        default:
            break;
    }
}

function int AddMapMarker(DHPlayerReplicationInfo PRI, class<DHMapMarker> MapMarkerClass, vector MapLocation, vector WorldLocation)
{
    local int i;
    local MapMarker M;

    if (PRI == none || PRI.Team == none || MapMarkerClass == none || !MapMarkerClass.static.CanBeUsed(self) || !MapMarkerClass.static.CanPlaceMarker(PRI))
    {
        return -1;
    }

    M.Author = PRI;
    M.MapMarkerClass = MapMarkerClass;
    M.CreationTime = ElapsedTime;

    // Quantize map-space coordinates for transmission.
    M.LocationX = byte(255.0 * FClamp(MapLocation.X, 0.0, 1.0));
    M.LocationY = byte(255.0 * FClamp(MapLocation.Y, 0.0, 1.0));
    M.WorldLocation = WorldLocation;

    M.SquadIndex = PRI.SquadIndex;

    if (MapMarkerClass.default.LifetimeSeconds != -1)
    {
        M.ExpiryTime = ElapsedTime + MapMarkerClass.default.LifetimeSeconds;
    }
    else
    {
        M.ExpiryTime = -1;
    }

    switch (PRI.Team.TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            switch (MapMarkerClass.default.OverwritingRule)
            {
                case UNIQUE_PER_GROUP:
                    for (i = 0; i < arraycount(AxisMapMarkers); ++i)
                    {
                        if (AxisMapMarkers[i].MapMarkerClass != none
                          && AxisMapMarkers[i].MapMarkerClass.default.GroupIndex == MapMarkerClass.default.GroupIndex
                          && (MapMarkerClass.default.Scope == SQUAD && AxisMapMarkers[i].SquadIndex == PRI.SquadIndex)
                            || MapMarkerClass.default.Scope == TEAM)
                        {
                            AxisMapMarkers[i] = M;
                            MapMarkerClass.static.OnMapMarkerPlaced(DHPlayer(PRI.Owner), M);
                            return i;
                        }
                    }
                    break;

                case UNIQUE:
                    for (i = 0; i < arraycount(AxisMapMarkers); ++i)
                    {
                        if (AxisMapMarkers[i].MapMarkerClass == MapMarkerClass
                          && (MapMarkerClass.default.Scope == SQUAD && AxisMapMarkers[i].SquadIndex == PRI.SquadIndex)
                            || MapMarkerClass.default.Scope == TEAM)
                        {
                            AxisMapMarkers[i] = M;
                            MapMarkerClass.static.OnMapMarkerPlaced(DHPlayer(PRI.Owner), M);
                            return i;
                        }
                    }
                    break;
                case OFF:
                    break;
            }
            for (i = 0; i < arraycount(AxisMapMarkers); ++i)
            {
                if (AxisMapMarkers[i].MapMarkerClass == none || IsMapMarkerExpired(AxisMapMarkers[i]))
                {
                    AxisMapMarkers[i] = M;
                    MapMarkerClass.static.OnMapMarkerPlaced(DHPlayer(PRI.Owner), M);
                    return i;
                }
            }
            break;
        case ALLIES_TEAM_INDEX:
            switch (MapMarkerClass.default.OverwritingRule)
            {
                case UNIQUE_PER_GROUP:
                    for (i = 0; i < arraycount(AlliesMapMarkers); ++i)
                    {
                        if (AlliesMapMarkers[i].MapMarkerClass != none &&
                            AlliesMapMarkers[i].MapMarkerClass.default.GroupIndex == MapMarkerClass.default.GroupIndex
                            && (MapMarkerClass.default.Scope == SQUAD && AlliesMapMarkers[i].SquadIndex == PRI.SquadIndex)
                            || MapMarkerClass.default.Scope == TEAM)
                        {
                            AlliesMapMarkers[i] = M;
                            MapMarkerClass.static.OnMapMarkerPlaced(DHPlayer(PRI.Owner), M);
                            return i;
                        }
                    }
                    break;
                case UNIQUE:
                    for (i = 0; i < arraycount(AlliesMapMarkers); ++i)
                    {
                        if (AlliesMapMarkers[i].MapMarkerClass == MapMarkerClass
                          && (MapMarkerClass.default.Scope == TEAM
                          || (MapMarkerClass.default.Scope == SQUAD && AlliesMapMarkers[i].SquadIndex == PRI.SquadIndex)))
                        {
                            AlliesMapMarkers[i] = M;
                            MapMarkerClass.static.OnMapMarkerPlaced(DHPlayer(PRI.Owner), M);
                            return i;
                        }
                    }
                    break;
                case OFF:
                        break;
            }
            for (i = 0; i < arraycount(AlliesMapMarkers); ++i)
            {
                if (AlliesMapMarkers[i].MapMarkerClass == none || IsMapMarkerExpired(AlliesMapMarkers[i]))
                {
                    AlliesMapMarkers[i] = M;
                    MapMarkerClass.static.OnMapMarkerPlaced(DHPlayer(PRI.Owner), M);
                    return i;
                }
            }
    }

    return -1;
}

function RemoveMapMarker(int TeamIndex, int MapMarkerIndex)
{
    if (MapMarkerIndex < 0 || MapMarkerIndex >= MAP_MARKERS_MAX)
    {
        return;
    }

    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            AxisMapMarkers[MapMarkerIndex].MapMarkerClass = none;
            break;
        case ALLIES_TEAM_INDEX:
            AlliesMapMarkers[MapMarkerIndex].MapMarkerClass = none;
            break;
        default:
            break;
    }
}

function ClearSquadMapMarkers(int TeamIndex, int SquadIndex)
{
    local int i;

    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            for (i = 0; i < arraycount(AxisMapMarkers); ++i)
            {
                if (AxisMapMarkers[i].SquadIndex == SquadIndex)
                {
                    AxisMapMarkers[i].MapMarkerClass = none;
                }
            }
            break;
        case ALLIES_TEAM_INDEX:
            for (i = 0; i < arraycount(AlliesMapMarkers); ++i)
            {
                if (AlliesMapMarkers[i].SquadIndex == SquadIndex)
                {
                    AlliesMapMarkers[i].MapMarkerClass = none;
                }
            }
            break;
    }
}

// This is stupid, but for now
// there can only be 1 active off-map artillery strike anyway
function InvalidateOngoingBarrageMarker(int TeamIndex)
{
    local int i;

    switch (TeamIndex)
    {
        case ALLIES_TEAM_INDEX:
            for (i = 0; i < arraycount(AlliesMapMarkers); i++)
            {
                if (AlliesMapMarkers[i].MapMarkerClass != none
                  && AlliesMapMarkers[i].MapMarkerClass.default.Type == MT_ArtilleryBarrage)
                {
                    AlliesMapMarkers[i].ExpiryTime = 0;
                }
            }
            break;
        case AXIS_TEAM_INDEX:
            for (i = 0; i < arraycount(AxisMapMarkers); i++)
            {
                if (AxisMapMarkers[i].MapMarkerClass != none
                  && AxisMapMarkers[i].MapMarkerClass.default.Type == MT_ArtilleryBarrage)
                {
                    AxisMapMarkers[i].ExpiryTime = 0;
                }
            }
            break;
    }
}

function ClearMapMarkers()
{
    local int i;

    for (i = 0; i < arraycount(AxisMapMarkers); ++i)
    {
        AxisMapMarkers[i].MapMarkerClass = none;
    }

    for (i = 0; i < arraycount(AlliesMapMarkers); ++i)
    {
        AlliesMapMarkers[i].MapMarkerClass = none;
    }
}

simulated function float GetMapIconYaw(float WorldYaw)
{
    local float MapIconYaw;

    MapIconYaw = -WorldYaw;

    switch (OverheadOffset)
    {
        case 90:
            MapIconYaw -= 32768;
            break;

        case 180:
            MapIconYaw -= 49152;
            break;

        case 270:
            break;

        default:
            MapIconYaw -= 16384;
    }

    return MapIconYaw;
}

// Gets the map coordindates (0..1) from a world location.
simulated function GetMapCoords(vector WorldLocation, out float X, out float Y, optional float Width, optional float Height)
{
    local float  MapScale;
    local vector MapCenter;

    MapScale = FMax(1.0, Abs((SouthWestBounds - NorthEastBounds).X));
    MapCenter = NorthEastBounds + ((SouthWestBounds - NorthEastBounds) * 0.5);
    WorldLocation = GetAdjustedHudLocation(WorldLocation - MapCenter, false);

    X = 1.0 - FClamp(0.5 + (WorldLocation.X / MapScale) - (Width / 2),
                     0.0,
                     1.0 - Width);

    Y = 1.0 - FClamp(0.5 + (WorldLocation.Y / MapScale) - (Height / 2),
                     0.0,
                     1.0 - Height);
}

// Gets the world location from map coordinates.
simulated function vector GetWorldCoords(float X, float Y)
{
    local float MapScale;
    local vector MapCenter, WorldLocation;

    MapScale = FMax(1.0, Abs((SouthWestBounds - NorthEastBounds).X));
    MapCenter = NorthEastBounds + ((SouthWestBounds - NorthEastBounds) * 0.5);
    WorldLocation.X = (0.5 - X) * MapScale;
    WorldLocation.Y = (0.5 - Y) * MapScale;
    WorldLocation = GetAdjustedHudLocation(WorldLocation, true);
    WorldLocation += MapCenter;

    return WorldLocation;
}

// This function will adjust a hud map location based on the rotation offset of
// the overhead map.
// NOTE: This is functionally identical to same function in ROHud. It has been
// moved here because it had no business being in that class since it only
// referenced things in the GRI class.
simulated function vector GetAdjustedHudLocation(vector HudLoc, optional bool bInvert)
{
    local float SwapX, SwapY;
    local int Offset;

    Offset = OverheadOffset;

    if (bInvert)
    {
        if (OverheadOffset == 90)
        {
            Offset = 270;
        }
        else if (OverheadOffset == 270)
        {
            Offset = 90;
        }
    }

    if (Offset == 90)
    {
        SwapX = HudLoc.Y * -1;
        SwapY = HudLoc.X;
        HudLoc.X = SwapX;
        HudLoc.Y = SwapY;
    }
    else if (Offset == 180)
    {
        SwapX = HudLoc.X * -1;
        SwapY = HudLoc.Y * -1;
        HudLoc.X = SwapX;
        HudLoc.Y = SwapY;
    }
    else if (Offset == 270)
    {
        SwapX = HudLoc.Y;
        SwapY = HudLoc.X * -1;
        HudLoc.X = SwapX;
        HudLoc.Y = SwapY;
    }

    return HudLoc;
}

simulated function EArtilleryTypeError GetArtilleryTypeError(DHPlayer PC, int ArtilleryTypeIndex)
{
    local ArtilleryTypeInfo ATI;
    local DH_LevelInfo LI;
    local class<DHArtillery> ArtilleryClass;

    LI = class'DH_LevelInfo'.static.GetInstance(Level);

    if (PC == none || LI == none ||
        ArtilleryTypeIndex < 0 ||
        ArtilleryTypeIndex >= arraycount(ArtilleryTypeInfos) ||
        LI.ArtilleryTypes[ArtilleryTypeIndex].ArtilleryClass == none ||
        LI.ArtilleryTypes[ArtilleryTypeIndex].TeamIndex != PC.GetTeamNum())
    {
        return ERROR_Fatal;
    }

    ArtilleryClass = LI.ArtilleryTypes[ArtilleryTypeIndex].ArtilleryClass;

    if (!ArtilleryClass.static.HasQualificationToRequest(PC))
    {
        return ERROR_Unqualified;
    }

    if (!ArtilleryClass.static.HasEnoughSquadMembersToRequest(PC))
    {
        return ERROR_NotEnoughSquadMembers;
    }

    ATI = ArtilleryTypeInfos[ArtilleryTypeIndex];

    if (!ATI.bIsAvailable)
    {
        return ERROR_Unavailable;
    }
    else if (ATI.ArtilleryActor != none)
    {
        if (ATI.ArtilleryActor.bCanBeCancelled && PC == ATI.ArtilleryActor.Requester)
        {
            return ERROR_Cancellable;
        }
        else
        {
            return ERROR_Ongoing;
        }
    }
    else if (ATI.UsedCount >= ATI.Limit)
    {
        return ERROR_Exhausted;
    }
    else if (ElapsedTime < ATI.NextConfirmElapsedTime)
    {
        return ERROR_Cooldown;
    }

    return ERROR_None;
}

function UpdateMapIconAttachments()
{
    local DHMapIconAttachment MIA;

    foreach AllActors(class'DHMapIconAttachment', MIA)
    {
        if (MIA != none && !MIA.bIgnoreGRIUpdates)
        {
            MIA.Updated();
        }
    }
}

//==============================================================================
// DANGER ZONE
//==============================================================================

function SetDangerZoneEnabled(bool bEnabled, optional bool bPostponeUpdate)
{
    bIsDangerZoneEnabled = bEnabled;

    if (!bPostponeUpdate)
    {
        DangerZoneUpdated();
    }
}

function SetDangerZoneNeutral(byte Factor, optional bool bPostponeUpdate)
{
    DangerZoneNeutral = Factor;

    if (!bPostponeUpdate)
    {
        DangerZoneUpdated();
    }
}

function SetDangerZoneBalance(int Factor, optional bool bPostponeUpdate)
{
    DangerZoneBalance = 128 - Clamp(Factor, -127, 127);

    if (!bPostponeUpdate)
    {
        DangerZoneUpdated();
    }
}

simulated function bool IsDangerZoneEnabled()
{
    return bIsDangerZoneEnabled;
}

simulated function byte GetDangerZoneNeutral()
{
    return DangerZoneNeutral;
}

simulated function byte GetDangerZoneBalance()
{
    return DangerZoneBalance;
}

simulated function float GetDangerZoneIntensity(float PointerX, float PointerY, byte TeamIndex)
{
    return class'DHDangerZone'.static.GetIntensity(self, PointerX, PointerY, TeamIndex);
}

simulated function bool IsInDangerZone(float PointerX, float PointerY, byte TeamIndex)
{
    return class'DHDangerZone'.static.IsIn(self, PointerX, PointerY, TeamIndex);
}

simulated function bool IsInFriendlyZone(float PointerX, float PointerY, byte TeamIndex)
{
    return IsInDangerZone(PointerX, PointerY, int(!bool(TeamIndex)));
}

simulated function DangerZoneUpdated()
{
    local DHSquadReplicationInfo SRI;
    local DHPlayer PC;
    local DHHud Hud;

    // Server
    if (Role == ROLE_Authority)
    {
        SRI = DarkestHourGame(Level.Game).SquadReplicationInfo;

        if (SRI != none)
        {
            SRI.UpdateRallyPoints();
        }

        UpdateMapIconAttachments();
    }

    // Client
    if (Role < ROLE_Authority || Level.NetMode == NM_Standalone)
    {
        // Notify HUD
        PC = DHPlayer(Level.GetLocalPlayerController());

        if (PC != none)
        {
            Hud = DHHud(PC.myHUD);

            if (Hud != none)
            {
                Hud.DangerZoneOverlayUpdateRequest();
            }
        }
    }
}

//==============================================================================
// SURRENDER VOTE
//==============================================================================

simulated function bool IsSurrenderVoteInProgress(byte TeamIndex)
{
    if (TeamIndex < arraycount(SurrenderVotesInProgress))
    {
        return bool(SurrenderVotesInProgress[TeamIndex]);
    }
}

function SetSurrenderVoteInProgress(byte TeamIndex, bool bInProgress)
{
    if (TeamIndex < arraycount(SurrenderVotesInProgress))
    {
        SurrenderVotesInProgress[TeamIndex] = byte(bInProgress);
    }
}

//==============================================================================
// MINE & NO ARTY VOLUMES
//==============================================================================

function RegisterMineVolumes()
{
    local DHMineVolume MV;
    local int Index;

    if (Role != ROLE_Authority)
    {
        return;
    }

    foreach AllActors(class'DHMineVolume', MV)
    {
        if (Index >= MINE_VOLUMES_MAX)
        {
            Warn("Too many mine volumes! Only" @ MINE_VOLUMES_MAX @ "minefield activation states can be tracked at once.");
        }

        MV.Index = Index++;
    }
}

simulated function RegisterNoArtyVolumes()
{
    local RONoArtyVolume NAV;

    DHNoArtyVolumes.Length = 0;

    foreach AllActors(class'RONoArtyVolume', NAV)
    {
        DHNoArtyVolumes[DHNoArtyVolumes.Length] = NAV;
    }
}

// This was, at one point, inside the DHVolumeTest, but in order to make
// client-side polling possible, we have to update the statuses here and
// replicate the "active" status to all clients.
function UpdateNoArtyVolumeStatuses()
{
    local int i;
    local DHSpawnPoint SP;
    local DHObjective O;
    local byte bIsActive;

    for (i = 0; i < DHNoArtyVolumes.Length; ++i)
    {
        SP = DHSpawnPoint(DHNoArtyVolumes[i].AssociatedActor);
        O = DHObjective(DHNoArtyVolumes[i].AssociatedActor);

        bIsActive = 0;

        if (SP != none)
        {
            if (SP.IsActive())
            {
                bIsActive = 1;
            }
        }
        else if (O != none)
        {
            if (O.IsActive())
            {
                bIsActive = 1;
            }
        }
        else
        {
            bIsActive = 1;
        }

        DHNoArtyVolumeIsActives[i] = bIsActive;
    }
}

simulated function bool IsMineVolumeActive(DHMineVolume MineVolume)
{
    if (MineVolume == none || MineVolume.Index < 0 || MineVolume.Index >= MINE_VOLUMES_MAX)
    {
        return false;
    }

    return DHMineVolumeIsActives[MineVolume.Index] == 1;
}

simulated function bool IsNoArtyVolumeActive(RONoArtyVolume NoArtyVolume)
{
    local int i;

    for (i = 0; i < DHNoArtyVolumes.Length; ++i)
    {
        if (NoArtyVolume == DHNoArtyVolumes[i])
        {
            return DHNoArtyVolumeIsActives[i] == 1;
        }
    }

    return false;
}

simulated function array<SAvailableArtilleryInfoEntry> GetTeamOffMapFireSupportCountRemaining(int TeamIndex)
{
    local int i, ArtilleryCount, ParadropCount, AirstrikesCount;
    local DH_LevelInfo LI;
    local array<SAvailableArtilleryInfoEntry> Result;
    local SAvailableArtilleryInfoEntry Entry;

    LI = class'DH_LevelInfo'.static.GetInstance(Level);

    if (LI == none)
    {
        return Result;
    }

    for (i = 0; i < LI.ArtilleryTypes.Length; ++i)
    {
        if (LI.ArtilleryTypes[i].TeamIndex == TeamIndex && ArtilleryTypeInfos[i].bIsAvailable)
        {
            switch(LI.ArtilleryTypes[i].ArtilleryClass.default.ArtilleryType)
            {
                case ArtyType_Barrage:
                    ArtilleryCount += ArtilleryTypeInfos[i].Limit - ArtilleryTypeInfos[i].UsedCount;
                    break;
                case ArtyType_Paradrop:
                    ParadropCount += ArtilleryTypeInfos[i].Limit - ArtilleryTypeInfos[i].UsedCount;
                    break;
                case ArtyType_Airstrikes:
                    AirstrikesCount += ArtilleryTypeInfos[i].Limit - ArtilleryTypeInfos[i].UsedCount;
                    break;
            }
        }
    }

    if (ArtilleryCount > 0)
    {
        Entry.Type = ArtyType_Barrage;
        Entry.Count = ArtilleryCount;
        Result[Result.Length] = Entry;
    }

    if (ParadropCount > 0)
    {
        Entry.Type = ArtyType_Paradrop;
        Entry.Count = ParadropCount;
        Result[Result.Length] = Entry;
    }

    if (AirstrikesCount > 0)
    {
        Entry.Type = ArtyType_Airstrikes;
        Entry.Count = AirstrikesCount;
        Result[Result.Length] = Entry;
    }

    return Result;
}

function AddKillForTeam(int TeamIndex)
{
    if (TeamIndex >= 0 && TeamIndex < arraycount(TeamScores))
    {
        ++TeamScores[TeamIndex].Kills;
    }
}

function AddDeathForTeam(int TeamIndex)
{
    if (TeamIndex >= 0 && TeamIndex < arraycount(TeamScores))
    {
        ++TeamScores[TeamIndex].Deaths;
    }
}

function ResetTeamScores()
{
    local int i, j;

    for (i = 0; i < arraycount(TeamScores); ++i)
    {
        TeamScores[i].Kills = 0;
        TeamScores[i].Deaths = 0;

        for (j = 0; j < arraycount(TeamScores[i].CategoryScores); ++j)
        {
            TeamScores[i].CategoryScores[j] = 0;
        }
    }
}

defaultproperties
{
    bNetNotify=true
    bAllChatEnabled=true
    AlliesVictoryMusicIndex=-1
    AxisVictoryMusicIndex=-1
    ForceScaleText="Size"
    ReinforcementsInfiniteText="Infinite"
    RoundWinnerTeamIndex=255

    // Constructions

    // Logistics
    ConstructionClassNames(0)="DH_Construction.DHConstruction_SupplyCache"
    ConstructionClassNames(1)="DH_Construction.DHConstruction_PlatoonHQ"
    ConstructionClassNames(2)="DH_Construction.DHConstruction_Resupply_Players"
    ConstructionClassNames(3)="DH_Construction.DHConstruction_Resupply_Vehicles"
    ConstructionClassNames(4)="DH_Construction.DHConstruction_VehiclePool"

    // Obstacles
    ConstructionClassNames(5)="DH_Construction.DHConstruction_ConcertinaWire"
    ConstructionClassNames(6)="DH_Construction.DHConstruction_Hedgehog"

    // Guns
    ConstructionClassNames(7)="DH_Construction.DHConstruction_ATGun_Light"
    ConstructionClassNames(8)="DH_Construction.DHConstruction_ATGun_Medium"
    ConstructionClassNames(9)="DH_Construction.DHConstruction_ATGun_Heavy"
    ConstructionClassNames(10)="DH_Construction.DHConstruction_ATGun_HeavyTwo"
    ConstructionClassNames(11)="DH_Construction.DHConstruction_ATGun_HeavyEarly"
    ConstructionClassNames(12)="DH_Construction.DHConstruction_AAGun_Light"
    ConstructionClassNames(13)="DH_Construction.DHConstruction_AAGun_Medium"

    // Defenses
    ConstructionClassNames(14)="DH_Construction.DHConstruction_Foxhole"
    ConstructionClassNames(15)="DH_Construction.DHConstruction_Sandbags_Line"
    ConstructionClassNames(16)="DH_Construction.DHConstruction_Sandbags_Crescent"
    ConstructionClassNames(17)="DH_Construction.DHConstruction_Sandbags_Bunker"
    ConstructionClassNames(18)="DH_Construction.DHConstruction_GrenadeCrate"
    ConstructionClassNames(19)="DH_Construction.DHConstruction_DragonsTooth"
    ConstructionClassNames(20)="DH_Construction.DHConstruction_AntiTankCrate"

    // Artillery
    ConstructionClassNames(22)="DH_Construction.DHConstruction_Artillery"

    // Map Markers
    MapMarkerClassNames(0)="DH_Engine.DHMapMarker_Squad_Move"
    MapMarkerClassNames(1)="DH_Engine.DHMapMarker_Squad_Attack"
    MapMarkerClassNames(2)="DH_Engine.DHMapMarker_Squad_Defend"
    MapMarkerClassNames(3)="DH_Engine.DHMapMarker_Squad_Attention"
    MapMarkerClassNames(4)="DH_Engine.DHMapMarker_Enemy_PlatoonHQ"
    MapMarkerClassNames(5)="DH_Engine.DHMapMarker_Enemy_Infantry"
    MapMarkerClassNameS(6)="DH_Engine.DHMapMarker_Enemy_Vehicle"
    MapMarkerClassNames(7)="DH_Engine.DHMapMarker_Enemy_Tank"
    MapMarkerClassNames(8)="DH_Engine.DHMapMarker_Enemy_ATGun"
    MapMarkerClassNames(9)="DH_Engine.DHMapMarker_Friendly_PlatoonHQ"
    MapMarkerClassNames(10)="DH_Engine.DHMapMarker_Friendly_Supplies"

    // Danger Zone
    // The actual defaults reside in DH_LevelInfo. These are fallbacks in
    // case we fail to retrieve those values.
    DangerZoneNeutral=128
    DangerZoneBalance=128
}
