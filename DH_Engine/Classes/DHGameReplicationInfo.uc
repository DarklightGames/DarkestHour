// *************************************************************************
//
//  ***   DHgameReplicationInfo   ***
//
// *************************************************************************

class DHGameReplicationInfo extends ROGameReplicationInfo;

// Portable Radios
var ROArtilleryTrigger      CarriedAlliedRadios[10];       // An array of the player-carried allied radios
var ROArtilleryTrigger      CarriedAxisRadios[10];       // An array of the player-carried axis radios

var int                     AlliedNationID;

var DH_RoleInfo     DHAxisRoles[16];            // Used to replicate assorted role information to the client
var DH_RoleInfo     DHAlliesRoles[16];

var byte            DHAlliesRoleBotCount[16];
var byte            DHAlliesRoleCount[16];
var byte            DHAxisRoleBotCount[16];
var byte            DHAxisRoleCount[16];

struct MortarTargetInfo
{
    var vector      Location;
    var vector      HitLocation;
    var float       Time;
    var DHPlayer    Controller;
    var byte        bCancelled;
};

var MortarTargetInfo AlliedMortarTargets[2];
var MortarTargetInfo GermanMortarTargets[2];

//Keeps track of the -real- reinforcements left, no longer a percentage.
var int             DHSpawnCount[2];

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
   local int  count;

   if (TeamNum >= NEUTRAL_TEAM_INDEX)
      return -1;

   for(count = 0 ; count < ArrayCount(DHAxisRoles) ; count++)
   {
        switch(TeamNum)
        {
           case AXIS_TEAM_INDEX : // Axis
           if (DHAxisRoles[count] != none && DHAxisRoles[count] == ROInf)
              return count;
           break;
           case ALLIES_TEAM_INDEX : // Allies
           if (DHAlliesRoles[count] != none && DHAlliesRoles[count] == ROInf)
              return count;
           break;
        }
   }
   //not found
   return -1;
}

defaultproperties
{
}
