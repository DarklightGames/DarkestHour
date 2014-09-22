class DHGameReplicationInfo extends ROGameReplicationInfo;

struct MortarTargetInfo
{
    var vector      Location;
    var vector      HitLocation;
    var float       Time;
    var DHPlayer    Controller;
    var byte        bCancelled;
};

struct VehiclePool
{
    var class<Vehicle> VehicleClass;
    var byte           bIsActive;
    var float          NextAvailableTime;	//The next time this vehicle is able to be spawned
    var int            ActiveCount;
    var int            ActiveMax;
    var int            SpawnsRemaining;
};

struct VehicleSpawnPoint
{
    var bool          bIsActive;
    var byte          TeamIndex;
    var vector        Location;
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

var VehiclePool         VehiclePools[32];
var VehicleSpawnPoint   VehicleSpawnPoints[32];

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        CarriedAlliedRadios, CarriedAxisRadios, AlliedNationID, DHAxisRoles,
        DHAlliesRoles, DHAlliesRoleBotCount, DHAlliesRoleCount,
        DHAxisRoleBotCount, DHAxisRoleCount, AlliedMortarTargets,
        GermanMortarTargets, DHSpawnCount, VehiclePools, VehicleSpawnPoints;
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

defaultproperties
{
}
