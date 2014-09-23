class DHVehicleManager extends SVehicleFactory;

//-----------------------------------------------------------
// Variables
//-----------------------------------------------------------

struct VehiclePool
{
    var() class<ROVehicle> VehicleClass;
    var() bool             bIsInitiallyActive;
    var() float            RespawnTime;
    var() byte             MaxSpawns; //value to determine the overall number of vehicles we can spawn
    var() byte             MaxActive; //value to determine how many active at once

    var bool               bIsActive;
    var float              NextAvailableTime;
    var int                SpawnCount;
    var int                ActiveCount;
};

var const byte SpawnError_None;
var const byte SpawnError_Fatal;
var const byte SpawnError_MaxVehicles;
var const byte SpawnError_Inactive;
var const byte SpawnError_Cooldown;
var const byte SpawnError_SpawnLimit;
var const byte SpawnError_ActiveLimit;
var const byte SpawnError_PoolInactive;
var const byte SpawnError_SpawnInactive;
var const byte SpawnError_Blocked;

const SpawnPointsMax = 32;
const PoolsMax = 32;

var() array<VehiclePool>           Pools;
var() byte                         MaxTeamVehicles[2];
var() byte                         MaxDestroyedVehicles;

var   array<Vehicle>               Vehicles;
var   array<DHVehicleSpawnPoint>   SpawnPoints;

//-----------------------------------------------------------
// Functions
//-----------------------------------------------------------

function PostBeginPlay()
{
    local int i;
    local DHVehicleSpawnPoint SP;
    local DHGameReplicationInfo GRI;

    super.PostBeginPlay();

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI == none)
    {
        Warn("DHGameReplicationInfo is none");

        return;
    }

    foreach AllActors(class'DHVehicleSpawnPoint', SP)
    {
        if (SpawnPoints.Length >= SpawnPointsMax)
        {
            Warn("DHVehicleSpawnPoint count exceeds" @ SpawnPointsMax);

            break;
        }

        SpawnPoints[SpawnPoints.Length] = SP;
    }

    for (i = 0; i < SpawnPoints.Length; ++i)
    {
        if (SpawnPoints[i].bIsActive)
        {
            GRI.VehicleSpawnPointFlags[i] = GRI.VehicleSpawnPointFlags[i] | class'DHGameReplicationInfo'.default.VehicleSpawnPointFlag_IsActive;
        }
        else
        {
            GRI.VehicleSpawnPointFlags[i] = GRI.VehicleSpawnPointFlags[i] & ~class'DHGameReplicationInfo'.default.VehicleSpawnPointFlag_IsActive;
        }

        GRI.VehicleSpawnPointFlags[i] = GRI.VehicleSpawnPointFlags[i] | (SpawnPoints[i].TeamIndex << 1);
        GRI.VehicleSpawnPointXLocations[i] = SpawnPoints[i].Location.X;
        GRI.VehicleSpawnPointYLocations[i] = SpawnPoints[i].Location.Y;
    }

    for (i = 0; i < Pools.Length; ++i)
    {
        Pools[i].bIsActive = Pools[i].bIsInitiallyActive;

        GRI.VehiclePoolVehicleClasses[i] = Pools[i].VehicleClass;

        if (Pools[i].bIsActive)
        {
            GRI.VehiclePoolIsActives[i] = 1;
        }
        else
        {
            GRI.VehiclePoolIsActives[i] = 0;
        }

        GRI.VehiclePoolActiveCounts[i] = Pools[i].ActiveCount;
        GRI.VehiclePoolNextAvailableTimes[i] = Pools[i].NextAvailableTime;
        GRI.VehiclePoolSpawnsRemainings[i] = Pools[i].MaxSpawns - Pools[i].SpawnCount;
    }
}

function Reset()
{
    Vehicles.Length = 0;

    super.Reset();
}

function byte DrySpawn(byte PoolIndex, byte SpawnPointIndex)
{
    local int i;
    local Pawn P;

    if (PoolIndex < 0 || PoolIndex >= PoolsMax || Pools[PoolIndex].VehicleClass == none ||
        SpawnPointIndex < 0 || SpawnPointIndex >= SpawnPointsMax)
    {
        return SpawnError_Fatal;
    }

    if (Vehicles.Length >= MaxTeamVehicles[Pools[PoolIndex].VehicleClass.default.VehicleTeam])
    {
        return SpawnError_MaxVehicles;
    }

    if (!Pools[PoolIndex].bIsActive || !SpawnPoints[SpawnPointIndex].bIsActive)
    {
        return SpawnError_Inactive;
    }

    if (Level.TimeSeconds < Pools[PoolIndex].NextAvailableTime)
    {
        return SpawnError_Cooldown;
    }

    if (Pools[PoolIndex].SpawnCount >= Pools[PoolIndex].MaxSpawns)
    {
        return SpawnError_SpawnLimit;
    }

    if (Pools[PoolIndex].ActiveCount >= Pools[PoolIndex].MaxActive)
    {
        return SpawnError_ActiveLimit;
    }

    for (i = 0; i < SpawnPoints[SpawnPointindex].Positions.Length; ++i)
    {
        foreach RadiusActors(class'Pawn', P, Pools[PoolIndex].VehicleClass.default.CollisionRadius * 1.25, SpawnPoints[SpawnPointindex].Positions[i].Location)
        {
            return SpawnError_Blocked;
        }
    }

    return SpawnError_None;
}

function Vehicle SpawnVehicle(byte PoolIndex, byte SpawnPointIndex, out byte SpawnError)
{
    local int i;
    local Vehicle V;
    local DHGameReplicationInfo GRI;

    SpawnError = SpawnError_Fatal;

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI == none)
    {
        Warn("DHGameReplicationInfo is none");
        return none;
    }

    if (DarkestHourGame(Level.Game) == none)
    {
        Warn("DarkestHourGame is none");
        return none;
    }

    SpawnError = DrySpawn(PoolIndex, SpawnPointIndex);

    if (SpawnError != SpawnError_None)
    {
        return none;
    }

    for (i = 0; i < SpawnPoints[SpawnPointIndex].Positions.Length; ++i)
    {
        V = Spawn(Pools[PoolIndex].VehicleClass,,, SpawnPoints[SpawnPointindex].Positions[i].Location, SpawnPoints[SpawnPointindex].Positions[i].Rotation);

        if (V != none)
        {
            //TODO: attempt to start the engine up?

            V.ParentFactory = self;

            Vehicles[Vehicles.Length] = V;

            //Tell the pool about the vehicle’s existence
            Pools[PoolIndex].NextAvailableTime = Level.TimeSeconds + Pools[PoolIndex].RespawnTime;
            Pools[PoolIndex].ActiveCount += 1;
            Pools[PoolIndex].SpawnCount += 1;

            //Update game replication info
            //GRI.VehiclePools[PoolIndex].NextAvailableTime = Level.TimeSeconds + VehiclePools[PoolIndex].RespawnTime;
            //GRI.VehiclePools[PoolIndex].ActiveCount += 1;
            //GRI.VehiclePools[PoolIndex].SpawnsRemaining -= 1;

            break;
        }
    }

    if (V == none)
    {
        SpawnError = SpawnError_Blocked;
    }

    return V;
}

event VehicleDestroyed(Vehicle V)
{
    local int i;
    local DHGameReplicationInfo GRI;

    Level.Game.Broadcast(self, "VehicleDestroyed" @ V);

    super.VehicleDestroyed(V);

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI == none)
    {
        Warn("DHGameReplicationInfo is none");

        return;
    }

    if (DarkestHourGame(Level.Game) == none)
    {
        Warn("DarkestHourGame is none");

        return;
    }

    //Removes the destroyed vehicle from the managed vehicles
    for (i = Vehicles.Length - 1; i >= 0; --i)
    {
        if (V == Vehicles[i])
        {
            Vehicles.Remove(i, 1);

            break;
        }
    }

    //Removes 1 from the count of vehicles in the pool
    for (i = 0; i < Pools.Length; ++i)
    {
        Level.Game.Broadcast(self, V.class @ "vs" @ Pools[i].VehicleClass);

        if (V.class == Pools[i].VehicleClass)
        {
            --Pools[i].ActiveCount;

            //--GRI.VehiclePools[i].ActiveCount;

            break;
        }
    }
}

defaultproperties
{
    SpawnError_None=0
    SpawnError_Fatal=1
    SpawnError_MaxVehicles=2
    SpawnError_Inactive=3
    SpawnError_Cooldown=4
    SpawnError_SpawnLimit=5
    SpawnError_ActiveLimit=6
    SpawnError_PoolInactive=7
    SpawnError_SpawnInactive=8
    SpawnError_Blocked=9
    MaxTeamVehicles(0)=32
    MaxTeamVehicles(1)=32
    MaxDestroyedVehicles=8
}

