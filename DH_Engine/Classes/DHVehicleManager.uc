class DHVehicleManager extends SVehicleFactory
    notplaceable;

//-----------------------------------------------------------
// Variables
//-----------------------------------------------------------

struct VehiclePool
{
    var class<ROVehicle>   VehicleClass;
    var bool               bIsActive;
    var float              LastSpawnTime;
    var int                SpawnCount;
    var int                ActiveCount;
};

const SpawnError_None = 0;
const SpawnError_Fatal = 1;
const SpawnError_MaxVehicles = 2;
const SpawnError_Inactive = 3;
const SpawnError_Cooldown = 4;
const SpawnError_SpawnLimit = 5;
const SpawnError_ActiveLimit = 6;
const SpawnError_PoolInactive = 7;
const SpawnError_SpawnInactive = 8;
const SpawnError_Blocked = 9;

const SpawnPointsMax = 32;
const PoolsMax = 32;

var   array<Vehicle>               Vehicles;
var   array<VehiclePool>           Pools;
var   array<DHVehicleSpawnPoint>   SpawnPoints;

//-----------------------------------------------------------
// Functions
//-----------------------------------------------------------

function PostBeginPlay()
{
    local int i;
    local DHVehicleSpawnPoint VSP;
    local DHGameReplicationInfo GRI;

    super.PostBeginPlay();

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI == none)
    {
        Warn("DHGameReplicationInfo is none");

        return;
    }

    foreach AllActors(class'DHVehicleSpawnPoint', VSP)
    {
        if (SpawnPoints.Length >= SpawnPointsMax)
        {
            Warn("DHVehicleSpawnPoint count exceeds" @ SpawnPointsMax);

            break;
        }

        SpawnPoints[SpawnPoints.Length] = VSP;
    }

    for (i = 0; i < SpawnPoints.Length; ++i)
    {
        //GRI.VehicleSpawnPoints[i].bIsActive = SpawnPoints[i].bIsActive;
        //GRI.VehicleSpawnPoints[i].TeamIndex = SpawnPoints[i].TeamIndex;
        //GRI.VehicleSpawnPoints[i].Location = SpawnPoints[i].Location;
    }
}

function Reset()
{
    Vehicles.Length = 0;

    super.Reset();
}

function int DrySpawn(byte PoolIndex, byte SpawnPointIndex)
{
    local int i;
    local DH_LevelInfo LI;
    local Pawn P;

    if (DarkestHourGame(Level.Game) != none && DarkestHourGame(Level.Game).DHLevelInfo != none)
    {
        LI = DarkestHourGame(Level.Game).DHLevelInfo;
    }

    if (LI == none ||
        PoolIndex < 0 || PoolIndex >= PoolsMax || Pools[PoolIndex].VehicleClass == none ||
        SpawnPointIndex < 0 || SpawnPointIndex >= SpawnPointsMax)
    {
        return SpawnError_Fatal;
    }

    if (Vehicles.Length >= LI.MaxTeamVehicles[Pools[PoolIndex].VehicleClass.default.VehicleTeam])
    {
        return SpawnError_MaxVehicles;
    }

    if (!Pools[PoolIndex].bIsActive || !SpawnPoints[SpawnPointIndex].bIsActive)
    {
        return SpawnError_Inactive;
    }

    if (Level.TimeSeconds >= Pools[PoolIndex].LastSpawnTime + LI.VehiclePools[PoolIndex].RespawnTime)
    {
        return SpawnError_Cooldown;
    }

    if (Pools[PoolIndex].SpawnCount < LI.VehiclePools[PoolIndex].MaxSpawns)
    {
        return SpawnError_SpawnLimit;
    }

    if (Pools[PoolIndex].ActiveCount < LI.VehiclePools[PoolIndex].MaxActive)
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

function Vehicle SpawnVehicle(byte PoolIndex, byte SpawnPointIndex, out int SpawnError)
{
    local int i;
    local Vehicle V;
    local DHGameReplicationInfo GRI;
    local DH_LevelInfo LI;

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

    LI = DarkestHourGame(Level.Game).DHLevelInfo;

    if (LI == none)
    {
        Warn("DH_LevelInfo is none");
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
            Vehicles[Vehicles.Length] = V;

            //Tell the pool about the vehicle’s existence
            Pools[PoolIndex].LastSpawnTime = Level.TimeSeconds;
            Pools[PoolIndex].ActiveCount += 1;
            Pools[PoolIndex].SpawnCount += 1;

            //Update game replication info
            //GRI.VehiclePools[PoolIndex].NextAvailableTime = Level.TimeSeconds + LI.VehiclePools[PoolIndex].RespawnTime;
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
    local DH_LevelInfo LI;

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

    LI = DarkestHourGame(Level.Game).DHLevelInfo;

    if (LI == none)
    {
        Warn("DH_LevelInfo is none");

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
}

