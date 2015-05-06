//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHGameReplicationInfo extends ROGameReplicationInfo;

struct MortarTargetInfo
{
    var vector      Location;
    var vector      HitLocation;
    var float       Time;
    var DHPlayer    Controller;
    var byte        bCancelled;
};

struct SpawnVehicle
{
    var byte            Index;
    var byte            TeamIndex;
    var vector          Location;
    var class<Vehicle>  VehicleClass;
    var Vehicle         Vehicle;
};

const RADIOS_MAX = 10;

var ROArtilleryTrigger  CarriedAlliedRadios[RADIOS_MAX];
var ROArtilleryTrigger  CarriedAxisRadios[RADIOS_MAX];

var int                 AlliedNationID;
var int                 AlliesVictoryMusicIndex;
var int                 AxisVictoryMusicIndex;

const ROLES_MAX = 16;

var DHRoleInfo          DHAxisRoles[ROLES_MAX];
var DHRoleInfo          DHAlliesRoles[ROLES_MAX];

var byte                DHAlliesRoleBotCount[ROLES_MAX];
var byte                DHAlliesRoleCount[ROLES_MAX];
var byte                DHAxisRoleBotCount[ROLES_MAX];
var byte                DHAxisRoleCount[ROLES_MAX];

const MORTAR_TARGETS_MAX = 2;

var MortarTargetInfo    AlliedMortarTargets[MORTAR_TARGETS_MAX];
var MortarTargetInfo    GermanMortarTargets[MORTAR_TARGETS_MAX];

var int                 DHSpawnCount[2];

// Vehicle pool and spawn point info is heavily fragmented due to the arbitrary variable size limit (255 bytes) that exists in UnrealScript
const VEHICLE_POOLS_MAX = 32;

var class<ROVehicle>    VehiclePoolVehicleClasses[VEHICLE_POOLS_MAX];
var byte                VehiclePoolIsActives[VEHICLE_POOLS_MAX];
var float               VehiclePoolNextAvailableTimes[VEHICLE_POOLS_MAX];
var byte                VehiclePoolActiveCounts[VEHICLE_POOLS_MAX];
var byte                VehiclePoolSpawnsRemainings[VEHICLE_POOLS_MAX];
var byte                VehiclePoolMaxActives[VEHICLE_POOLS_MAX];

var byte                MaxTeamVehicles[2];

const SPAWN_POINTS_MAX = 64;

var DHSpawnPoint        SpawnPoints[SPAWN_POINTS_MAX];
var private byte        SpawnPointIsActives[SPAWN_POINTS_MAX];

var float               VehiclePoolsUpdateTime;   // the last time the vehicle pools were updated in a way that requires the client to re-populate its list
var float               SpawnPointsUpdateTime;    // the last time the vehicle spawn points were updated in a way that requires the client to repopulate the list

const SPAWN_VEHICLES_MAX = 8;

var SpawnVehicle        SpawnVehicles[SPAWN_VEHICLES_MAX];

const OBJECTIVES_MAX = 32;

var DHObjective         DHObjectives[OBJECTIVES_MAX];

replication
{
    // Variables the server will replicate to all clients
    reliable if (bNetDirty && Role == ROLE_Authority)
        DHSpawnCount, DHAxisRoles, DHAlliesRoles,
        DHAlliesRoleCount, DHAxisRoleCount, DHAlliesRoleBotCount, DHAxisRoleBotCount,
        CarriedAlliedRadios, CarriedAxisRadios, AlliedMortarTargets, GermanMortarTargets,
        VehiclePoolVehicleClasses, VehiclePoolIsActives, VehiclePoolNextAvailableTimes, VehiclePoolActiveCounts,
        VehiclePoolSpawnsRemainings, VehiclePoolMaxActives, VehiclePoolsUpdateTime,
        SpawnPointIsActives, SpawnPointsUpdateTime, SpawnVehicles, MaxTeamVehicles, DHObjectives;

    reliable if (bNetInitial && (Role == ROLE_Authority))
        AlliedNationID, AlliesVictoryMusicIndex, AxisVictoryMusicIndex;
}

simulated function PostBeginPlay()
{
    local int i;
    local DHSpawnPoint SP;

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
}

simulated function int GetRoleIndex(RORoleInfo RI, int TeamNum)
{
    local int i;

    if (TeamNum >= NEUTRAL_TEAM_INDEX)
    {
        return -1;
    }

    for (i = 0 ; i < arraycount(DHAxisRoles); ++i)
    {
        switch (TeamNum)
        {
            case AXIS_TEAM_INDEX:

                if (DHAxisRoles[i] != none && DHAxisRoles[i] == RI)
                {
                    return i;
                }

                break;

            case ALLIES_TEAM_INDEX:

                if (DHAlliesRoles[i] != none && DHAlliesRoles[i] == RI)
                {
                    return i;
                }

                break;
        }
   }

   return -1;
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
    SpawnPointsUpdateTime = Level.TimeSeconds;

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

simulated function DHSpawnPoint GetSpawnPoint(byte Index)
{
    return SpawnPoints[Index];
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
        if (SpawnPoints[i] != none && SpawnPoints[i].TeamIndex == TeamIndex && SpawnPointIsActives[i] != 0)
        {
            SpawnPoints_[SpawnPoints_.Length] = SpawnPoints[i];
        }
    }
}

simulated function bool IsSpawnPointIndexValid(byte SpawnPointIndex, byte TeamIndex, optional bool bCheckSPType, optional bool bTypeIsVehicle)
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
    SP = GetSpawnPoint(SpawnPointIndex);

    // optional type check
    if (bCheckSPType)
    {
        // Confirm the types
        if (bTypeIsVehicle && SP.Type == ESPT_Infantry)
        {
            return false; //Not valid type
        }
        else if (!bTypeIsVehicle && SP.Type == ESPT_Vehicles)
        {
            return false; //Not valid type
        }
    }

    if (SP.TeamIndex == TeamIndex)
    {
        return true;
    }
    else
    {
        return false;
    }
}

//------------------------------------------------------------------------------
// Vehicle Pool Functions
//------------------------------------------------------------------------------

function SetVehiclePoolVehicleClass(byte VehiclePoolIndex, class<ROVehicle> VehicleClass)
{
    VehiclePoolVehicleClasses[VehiclePoolIndex] = VehicleClass;
}

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

    VehiclePoolsUpdateTime = Level.TimeSeconds;
}

function SetVehiclePoolSpawnsRemaining(byte PoolIndex, int SpawnsRemaining)
{
    VehiclePoolSpawnsRemainings[PoolIndex] = SpawnsRemaining;
}

function SetVehiclePoolMaxActives(byte PoolIndex, byte MaxActive)
{
    VehiclePoolMaxActives[PoolIndex] = MaxActive;
}

function SetVehiclePoolNextAvailableTime(byte PoolIndex, float NextAvailableTime)
{
    VehiclePoolNextAvailableTimes[PoolIndex] = NextAvailableTime;
}

function SetVehiclePoolActiveCount(byte PoolIndex, byte ActiveCount)
{
    VehiclePoolActiveCounts[PoolIndex] = ActiveCount;
}

function bool IsVehiclePoolInfinite(byte PoolIndex)
{
    return VehiclePoolSpawnsRemainings[PoolIndex] == 255;
}

simulated function class<ROVehicle> GetVehiclePoolClass(byte VehiclePoolIndex)
{
    if (VehiclePoolIndex >= 0 && VehiclePoolIndex < arraycount(VehiclePoolVehicleClasses))
    {
        return VehiclePoolVehicleClasses[VehiclePoolIndex];
    }

    return none;
}

simulated function bool IsVehiclePoolIndexValid(byte VehiclePoolIndex, RORoleInfo RI)
{
    local class<ROVehicle> VehicleClass;

    if (RI == none)
    {
        Log("RI check");
        return false;
    }

    if (VehiclePoolIndex >= arraycount(VehiclePoolVehicleClasses))
    {
        if (VehiclePoolIndex != 255)
        {
            Log("Index bound check");
        }

        return false;
    }

    if (VehiclePoolIsActives[VehiclePoolIndex] == 0)
    {
        Log("Active check");
        return false;
    }

    VehicleClass = VehiclePoolVehicleClasses[VehiclePoolIndex];

    if (VehicleClass == none)
    {
        Log("Failed at VehicleClass check");
        return false;
    }

    if (VehicleClass.default.bMustBeTankCommander && !RI.bCanBeTankCrew)
    {
        Log("Tank commander check");
        return false;
    }

    if (VehicleClass.default.VehicleTeam != RI.Side)
    {
        Log("Failed at team check");
        return false;
    }

    return true;
}

//------------------------------------------------------------------------------
// Spawn Vehicle Functions
//------------------------------------------------------------------------------

function int AddSpawnVehicle(Vehicle V, int Index)
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
            SpawnVehicles[i].Index = Index;
            SpawnVehicles[i].Location.X = V.Location.X;
            SpawnVehicles[i].Location.Y = V.Location.Y;
            SpawnVehicles[i].Location.Z = V.Rotation.Yaw;
            SpawnVehicles[i].TeamIndex = V.GetTeamNum();
            SpawnVehicles[i].VehicleClass = V.Class;
            SpawnVehicles[i].Vehicle = V;

            // Vehicle was successfully added, return index in
            return i;
        }
    }

    Warn("AddSpawnVehicle failed, no empty spaces available");

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
            SpawnVehicles[i].Index = 255;
            SpawnVehicles[i].Location = vect(0.0, 0.0, 0.0);
            SpawnVehicles[i].TeamIndex = 0;
            SpawnVehicles[i].VehicleClass = none;
            SpawnVehicles[i].Vehicle = none;

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

simulated function class<Vehicle> GetSpawnVehicleClass(int SpawnVehicleIndex)
{
    if (SpawnVehicleIndex >= 0 && SpawnVehicleIndex < arraycount(SpawnVehicles))
    {
        return SpawnVehicles[SpawnVehicleIndex].VehicleClass;
    }

    return none;
}

simulated function bool CanSpawnAtVehicle(byte Index, PlayerController PC)
{
    //TODO: add contested check here
    if (Index >= arraycount(SpawnVehicles) ||
        SpawnVehicles[Index].VehicleClass == none ||
        SpawnVehicles[Index].TeamIndex != PC.GetTeamNum())
    {
        return false;
    }

    //TODO: check exits not blocked?

    return true;
}

simulated function GetActiveSpawnVehicleIndices(PlayerController PC, out array<int> Indices)
{
    local int i;

    Indices.Length = 0;

    for (i = 0; i < arraycount(SpawnVehicles); ++i)
    {
        if (CanSpawnAtVehicle(i, PC))
        {
            Indices[Indices.Length] = i;
        }
    }
}

//------------------------------------------------------------------------------
// Check function
//------------------------------------------------------------------------------

simulated function bool AreIndicesValid(DHPlayer DHP)
{
    if (DHP.SpawnPointIndex == 255 && DHP.VehiclePoolIndex == 255 && DHP.SpawnVehicleIndex == 255)
    {
        // All indices are null
        return false;
    }

    // Determine what we are trying to spawn as
    if (DHP.SpawnPointIndex == 255 && DHP.VehiclePoolIndex == 255)
    {
        // Trying to spawn at Spawn Vehicle
        if (CanSpawnAtVehicle(DHP.SpawnVehicleIndex, DHP))
        {
            return true;
        }
    }
    else if (DHP.SpawnPointIndex != 255 && DHP.VehiclePoolIndex == 255)
    {
        // Trying to spawn as Infantry at a SP
        if (IsSpawnPointIndexValid(DHP.SpawnPointIndex, DHP.GetTeamNum(), true, false))
        {
            return true;
        }
    }
    else if (DHP.SpawnPointIndex != 255 && DHP.VehiclePoolIndex != 255)
    {
        // Trying to spawn a vehicle
        if (IsSpawnPointIndexValid(DHP.SpawnPointIndex, DHP.GetTeamNum(), true, true) && IsVehiclePoolIndexValid(DHP.VehiclePoolIndex, ROPlayerReplicationInfo(DHP.PlayerReplicationInfo).RoleInfo))
        {
            return true;
        }
    }

    // If we are here then return false as indices are some how not valid
    return false;
}

defaultproperties
{
    AlliesVictoryMusicIndex=-1
    AxisVictoryMusicIndex=-1
}
