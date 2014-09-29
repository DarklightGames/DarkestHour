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

var private class<ROVehicle>    VehiclePoolVehicleClasses[32];
var private byte                VehiclePoolIsActives[32];
var private float               VehiclePoolNextAvailableTimes[32];
var private byte                VehiclePoolActiveCounts[32];
var private byte                VehiclePoolSpawnsRemainings[32];
var private byte                VehiclePoolMaxActives[32];

var private const byte  VehicleSpawnPointFlag_IsActive;  //0x01
var private const byte  VehicleSpawnPointFlag_TeamIndex; //0x02

var private byte        VehicleSpawnPointFlags[32];
var private float       VehicleSpawnPointXLocations[32];
var private float       VehicleSpawnPointYLocations[32];

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        CarriedAlliedRadios, CarriedAxisRadios, AlliedNationID, DHAxisRoles,
        DHAlliesRoles, DHAlliesRoleBotCount, DHAlliesRoleCount,
        DHAxisRoleBotCount, DHAxisRoleCount, AlliedMortarTargets,
        GermanMortarTargets, DHSpawnCount, VehiclePoolVehicleClasses,
        VehiclePoolIsActives, VehiclePoolNextAvailableTimes,
        VehiclePoolActiveCounts, VehiclePoolSpawnsRemainings,
        VehiclePoolMaxActives, VehicleSpawnPointFlags,
        VehicleSpawnPointXLocations, VehicleSpawnPointYLocations;
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

simulated function bool IsVehicleSpawnPointActive(byte VehicleSpawnPointIndex)
{
    return (VehicleSpawnPointFlags[VehicleSpawnPointIndex] & VehicleSpawnPointFlag_IsActive) != 0;
}

simulated function byte GetVehicleSpawnPointTeamIndex(byte VehicleSpawnPointIndex)
{
    return (VehicleSpawnPointFlags[VehicleSpawnPointIndex] & VehicleSpawnPointFlag_TeamIndex) >> 1;
}

function SetVehicleSpawnPointIsActive(byte VehicleSpawnPointIndex, bool bIsActive)
{
    if (bIsActive)
    {
        VehicleSpawnPointFlags[VehicleSpawnPointIndex] = VehicleSpawnPointFlags[VehicleSpawnPointIndex] | VehicleSpawnPointFlag_IsActive;
    }
    else
    {
        VehicleSpawnPointFlags[VehicleSpawnPointIndex] = VehicleSpawnPointFlags[VehicleSpawnPointIndex] & ~VehicleSpawnPointFlag_IsActive;
    }
}

function SetVehicleSpawnPointTeamIndex(byte VehicleSpawnPointIndex, byte TeamIndex)
{
    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            VehicleSpawnPointFlags[VehicleSpawnPointIndex] = VehicleSpawnPointFlags[VehicleSpawnPointIndex] & ~VehicleSpawnPointFlag_TeamIndex;
            break;
        case ALLIES_TEAM_INDEX:
            VehicleSpawnPointFlags[VehicleSpawnPointIndex] = VehicleSpawnPointFlags[VehicleSpawnPointIndex] | VehicleSpawnPointFlag_TeamIndex;
            break;
        default:
            Warn("Unhandled TeamIndex");
            break;
    }
}

function SetVehicleSpawnPointLocation(byte VehicleSpawnPointIndex, vector Location)
{
    VehicleSpawnPointXLocations[VehicleSpawnPointIndex] = Location.X;
    VehicleSpawnPointXLocations[VehicleSpawnPointIndex] = Location.Y;
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

defaultproperties
{
    VehicleSpawnPointFlag_IsActive=0x01
    VehicleSpawnPointFlag_TeamIndex=0x02
}
