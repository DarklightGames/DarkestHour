//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================
// This is a generic spawn point. When squads were added, there was a di
//==============================================================================

class DHSpawnPointComponent extends Actor;

var const byte BLOCKED_None;
var const byte BLOCKED_EnemiesNearby;
var const byte BLOCKED_InObjective;
var const byte BLOCKED_Full;

var private bool bIsActive;
var int SpawnPointIndex;
var int TeamIndex;
var int BlockFlags;

var protected DHGameReplicationInfo GRI;

// The amount of time, in seconds, that a player will be invulnerable after
// spawning on this spawn point.
var float SpawnProtectionTime;

// The amount of time, in seconds, that a player will be considered a spawn kill
// after spawning on this spawn point.
var float SpawnKillProtectionTime;

replication
{
    reliable if (Role == ROLE_Authority)
        TeamIndex, SpawnPointIndex, BlockFlags, bIsActive;
}


simulated function bool CanSpawnVehicle(class<ROVehicle> VehicleClass);
simulated function string GetSpawnPointName();
simulated function bool DrySpawn();
function bool PerformSpawn(DHPlayer PC);
function GetSpawnPosition(out vector SpawnLocation, out rotator SpawnRotation, int VehiclePoolIndex, float CollisionRadius);

simulated event PostBeginPlay()
{
    super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);
        GRI.AddSpawnPoint(self);
    }
}

// Returns true if the spawn point is "visible" to a player with the arguments
// provided.
simulated function bool IsVisibleTo(int TeamIndex, int RoleIndex, int SquadIndex, int VehiclePoolIndex)
{
    if (self.TeamIndex != TeamIndex || !bIsActive)
    {
        return false;
    }

    return true;
}

// A blocked spawn point is an active spawn point that, for whatever reason,
// is not currently available to be spawned on.
simulated function bool IsBlocked();

// Returns true if the given arguments are satisfactory for spawning on this
// spawn point.
simulated function bool CanSpawn(DHGameReplicationInfo GRI, int TeamIndex, int RoleIndex, int SquadIndex, int VehiclePoolIndex)
{
    if (self.TeamIndex != TeamIndex || !bIsActive || IsBlocked())
    {
        return false;
    }

    return true;
}

function bool IsActive()
{
    return bIsActive;
}

function SetIsActive(bool bIsActive)
{
    local Controller C;
    local DHPlayer PC;

    self.bIsActive = bIsActive;

    if (!bIsActive)
    {
        for (C = Level.ControllerList; C != none; C = C.NextController)
        {
            PC = DHPlayer(C);

            if (PC != none && PC.SpawnPointIndex == SpawnPointIndex)
            {
                PC.SpawnPointIndex = -1;
                PC.bSpawnPointInvalidated = true;
            }
        }
    }
}

defaultproperties
{
    TeamIndex=-1
    SpawnProtectionTime=2.5
    SpawnKillProtectionTime=5
    bAlwaysRelevant=true
    RemoteRole=ROLE_SimulatedProxy

    BLOCKED_None=0
    BLOCKED_EnemiesNearby=1
    BLOCKED_InObjective=2
    BLOCKED_Full=4
}

