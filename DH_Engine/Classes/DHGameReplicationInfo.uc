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

var DH_RoleInfo         DHAxisRoles[16];
var DH_RoleInfo         DHAlliesRoles[16];

var byte                DHAlliesRoleBotCount[16];
var byte                DHAlliesRoleCount[16];
var byte                DHAxisRoleBotCount[16];
var byte                DHAxisRoleCount[16];

var MortarTargetInfo    AlliedMortarTargets[2];
var MortarTargetInfo    GermanMortarTargets[2];

var int                 DHSpawnCount[2];

//Vehicle pool and spawn point info is heavily fragmented due to the arbitrary
//variable size limit (255 bytes) that exists in UnrealScript.

var class<ROVehicle>    VehiclePoolVehicleClasses[32];
var byte                VehiclePoolIsActives[32];
var float               VehiclePoolNextAvailableTimes[32];
var private byte        VehiclePoolActiveCounts[32];
var byte                VehiclePoolSpawnsRemainings[32];
var private byte        VehiclePoolMaxActives[32];

var private const byte  SpawnPointFlag_IsActive;  //0x01
var private const byte  SpawnPointFlag_TeamIndex; //0x02
var private const byte  SpawnPointFlag_Type;      //0x04

var private byte        SpawnPointFlags[32];
var private float       SpawnPointXLocations[32];
var private float       SpawnPointYLocations[32];
var string              SpawnPointNames[32];

var float               VehiclePoolsUpdateTime;         //The last time the vehicle pools were updated in a way that requires the client to re-populate its list
var float               SpawnPointsUpdateTime;   //The last time the vehicle spawn points were updated in a way that requires the client to repopulate the list

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        CarriedAlliedRadios, CarriedAxisRadios, AlliedNationID, DHAxisRoles,
        DHAlliesRoles, DHAlliesRoleBotCount, DHAlliesRoleCount,
        DHAxisRoleBotCount, DHAxisRoleCount, AlliedMortarTargets,
        GermanMortarTargets, DHSpawnCount, VehiclePoolVehicleClasses,
        VehiclePoolIsActives, VehiclePoolNextAvailableTimes,
        VehiclePoolActiveCounts, VehiclePoolSpawnsRemainings,
        VehiclePoolMaxActives, SpawnPointFlags,
        SpawnPointXLocations, SpawnPointYLocations,
        VehiclePoolsUpdateTime, SpawnPointsUpdateTime,
        SpawnPointNames, AlliesVictoryMusicIndex, AxisVictoryMusicIndex;
}

simulated function int GetRoleIndex(RORoleInfo ROInf, int TeamNum)
{
    local int i;

    if (TeamNum >= NEUTRAL_TEAM_INDEX)
    {
        return -1;
    }

    for(i = 0 ; i < arraycount(DHAxisRoles); ++i)
    {
        switch(TeamNum)
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

simulated function bool IsSpawnPointActive(byte SpawnPointIndex)
{
    return (SpawnPointFlags[SpawnPointIndex] & SpawnPointFlag_IsActive) == SpawnPointFlag_IsActive;
}

simulated function byte GetSpawnPointTeamIndex(byte SpawnPointIndex)
{
    return (SpawnPointFlags[SpawnPointIndex] & SpawnPointFlag_TeamIndex) >> 1;
}

simulated function byte GetSpawnPointType(byte SpawnPointIndex)
{
    return (SpawnPointFlags[SpawnPointIndex] & SpawnPointFlag_Type) >> 2;
}

function SetSpawnPointIsActive(byte SpawnPointIndex, bool bIsActive)
{
    if (bIsActive)
    {
        SpawnPointFlags[SpawnPointIndex] = SpawnPointFlags[SpawnPointIndex] | SpawnPointFlag_IsActive;
    }
    else
    {
        SpawnPointFlags[SpawnPointIndex] = SpawnPointFlags[SpawnPointIndex] & ~SpawnPointFlag_IsActive;
    }

    SpawnPointsUpdateTime = Level.TimeSeconds;
}

function SetSpawnPointTeamIndex(byte SpawnPointIndex, byte TeamIndex)
{
    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            SpawnPointFlags[SpawnPointIndex] = SpawnPointFlags[SpawnPointIndex] & ~SpawnPointFlag_TeamIndex;
            break;
        case ALLIES_TEAM_INDEX:
            SpawnPointFlags[SpawnPointIndex] = SpawnPointFlags[SpawnPointIndex] | SpawnPointFlag_TeamIndex;
            break;
        default:
            Warn("Unhandled TeamIndex");
            break;
    }

    Log("SpawnPointFlags[" $ SpawnPointIndex $ "] =" @ SpawnPointFlags[SpawnPointIndex]);
    Log("GetSpawnPointTeamIndex(" $ SpawnPointIndex $ ")=" @ GetSpawnPointTeamIndex(SpawnPointIndex));
}

function SetSpawnPointLocation(byte SpawnPointIndex, vector Location)
{
    SpawnPointXLocations[SpawnPointIndex] = Location.X;
    SpawnPointXLocations[SpawnPointIndex] = Location.Y;
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

defaultproperties
{
    SpawnPointFlag_IsActive=1
    SpawnPointFlag_TeamIndex=2
    SpawnPointFlag_Type=4
    AlliesVictoryMusicIndex=-1
    AxisVictoryMusicIndex=-1
}
