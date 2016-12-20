//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHGameReplicationInfo extends ROGameReplicationInfo;

struct MortarTarget
{
    var bool                    bIsActive;
    var DHPlayer                Controller;
    var byte                    TeamIndex;
    var vector                  Location;
    var vector                  HitLocation;
    var float                   Time;
    var bool                    bIsSmoke;
};

struct SpawnVehicle
{
    var int             VehiclePoolIndex;
    var Vehicle         Vehicle;
    var int             LocationX;
    var int             LocationY;
    var byte            BlockFlags;
};

const RADIOS_MAX = 10;

var string              CurrentGameType;

var ROArtilleryTrigger  CarriedAlliedRadios[RADIOS_MAX];
var ROArtilleryTrigger  CarriedAxisRadios[RADIOS_MAX];

var int                 AlliedNationID;
var int                 AlliesVictoryMusicIndex;
var int                 AxisVictoryMusicIndex;

var int                 RoundEndTime;  // Length of a round in seconds (this can be modified at real time unlike RoundDuration, which it replaces)

const ROLES_MAX = 16;

var DHRoleInfo          DHAxisRoles[ROLES_MAX];
var DHRoleInfo          DHAlliesRoles[ROLES_MAX];

var byte                DHAlliesRoleLimit[ROLES_MAX];
var byte                DHAlliesRoleBotCount[ROLES_MAX];
var byte                DHAlliesRoleCount[ROLES_MAX];
var byte                DHAxisRoleLimit[ROLES_MAX];
var byte                DHAxisRoleBotCount[ROLES_MAX];
var byte                DHAxisRoleCount[ROLES_MAX];

const MORTAR_TARGETS_MAX = 2;

// Colin: The maximum distance a mortar strike can be away from a marked target
// for a hit indicator to show on the map
var float MortarTargetDistanceThreshold;

var MortarTarget        AlliedMortarTargets[MORTAR_TARGETS_MAX];
var MortarTarget        GermanMortarTargets[MORTAR_TARGETS_MAX];

var int                 SpawnsRemaining[2];
var float               AttritionRate[2];
var float               CurrentAlliedToAxisRatio;

// Vehicle pool and spawn point info is heavily fragmented due to the arbitrary variable size limit (255 bytes) that exists in UnrealScript
const VEHICLE_POOLS_MAX = 32;

//TODO: vehicle classes should have been made available in static data for client and server to read
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

var byte                MaxTeamVehicles[2];

const SPAWN_POINTS_MAX = 48;

var DHSpawnPoint        SpawnPoints[SPAWN_POINTS_MAX];
var private byte        SpawnPointIsActives[SPAWN_POINTS_MAX];

const SPAWN_VEHICLES_MAX = 8;

var SpawnVehicle        SpawnVehicles[SPAWN_VEHICLES_MAX];

const OBJECTIVES_MAX = 32;

var DHObjective         DHObjectives[OBJECTIVES_MAX];

var bool                bUseDeathPenaltyCount;

var localized string    ForceScaleText;
var localized string    ReinforcementsInfiniteText;
var localized string    DeathPenaltyText;

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
        CarriedAlliedRadios,
        CarriedAxisRadios,
        AlliedMortarTargets,
        GermanMortarTargets,
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
        SpawnPointIsActives,
        SpawnVehicles,
        MaxTeamVehicles,
        DHObjectives,
        AttritionRate,
        bUseDeathPenaltyCount,
        CurrentGameType,
        CurrentAlliedToAxisRatio;

    reliable if (bNetInitial && (Role == ROLE_Authority))
        AlliedNationID, AlliesVictoryMusicIndex, AxisVictoryMusicIndex;
}

// Modified to build SpawnPoints array
// Also to nullify all water splash effects in WaterVolumes & FluidSurfaceInfos, as they clash with splash effects in projectile classes that are more specific to the projectile
// Another problem is a big splash effect was being played for every ejected bullet shell case that hit water, looking totally wrong for such a small, relatively slow object
simulated function PostBeginPlay()
{
    local DHSpawnPoint     SP;
    local WaterVolume      WV;
    local FluidSurfaceInfo FSI;
    local int              i;

    super.PostBeginPlay();

    foreach AllActors(class'DHSpawnPoint', SP)
    {
        if (i >= SPAWN_POINTS_MAX)
        {
            Warn("Number of DHSpawnPoint actors exceeds" @ SPAWN_POINTS_MAX @ ", some spawn points will be ignored!");

            break;
        }

        SpawnPoints[i++] = SP;
    }

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
        FSI.TouchEffect = none;
    }
}

simulated event Timer()
{
    local int i;

    super.Timer();

    if (Role == ROLE_Authority)
    {
        for (i = 0; i < arraycount(SpawnVehicles); ++i)
        {
            if (SpawnVehicles[i].Vehicle != none)
            {
                SpawnVehicles[i].LocationX = SpawnVehicles[i].Vehicle.Location.X;
                SpawnVehicles[i].LocationY = SpawnVehicles[i].Vehicle.Location.Y;
            }
        }
    }
}

//------------------------------------------------------------------------------
// Spawn Point Functions
//------------------------------------------------------------------------------

simulated function bool IsSpawnPointIndexActive(byte SpawnPointIndex)
{
    return SpawnPointIsActives[SpawnPointIndex] != 0;
}

simulated function bool IsSpawnPointActive(DHSpawnPoint SP)
{
    return IsSpawnPointIndexActive(GetSpawnPointIndex(SP));
}

function SetSpawnPointIsActive(byte SpawnPointIndex, bool bIsActive)
{
    local Controller C;
    local DHPlayer PC;

    SpawnPointIsActives[SpawnPointIndex] = byte(bIsActive);

    if (!bIsActive)
    {
        for (C = Level.ControllerList; C != none; C = C.NextController)
        {
            PC = DHPlayer(C);

            if (PC != none && PC.SpawnPointIndex == SpawnPointIndex)
            {
                PC.SpawnPointIndex = 255;
                PC.bSpawnPointInvalidated = true;
            }
        }
    }
}

simulated function byte GetSpawnPointIndex(DHSpawnPoint SP)
{
    local int i;

    for (i = 0; i < arraycount(SpawnPoints); ++i)
    {
        if (SpawnPoints[i] == SP)
        {
            return i;
        }
    }

    Warn("Spawn point index could not be resolved");

    return 255;
}

simulated function GetActiveSpawnPointsForTeam(out array<DHSpawnPoint> SpawnPoints_, byte TeamIndex)
{
    local int i;

    for (i = 0; i < arraycount(SpawnPoints); ++i)
    {
        if (SpawnPoints[i] != none &&
            SpawnPoints[i].TeamIndex == TeamIndex &&
            SpawnPointIsActives[i] != 0)
        {
            SpawnPoints_[SpawnPoints_.Length] = SpawnPoints[i];
        }
    }
}

// Colin: The rules for spawn point availability are a little bit
// complicated, so here's a run-down:
//
// Players not spawning vehicles can spawn at any spawn point marked as
// SPT_Infantry.
//
// Mortar operators can use any spawn point marked as SPT_Mortar.
//
// Vehicles can be spawned at any spawn point marked as SPT_Vehicles.
//
// Tank crewmen not spawning tanks can use any spawn point marked as
// SPT_Vehicle (so that vehicle crews can spawn together)
simulated function bool IsSpawnPointIndexValid(byte SpawnPointIndex, byte TeamIndex, DHRoleInfo RI, class<Vehicle> VehicleClass)
{
    local DHSpawnPoint SP;

    // Valid index?
    if (SpawnPointIndex >= SPAWN_POINTS_MAX)
    {
        return false; //Not valid index
    }

    // Is spawn point active
    if (!IsSpawnPointIndexActive(SpawnPointIndex))
    {
        return false; //Not active
    }

    // Is spawn point for the correct team
    SP = SpawnPoints[SpawnPointIndex];

    if (SP.TeamIndex != TeamIndex)
    {
        return false;
    }

    if (RI == none)
    {
        return false;
    }

    if (RI.default.bCanUseMortars && SP.CanSpawnMortars())
    {
        return true;
    }

    if (VehicleClass == none)
    {
        return SP.CanSpawnInfantry() || (RI.default.bCanBeTankCrew && SP.CanSpawnVehicles());
    }

    if (class<ROVehicle>(VehicleClass) != none && SP.TeamIndex == class<ROVehicle>(VehicleClass).default.VehicleTeam)
    {
        return SP.CanSpawnVehicles() || (!class<ROVehicle>(VehicleClass).default.bMustBeTankCommander && SP.CanSpawnInfantryVehicles());
    }

    return false;
}

simulated function bool AreSpawnSettingsValid(byte Team, DHRoleInfo RI, byte SpawnPointIndex, byte VehiclePoolIndex, byte SpawnVehicleIndex)
{
    local class<Vehicle> VehicleClass;

    // Determine what we are trying to spawn as
    if (SpawnPointIndex == 255 && VehiclePoolIndex == 255 && SpawnVehicleIndex != 255)
    {
        // Trying to spawn at spawn vehicle
        if (CanSpawnAtVehicle(Team, SpawnVehicleIndex))
        {
            return true;
        }
    }
    else if (SpawnPointIndex != 255 && VehiclePoolIndex == 255 && SpawnVehicleIndex == 255)
    {
        // Trying to spawn as Infantry at a SP
        if (IsSpawnPointIndexValid(SpawnPointIndex, Team, RI, none))
        {
            return true;
        }
    }
    else if (SpawnPointIndex != 255 && VehiclePoolIndex != 255 && SpawnVehicleIndex == 255)
    {
        // Trying to spawn a vehicle
        if (IsVehiclePoolIndexValid(RI, VehiclePoolIndex))
        {
            VehicleClass = VehiclePoolVehicleClasses[VehiclePoolIndex];

            if (IsSpawnPointIndexValid(SpawnPointIndex, Team, RI, VehicleClass))
            {
                return true;
            }
        }
    }

    return false;
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
                PC.VehiclePoolIndex = 255;
                PC.bSpawnPointInvalidated = true;
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

simulated function bool IsVehiclePoolIndexValid(RORoleInfo RI, byte VehiclePoolIndex)
{
    local class<ROVehicle> VehicleClass;

    if (RI == none)
    {
        return false;
    }

    if (VehiclePoolIndex >= arraycount(VehiclePoolVehicleClasses))
    {
        return false;
    }

    if (!IsVehiclePoolActive(VehiclePoolIndex))
    {
        return false;
    }

    VehicleClass = VehiclePoolVehicleClasses[VehiclePoolIndex];

    if (VehicleClass == none)
    {
        return false;
    }

    if (VehicleClass.default.bMustBeTankCommander && !RI.bCanBeTankCrew)
    {
        return false;
    }

    if (VehicleClass.default.VehicleTeam != RI.Side)
    {
        return false;
    }

    return true;
}

simulated function byte GetVehiclePoolSpawnsRemaining(byte PoolIndex)
{
    if (VehiclePoolMaxSpawns[PoolIndex] == 255)
    {
        return 255;
    }

    return VehiclePoolMaxSpawns[PoolIndex] - VehiclePoolSpawnCounts[PoolIndex];
}

simulated function class<Vehicle> GetVehiclePoolVehicleClass(byte VehiclePoolIndex)
{
    if (VehiclePoolIndex == 255 || VehiclePoolIndex >= arraycount(VehiclePoolVehicleClasses))
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

simulated function bool IsVehiclePoolReservable(DHPlayer PC, DHRoleInfo RI, int VehiclePoolIndex)
{
    if (PC == none || (PC.Pawn != none && PC.Pawn.Health > 0))
    {
        // Alive players cannot reserve vehicles
        return false;
    }

    if (!IsVehiclePoolIndexValid(RI, VehiclePoolIndex))
    {
        // Invalid vehicle pool specified
        return false;
    }

    if (GetVehiclePoolAvailableReservationCount(VehiclePoolIndex) <= 0)
    {
        // All available vehicles have been reserved
        return false;
    }

    return true;
}

function bool ReserveVehicle(DHPlayer PC, byte VehiclePoolIndex)
{
    if (VehiclePoolIndex != 255 && !IsVehiclePoolReservable(PC, DHRoleInfo(PC.GetRoleInfo()), VehiclePoolIndex))
    {
        return false;
    }

    PC.VehiclePoolIndex = VehiclePoolIndex;

    if (VehiclePoolIndex != 255)
    {
        ++VehiclePoolReservationCount[VehiclePoolIndex];
    }

    return true;
}

function UnreserveVehicle(DHPlayer PC)
{
    if (PC.VehiclePoolIndex != 255)
    {
        --VehiclePoolReservationCount[PC.VehiclePoolIndex];
    }

    PC.VehiclePoolIndex = 255;
}

//------------------------------------------------------------------------------
// Spawn Vehicle Functions
//------------------------------------------------------------------------------

function int AddSpawnVehicle(int VehiclePoolIndex, Vehicle V)
{
    local int i;

    // Ensure this vehicle doesn't yet exist in the array
    for (i = 0; i < arraycount(SpawnVehicles); ++i)
    {
        if (SpawnVehicles[i].Vehicle == V)
        {
            // Vehicle already exists in the array
            return i;
        }
    }

    // Find an empty place to put the vehicle in the array
    for (i = 0; i < arraycount(SpawnVehicles); ++i)
    {
        if (SpawnVehicles[i].Vehicle == none)
        {
            SpawnVehicles[i].VehiclePoolIndex = VehiclePoolIndex;
            SpawnVehicles[i].LocationX = V.Location.X;
            SpawnVehicles[i].LocationY = V.Location.Y;
            SpawnVehicles[i].Vehicle = V;
            SpawnVehicles[i].BlockFlags = class'DHSpawnManager'.default.BlockFlags_None;

            // Vehicle was successfully added
            return i;
        }
    }

    Warn("Spawn vehicle (" $ V.Class $ ") could not be initialized.");

    // No empty spaces, cannot add to SpawnVehicles
    return -1;
}

function bool RemoveSpawnVehicle(Vehicle V)
{
    local int i;
    local Controller C;
    local DHPlayer PC;

    for (i = 0; i < arraycount(SpawnVehicles); ++i)
    {
        if (SpawnVehicles[i].Vehicle == V)
        {
            SpawnVehicles[i].LocationX = 0;
            SpawnVehicles[i].LocationY = 0;
            SpawnVehicles[i].VehiclePoolIndex = -1;
            SpawnVehicles[i].Vehicle = none;
            SpawnVehicles[i].BlockFlags = class'DHSpawnManager'.default.BlockFlags_None;

            for (C = Level.ControllerList; C != none; C = C.NextController)
            {
                PC = DHPlayer(C);

                if (PC != none && PC.SpawnVehicleIndex == i)
                {
                    PC.SpawnVehicleIndex = 255;
                    PC.bSpawnPointInvalidated = true;
                }
            }

            return true;
        }
    }

    return false;
}

simulated function bool CanSpawnAtVehicle(byte Team, byte Index)
{
    if (Index >= arraycount(SpawnVehicles) ||
        SpawnVehicles[Index].VehiclePoolIndex < 0 ||
        VehiclePoolVehicleClasses[SpawnVehicles[Index].VehiclePoolIndex].default.VehicleTeam != Team ||
        SpawnVehicles[Index].BlockFlags != class'DHSpawnManager'.default.BlockFlags_None)
    {
        return false;
    }

    return true;
}

simulated function GetActiveSpawnVehicleIndices(byte Team, out array<int> Indices)
{
    local int i;

    Indices.Length = 0;

    for (i = 0; i < arraycount(SpawnVehicles); ++i)
    {
        if (CanSpawnAtVehicle(Team, i))
        {
            Indices[Indices.Length] = i;
        }
    }
}

// Finds the matching VehicleClass but also check the bIsSpawnVehicle setting also matches
// Vital as same VehicleClass may well be in the vehicles list twice, with one being a spawn vehicle & the other the ordinary version, e.g. a half-track & a spawn vehicle HT
simulated function byte GetVehiclePoolIndex(Vehicle V)
{
    local int i;

    if (V != none)
    {
        for (i = 0; i < arraycount(VehiclePoolVehicleClasses); ++i)
        {
            if (V.Class == VehiclePoolVehicleClasses[i] && !(DHVehicle(V) != none && DHVehicle(V).bIsSpawnVehicle != bool(VehiclePoolIsSpawnVehicles[i])))
            {
                return i;
            }
        }
    }

    return 255;
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

simulated function int GetRoleIndexAndTeam(RORoleInfo RI, out byte Team)
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

function ClearAllMortarTargets()
{
    local int i;

    for (i = 0; i < arraycount(GermanMortarTargets); ++i)
    {
        GermanMortarTargets[i].bIsActive = false;
    }

    for (i = 0; i < arraycount(AlliedMortarTargets); ++i)
    {
        AlliedMortarTargets[i].bIsActive = false;
    }
}

function ClearMortarTarget(DHPlayer PC)
{
    local int i;

    if (PC == none)
    {
        return;
    }

    for (i = 0; i < arraycount(GermanMortarTargets); ++i)
    {
        if (GermanMortarTargets[i].Controller == PC)
        {
            GermanMortarTargets[i].bIsActive = false;
            break;
        }
    }

    for (i = 0; i < arraycount(AlliedMortarTargets); ++i)
    {
        if (AlliedMortarTargets[i].Controller == PC)
        {
            AlliedMortarTargets[i].bIsActive = false;
            break;
        }
    }
}

function AddCarriedRadioTrigger(ROArtilleryTrigger AT)
{
    local int i;

    if (AT == none)
    {
        return;
    }

    if (AT.TeamCanUse == AT_Axis || AT.TeamCanUse == AT_Both)
    {
        for (i = 0; i < arraycount(CarriedAxisRadios); ++i)
        {
            if (CarriedAxisRadios[i] == none)
            {
                CarriedAxisRadios[i] = AT;

                break;
            }
        }
    }

    if (AT.TeamCanUse == AT_Allies || AT.TeamCanUse == AT_Both)
    {
        for (i = 0; i < arraycount(CarriedAlliedRadios); ++i)
        {
            if (CarriedAlliedRadios[i] == none)
            {
                CarriedAlliedRadios[i] = AT;

                break;
            }
        }
    }
}

function RemoveCarriedRadioTrigger(ROArtilleryTrigger AT)
{
    local int i;

    if (AT == none)
    {
        return;
    }

    if (AT.TeamCanUse == AT_Axis || AT.TeamCanUse == AT_Both)
    {
        for (i = 0; i < arraycount(CarriedAxisRadios); ++i)
        {
            if (CarriedAxisRadios[i] == AT)
            {
                CarriedAxisRadios[i] = none;
            }
        }
    }

    if (AT.TeamCanUse == AT_Allies || AT.TeamCanUse == AT_Both)
    {
        for (i = 0; i < arraycount(CarriedAlliedRadios); ++i)
        {
            if (CarriedAlliedRadios[i] == AT)
            {
                CarriedAlliedRadios[i] = none;
            }
        }
    }
}

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

simulated function byte GetSpawnVehicleBlockFlags(Vehicle V)
{
    local int i;

    for (i = 0; i < arraycount(SpawnVehicles); ++i)
    {
        if (SpawnVehicles[i].Vehicle == V)
        {
            return SpawnVehicles[i].BlockFlags;
        }
    }

    return class'DHSpawnManager'.default.BlockFlags_None;
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

defaultproperties
{
    AlliesVictoryMusicIndex=-1
    AxisVictoryMusicIndex=-1
    MortarTargetDistanceThreshold=15088 //250 meters in UU
    ForceScaleText="Size"
    ReinforcementsInfiniteText="Infinite"
    DeathPenaltyText="Death Penalty"
}

