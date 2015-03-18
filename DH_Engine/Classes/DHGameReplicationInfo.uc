//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHGameReplicationInfo extends ROGameReplicationInfo;

//Theel: TODO
// functions need sorted

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
    var byte        Index;
    var bool        bIsActive;
    var byte        TeamIndex;
    var vector      Location;
    var Vehicle     Vehicle;
};

const RADIOS_MAX = 10;

var ROArtilleryTrigger  CarriedAlliedRadios[RADIOS_MAX];
var ROArtilleryTrigger  CarriedAxisRadios[RADIOS_MAX];

var int                 AlliedNationID;
var int                 AlliesVictoryMusicIndex;
var int                 AxisVictoryMusicIndex;

const ROLES_MAX = 16;

var DH_RoleInfo         DHAxisRoles[ROLES_MAX];
var DH_RoleInfo         DHAlliesRoles[ROLES_MAX];

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

const SPAWN_POINTS_MAX = 64;

var DHSpawnPoint        SpawnPoints[SPAWN_POINTS_MAX];
var private byte        SpawnPointIsActives[SPAWN_POINTS_MAX];

var float               VehiclePoolsUpdateTime;   // the last time the vehicle pools were updated in a way that requires the client to re-populate its list
var float               SpawnPointsUpdateTime;    // the last time the vehicle spawn points were updated in a way that requires the client to repopulate the list

const SPAWN_VEHICLES_MAX = 8;

var SpawnVehicle        SpawnVehicles[SPAWN_VEHICLES_MAX];

replication
{
    // Variables the server will replicate to all clients
    reliable if (bNetDirty && Role == ROLE_Authority)
        DHSpawnCount, AlliedNationID, DHAxisRoles, DHAlliesRoles,
        DHAlliesRoleCount, DHAxisRoleCount, DHAlliesRoleBotCount, DHAxisRoleBotCount,
        CarriedAlliedRadios, CarriedAxisRadios, AlliedMortarTargets, GermanMortarTargets,
        VehiclePoolVehicleClasses, VehiclePoolIsActives, VehiclePoolNextAvailableTimes, VehiclePoolActiveCounts,
        VehiclePoolSpawnsRemainings, VehiclePoolMaxActives, VehiclePoolsUpdateTime,
        SpawnPointIsActives, SpawnPointsUpdateTime, AlliesVictoryMusicIndex, AxisVictoryMusicIndex,
        SpawnVehicles;
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
    SpawnPointIsActives[SpawnPointIndex] = byte(bIsActive);
    SpawnPointsUpdateTime = Level.TimeSeconds;
}

function DHSpawnPoint GetSpawnPoint(byte Index)
{
    return SpawnPoints[Index];
}

function byte GetSpawnPointIndex(DHSpawnPoint SP)
{
    local int i;

    for (i = 0; i < arraycount(SpawnPoints); ++i)
    {
        if (SpawnPoints[i] == SP)
        {
            return i;
        }
    }

    Error("Spawn point index could not be resolved");

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

simulated function bool IsSpawnPointIndexValid(byte SpawnPointIndex, byte TeamIndex)
{
    local int i;
    local array<DHSpawnPoint> ActiveSpawnPoints;
    local DHSpawnPoint SP;

    // Valid index?
    if (SpawnPointIndex < 0 || SpawnPointIndex >= SPAWN_POINTS_MAX)
    {
        return false; //Not valid index
    }

    // Is spawn point active
    if (!IsSpawnPointIndexActive(SpawnPointIndex))
    {
        return false; //Not active
    }

    // Is spawn point for the correct team
    GetActiveSpawnPointsForTeam(ActiveSpawnPoints, TeamIndex);
    SP = GetSpawnPoint(SpawnPointIndex);

    for (i = 0; i < ActiveSpawnPoints.Length; ++i)
    {
        if (ActiveSpawnPoints[i] == SP)
        {
            return true; //Is for team
        }
    }

    return false; //Not for team
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
    if (bIsActive)
    {
        VehiclePoolIsActives[VehiclePoolIndex] = 1;
    }
    else
    {
        VehiclePoolIsActives[VehiclePoolIndex] = 0;
    }

    VehiclePoolsUpdateTime = Level.TimeSeconds;
}

function SetVehiclePoolSpawnsRemaining(byte PoolIndex, byte SpawnsRemaining)
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
    return VehiclePoolMaxActives[PoolIndex] == 255;
}

//------------------------------------------------------------------------------
// Vehicle Pool Functions
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
            SpawnVehicles[i].bIsActive = true;
            SpawnVehicles[i].Index = Index;
            SpawnVehicles[i].Location.X = V.Location.X;
            SpawnVehicles[i].Location.Y = V.Location.Y;
            SpawnVehicles[i].Location.Z = V.Rotation.Yaw;
            SpawnVehicles[i].TeamIndex = V.GetTeamNum();
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

    for (i = 0; i < arraycount(SpawnVehicles); ++i)
    {
        if (SpawnVehicles[i].Vehicle == V)
        {
            SpawnVehicles[i].bIsActive = false;
            SpawnVehicles[i].Index = 255;
            SpawnVehicles[i].Location = vect(0.0, 0.0, 0.0);
            SpawnVehicles[i].TeamIndex = 0;
            SpawnVehicles[i].Vehicle = none;

            return true;
        }
    }

    return false;
}

simulated function bool CanSpawnAtVehicle(byte Index, PlayerController PC)
{
    //TODO: add contested check here
    if (Index < 0 ||
        Index >= arraycount(SpawnVehicles) ||
        !SpawnVehicles[Index].bIsActive ||
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

defaultproperties
{
    AlliesVictoryMusicIndex=-1
    AxisVictoryMusicIndex=-1
}
