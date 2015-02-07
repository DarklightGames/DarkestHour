//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
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

var ROArtilleryTrigger  CarriedAlliedRadios[10];
var ROArtilleryTrigger  CarriedAxisRadios[10];

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
var private byte        VehiclePoolActiveCounts[VEHICLE_POOLS_MAX];
var byte                VehiclePoolSpawnsRemainings[VEHICLE_POOLS_MAX];
var private byte        VehiclePoolMaxActives[VEHICLE_POOLS_MAX];

const SPAWN_POINTS_MAX = 64;

var DHSpawnPoint        SpawnPoints[SPAWN_POINTS_MAX];
var private byte        SpawnPointIsActives[SPAWN_POINTS_MAX];

var float               VehiclePoolsUpdateTime;   // the last time the vehicle pools were updated in a way that requires the client to re-populate its list
var float               SpawnPointsUpdateTime;    // the last time the vehicle spawn points were updated in a way that requires the client to repopulate the list

replication
{
    // Variables the server will replicate to all clients
    reliable if (bNetDirty && Role == ROLE_Authority)
        DHSpawnCount, AlliedNationID, DHAxisRoles, DHAlliesRoles,
        DHAlliesRoleCount, DHAxisRoleCount, DHAlliesRoleBotCount, DHAxisRoleBotCount,
        CarriedAlliedRadios, CarriedAxisRadios, AlliedMortarTargets, GermanMortarTargets,
        VehiclePoolVehicleClasses, VehiclePoolIsActives, VehiclePoolNextAvailableTimes, VehiclePoolActiveCounts,
        VehiclePoolSpawnsRemainings, VehiclePoolMaxActives, VehiclePoolsUpdateTime,
        SpawnPointIsActives, SpawnPointsUpdateTime, AlliesVictoryMusicIndex, AxisVictoryMusicIndex;
}

simulated function PostBeginPlay()
{
    local int i;
    local DHSpawnPoint SP;

    foreach AllActors(class'DHSpawnPoint', SP)
    {
        if (i >= arraycount(SpawnPoints))
        {
            Warn("Number of DHSpawnPoints exceeds" @ arraycount(SpawnPoints) @ ", some spawn points will be ignored!");

            break;
        }

        SpawnPoints[i++] = SP;
    }
}

simulated function int GetRoleIndex(RORoleInfo ROInf, int TeamNum)
{
    local int i;

    if (TeamNum >= NEUTRAL_TEAM_INDEX)
    {
        return -1;
    }

    for (i = 0 ; i < ArrayCount(DHAxisRoles); ++i)
    {
        switch (TeamNum)
        {
            case AXIS_TEAM_INDEX:

                if (DHAxisRoles[i] != none && DHAxisRoles[i] == ROInf)
                {
                    return i;
                }

                break;

            case ALLIES_TEAM_INDEX:

                if (DHAlliesRoles[i] != none && DHAlliesRoles[i] == ROInf)
                {
                    return i;
                }

                break;
        }
   }

   return -1;
}

//------------------------------------------------------------------------------
// Vehicle Pool Functions
//------------------------------------------------------------------------------

simulated function DHSpawnPoint GetSpawnPointTest(int TeamInt)
{
    local DHSpawnPoint SP;

    //Lets just do a nasty/debug check and get the Allies active spawn point
    foreach AllActors(class'DHSpawnPoint', SP)
    {
        if (SP.bIsActive && SP.TeamIndex == TeamInt)
        {
            return SP;
        }
    }

    return none;
}

simulated function bool IsSpawnPointActive(byte SpawnPointIndex)
{
    return SpawnPointIsActives[SpawnPointIndex] != 0;
}

function SetSpawnPointIsActive(byte SpawnPointIndex, bool bIsActive)
{
    SpawnPointIsActives[SpawnPointIndex] = byte(bIsActive);

    SpawnPointsUpdateTime = Level.TimeSeconds;
}

function SetSpawnPointType(byte SpawnPointIndex, byte Type)
{
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

function DHSpawnPoint GetSpawnPoint(byte Index)
{
    return SpawnPoints[Index];
}

function GetActiveSpawnPointsForTeam(out array<DHSpawnPoint> SpawnPoints_, byte TeamIndex)
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

defaultproperties
{
    AlliesVictoryMusicIndex=-1
    AxisVictoryMusicIndex=-1
}
