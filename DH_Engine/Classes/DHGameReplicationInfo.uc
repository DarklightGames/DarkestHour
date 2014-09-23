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

var class<ROVehicle>    VehiclePoolVehicleClasses[32];
var byte                VehiclePoolIsActives[32];
var float               VehiclePoolNextAvailableTimes[32];
var byte                VehiclePoolActiveCounts[32];
var byte                VehiclePoolSpawnsRemainings[32];

struct Vector2
{
    var byte X;
    var byte Y;
};

var const byte VehicleSpawnPointFlag_IsActive;  //0x01
var const byte VehicleSpawnPointFlag_TeamIndex; //0x02

var byte                VehicleSpawnPointFlags[32];
var float               VehicleSpawnPointXLocations[32];
var float               VehicleSpawnPointYLocations[32];

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        CarriedAlliedRadios, CarriedAxisRadios, AlliedNationID, DHAxisRoles,
        DHAlliesRoles, DHAlliesRoleBotCount, DHAlliesRoleCount,
        DHAxisRoleBotCount, DHAxisRoleCount, AlliedMortarTargets,
        GermanMortarTargets, DHSpawnCount;
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

simulated function bool IsVehicleSpawnPointActive(byte SpawnPointIndex)
{
    return (VehicleSpawnPointFlags[SpawnPointIndex] & VehicleSpawnPointFlag_IsActive) != 0;
}

simulated function byte GetVehicleSpawnPointTeamIndex(byte SpawnPointIndex)
{
    return (VehicleSpawnPointFlags[SpawnPointIndex] & VehicleSpawnPointFlag_TeamIndex) >> 1;
}

defaultproperties
{
    VehicleSpawnPointFlag_IsActive=0x01
    VehicleSpawnPointFlag_TeamIndex=0x02
}
