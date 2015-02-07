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

// Vehicle pool and spawn point info is heavily fragmented due to the arbitrary variable size limit (255 bytes) that exists in UnrealScript
var class<ROVehicle>    VehiclePoolVehicleClasses[32];
var byte                VehiclePoolIsActives[32];
var float               VehiclePoolNextAvailableTimes[32];
var private byte        VehiclePoolActiveCounts[32];
var byte                VehiclePoolSpawnsRemainings[32];
var private byte        VehiclePoolMaxActives[32];

var private byte        SpawnPointIsActives[32];

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

defaultproperties
{
    AlliesVictoryMusicIndex=-1
    AxisVictoryMusicIndex=-1
}
