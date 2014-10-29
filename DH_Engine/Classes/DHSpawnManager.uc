class DHSpawnManager extends SVehicleFactory;

//-----------------------------------------------------------
// Variables
//-----------------------------------------------------------

struct VehiclePool
{
    var() name              Tag;
    var() class<ROVehicle>  VehicleClass;
    var() bool              bIsInitiallyActive;
    var() float             RespawnTime;                //respawn interval in seconds
    var() byte              MaxSpawns;                  //how many vehicles can be spawned from this pool
    var() byte              MaxActive;                  //how many vehicles from this pool can be active at once

    var() name              OnActivatedEvent;           //event to trigger when pool is activated (also gets triggered when initially activated)
    var() name              OnDeactivatedEvent;         //event to trigger when pool is deactivated (does NOT get triggered when initially deactivated)
    var() name              OnDepletedEvent;            //event to trigger when pool has been depleted (SpawnCount meets or exceeds MaxSpawns)
    var() name              OnVehicleDestroyedEvent;    //event to trigger when vehicle from this pool is destroyed
    var() name              OnVehicleSpawnedEvent;      //event to trigger when vehicle from this pool is spawned

    var bool                bIsActive;
    var float               NextAvailableTime;          //the next time a vehicle from this pool can be spawned
    var byte                SpawnCount;                 //count of vehicles spawned from this pool
    var byte                ActiveCount;                //count of active vehicles spawn from this pool
};

var const byte SpawnError_None;
var const byte SpawnError_Fatal;
var const byte SpawnError_MaxVehicles;
var const byte SpawnError_Cooldown;
var const byte SpawnError_SpawnLimit;
var const byte SpawnError_ActiveLimit;
var const byte SpawnError_PoolInactive;
var const byte SpawnError_SpawnInactive;
var const byte SpawnError_Blocked;
var const byte SpawnError_Failed;
var const byte SpawnError_BadTeamPool;
var const byte SpawnError_BadTeamSpawnPoint;
var const byte SpawnError_TryToDriveFailed;

var const byte SpawnPointType_Infantry;
var const byte SpawnPointType_Vehicles;

var localized array<string> SpawnErrorStrings;

const SpawnPointsMax = 32;
const PoolsMax = 32;

var()       array<VehiclePool>  VehiclePools;
var()       byte                MaxTeamVehicles[2];
var()       byte                MaxDestroyedVehicles;

var         class<LocalMessage> VehicleDestroyedMessageClass;

var private byte                        TeamVehicleCounts[2];
var private array<ROVehicle>            Vehicles;
var private array<DHSpawnPoint>         SpawnPoints;
var private DHGameReplicationInfo       GRI;
var private config bool                 bDebug;

//-----------------------------------------------------------
// Functions
//-----------------------------------------------------------

function PostBeginPlay()
{
    local byte i;
    local DHSpawnPoint SP;

    super.PostBeginPlay();

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI == none)
    {
        Warn("DHGameReplicationInfo is none");

        return;
    }

    foreach AllActors(class'DHSpawnPoint', SP)
    {
        if (SpawnPoints.Length >= SpawnPointsMax)
        {
            Warn("DHSpawnPoint count exceeds" @ SpawnPointsMax);

            break;
        }
    }

    Level.Game.Broadcast(self, "Spawn points length=" @ SpawnPoints.Length);

    //Update GameReplicationInfo
    for (i = 0; i < SpawnPoints.Length; ++i)
    {
        UpdateSpawnPointReplicationInfo(i);
    }

    for (i = 0; i < VehiclePools.Length; ++i)
    {
        SetPoolIsActive(i, VehiclePools[i].bIsInitiallyActive);

        UpdatePoolReplicationInfo(i);
    }

    //TODO: verify uniqueness of VehicleClass in VehiclePools
}

function Reset()
{
    Vehicles.Length = 0;

    super.Reset();
}

function UpdateSpawnPointReplicationInfo(byte SpawnPointIndex)
{
    GRI.SetSpawnPointIsActive(SpawnPointIndex, SpawnPoints[SpawnPointIndex].bIsActive);
    GRI.SetSpawnPointTeamIndex(SpawnPointIndex, SpawnPoints[SpawnPointIndex].TeamIndex);
    GRI.SetSpawnPointLocation(SpawnPointIndex, SpawnPoints[SpawnPointIndex].Location);
    GRI.SpawnPointNames[SpawnPointIndex] = SpawnPoints[SpawnPointIndex].SpawnPointName;
}

function UpdatePoolReplicationInfo(byte PoolIndex)
{
    GRI.SetVehiclePoolVehicleClass(PoolIndex, VehiclePools[PoolIndex].VehicleClass);
    GRI.SetVehiclePoolIsActive(PoolIndex, VehiclePools[PoolIndex].bIsActive);
    GRI.SetVehiclePoolSpawnsRemaining(PoolIndex, GetPoolSpawnsRemaining(PoolIndex));
    GRI.SetVehiclePoolNextAvailableTime(PoolIndex, VehiclePools[PoolIndex].NextAvailableTime);
}

function byte DrySpawnVehicle(DHPlayer C, byte PoolIndex, byte SpawnPointIndex, out int LocationHintIndex)
{
    local int i, j;
    local Pawn P;
    local bool bIsBlocked;
    local array<int> LocationHintIndices;
    local DHSpawnPoint SP;

    if (C == none ||
        PoolIndex < 0 || PoolIndex >= PoolsMax || VehiclePools[PoolIndex].VehicleClass == none ||
        SpawnPointIndex < 0 || SpawnPointIndex >= SpawnPointsMax)
    {
        if (bDebug)
        {
            Level.Game.Broadcast(self, "[DHSM] Fatal error in DrySpawn (either invalid indices passed in or pool's VehicleClass is none)");
        }

        return SpawnError_Fatal;
    }

    SP = SpawnPoints[SpawnPointIndex];

    if (SP == none || SP.Type == ESPT_Vehicles)
    {
        Error("[DHSM] Fatal error, requested spawn point is null or incorrect type");

        return SpawnError_Fatal;
    }

    if (C.GetTeamNum() != VehiclePools[PoolIndex].VehicleClass.default.VehicleTeam)
    {
        if (bDebug)
        {
            Level.Game.Broadcast(self, "[DHSM] Pool team index (" $ VehiclePools[PoolIndex].VehicleClass.default.VehicleTeam $ ") does not match player's (" $ C.GetTeamNum() $ ")");
        }

        return SpawnError_BadTeamPool;
    }

    if (C.GetTeamNum() != SP.TeamIndex)
    {
        if (bDebug)
        {
            Level.Game.Broadcast(self, "[DHSM] Spawn point team index (" $ SP.TeamIndex $ ") does not match player's (" $ C.GetTeamNum() $ ")");
        }

        return SpawnError_BadTeamSpawnPoint;
    }

    if (TeamVehicleCounts[VehiclePools[PoolIndex].VehicleClass.default.VehicleTeam] >= MaxTeamVehicles[VehiclePools[PoolIndex].VehicleClass.default.VehicleTeam])
    {
        if (bDebug)
        {
            Level.Game.Broadcast(self, "[DHSM] Max vehicles (" $ MaxTeamVehicles[VehiclePools[PoolIndex].VehicleClass.default.VehicleTeam] $ ") reached for team" @ VehiclePools[PoolIndex].VehicleClass.default.VehicleTeam);
        }

        return SpawnError_MaxVehicles;
    }

    if (!VehiclePools[PoolIndex].bIsActive)
    {
        if (bDebug)
        {
            Level.Game.Broadcast(self, "[DHSM]" @ VehiclePools[PoolIndex].VehicleClass @ "pool is inactive");
        }

        return SpawnError_PoolInactive;
    }

    if (!SP.bIsActive)
    {
        if (bDebug)
        {
            Level.Game.Broadcast(self, "[DHSM] Spawn point" @ SpawnPointIndex @ "is inactive");
        }

        return SpawnError_SpawnInactive;
    }

    if (Level.TimeSeconds < VehiclePools[PoolIndex].NextAvailableTime)
    {
        if (bDebug)
        {
            Level.Game.Broadcast(self, "[DHSM] Cooldown on" @ VehiclePools[PoolIndex].VehicleClass @ "pool:" @ VehiclePools[PoolIndex].NextAvailableTime - Level.TimeSeconds);
        }

        return SpawnError_Cooldown;
    }

    if (VehiclePools[PoolIndex].SpawnCount >= VehiclePools[PoolIndex].MaxSpawns)
    {
        if (bDebug)
        {
            Level.Game.Broadcast(self, "[DHSM]" @ VehiclePools[PoolIndex].VehicleClass @ "pool is at max spawns (" $ VehiclePools[PoolIndex].MaxSpawns $ ")");
        }

        return SpawnError_SpawnLimit;
    }

    if (VehiclePools[PoolIndex].ActiveCount >= VehiclePools[PoolIndex].MaxActive)
    {
        if (bDebug)
        {
            Level.Game.Broadcast(self, "[DHSM]" @ VehiclePools[PoolIndex].VehicleClass @ "pool is at active limit (" $ VehiclePools[PoolIndex].MaxActive $ ")");
        }

        return SpawnError_ActiveLimit;
    }

    //Initialize with invalid index
    LocationHintIndex = -1;

    if (bDebug)
    {
        Level.Game.Broadcast(self, "SpawnPoints[" $ SpawnPointIndex $ "].LocationHints.Length" @ SpawnPoints[SpawnPointindex].LocationHints.Length);
    }

    //Scramble location hint indices so we don't use the same ones repeatedly
    for (i = 0; i < SP.LocationHints.Length; ++i)
    {
        j = Rand(LocationHintIndices.Length);

        LocationHintIndices.Insert(j, 1);

        LocationHintIndices[j] = i;
    }

    for (i = 0; i < LocationHintIndices.Length; ++i)
    {
        bIsBlocked = false;

        foreach RadiusActors(class'Pawn', P, VehiclePools[PoolIndex].VehicleClass.default.CollisionRadius * 1.25, SP.LocationHints[LocationHintIndices[i]].Location)
        {
            bIsBlocked = true;

            break;
        }

        if (!bIsBlocked)
        {
            LocationHintIndex = LocationHintIndices[i];
        }
    }

    if (LocationHintIndex < 0)
    {
        return SpawnError_Blocked;
    }

    return SpawnError_None;
}

function ROVehicle SpawnVehicle(DHPlayer C, byte PoolIndex, byte SpawnPointIndex, out byte SpawnError)
{
    local int LocationHintIndex;
    local ROVehicle V;
    local DHSpawnPoint SP;
    local DHLocationHint LH;

    SpawnError = SpawnError_Fatal;

    SpawnError = DrySpawnVehicle(C, PoolIndex, SpawnPointIndex, LocationHintIndex);

    SP = SpawnPoints[SpawnPointIndex];

    if (SpawnError != SpawnError_None)
    {
        return none;
    }

    if (LocationHintIndex < 0 || LocationHintIndex >= SP.LocationHints.Length || SP.LocationHints[LocationHintIndex] == none)
    {
        Error("[DHSM] Invalid location hint (either null or index is out of range)");

        SpawnError = SpawnError_Fatal;
        return none;
    }

    LH = SP.LocationHints[LocationHintIndex];

    V = Spawn(VehiclePools[PoolIndex].VehicleClass,,, LH.Location, LH.Rotation);

    if (V == none)
    {
        SpawnError = SpawnError_Failed;
        return none;
    }

    //TODO: spawn the player somewhere way out in left field!
    if (C.Pawn == none || !V.TryToDrive(C.Pawn))
    {
        V.Destroy();

        SpawnError = SpawnError_TryToDriveFailed;
    }
    else
    {
        //ParentFactory must be set after any calls to Destroy are made so that
        //VehicleDestroyed is not called in the event that TryToDrive fails
        V.ParentFactory = self;

        //Add vehicle to vehicles array
        Vehicles[Vehicles.Length] = V;

        //Increment team vehicle count
        ++TeamVehicleCounts[V.default.VehicleTeam];

        //Update pool properties
        SetPoolNextAvailableTime(PoolIndex, Level.TimeSeconds + VehiclePools[PoolIndex].RespawnTime);
        SetPoolActiveCount(PoolIndex, VehiclePools[PoolIndex].ActiveCount + 1);
        SetPoolSpawnCount(PoolIndex, VehiclePools[PoolIndex].SpawnCount + 1);

        if (VehiclePools[PoolIndex].OnVehicleSpawnedEvent != '')
        {
            //Trigger OnVehicleSpawned event
            TriggerEvent(VehiclePools[PoolIndex].OnVehicleSpawnedEvent, none, none);
        }
    }

    return V;
}

event VehicleDestroyed(Vehicle V)
{
    local int i;
    local Controller C;

    super.VehicleDestroyed(V);

    //Removes the destroyed vehicle from the managed vehicles
    for (i = Vehicles.Length - 1; i >= 0; --i)
    {
        if (V == Vehicles[i])
        {
            //Remove vehicle from vehicles array
            Vehicles.Remove(i, 1);

            //Decrement team vehicle count
            --TeamVehicleCounts[ROVehicle(V).default.VehicleTeam];

            break;
        }
    }

    //Removes 1 from the count of vehicles in the pool
    for (i = 0; i < VehiclePools.Length; ++i)
    {
        if (V.class == VehiclePools[i].VehicleClass)
        {
            SetPoolActiveCount(i, VehiclePools[i].ActiveCount - 1);

            if (!IsPoolInfinite(i))
            {
                for (C = Level.ControllerList; C != none; C = C.NextController)
                {
                    if (C.GetTeamNum() == VehiclePools[i].VehicleClass.default.VehicleTeam)
                    {
                        C.BroadcastLocalizedMessage(VehicleDestroyedMessageClass,,,, V);
                    }
                }
            }

            if (VehiclePools[i].OnVehicleDestroyedEvent != '')
            {
                TriggerEvent(VehiclePools[i].OnVehicleDestroyedEvent, none, none);
            }

            if (VehiclePools[i].OnDepletedEvent != '' && GetPoolSpawnsRemaining(i) == 0)
            {
                TriggerEvent(VehiclePools[i].OnDepletedEvent, none, none);
            }

            break;
        }
    }
}

//-----------------------------------------------------------
// Spawn Point Functions
//-----------------------------------------------------------

private function GetSpawnPointIndicesByTag(name SpawnPointTag, out array<byte> SpawnPointIndices)
{
    local int i;

    for (i = 0; i < SpawnPoints.Length; ++i)
    {
        if (SpawnPoints[i].Tag == SpawnPointTag)
        {
            SpawnPointIndices[SpawnPointIndices.Length] = i;
        }
    }
}

private function SetSpawnPointIsActive(int SpawnPointIndex, bool bIsActive)
{
    SpawnPoints[SpawnPointIndex].bIsActive = bIsActive;
    GRI.SetSpawnPointIsActive(SpawnPointIndex, bIsActive);
}

function SetSpawnPointIsActiveByTag(name SpawnPointTag, bool bIsActive)
{
    local int i;
    local array<byte> SpawnPointIndices;

    GetSpawnPointIndicesByTag(SpawnPointTag, SpawnPointIndices);

    for (i = 0; i < SpawnPointIndices.Length; ++i)
    {
        SetSpawnPointIsActive(SpawnPointIndices[i], bIsActive);
    }
}

function ToggleSpawnPointIsActiveByTag(name SpawnPointTag)
{
    local int i;
    local array<byte> SpawnPointIndices;

    GetSpawnPointIndicesByTag(SpawnPointTag, SpawnPointIndices);

    for (i = 0; i < SpawnPointIndices.Length; ++i)
    {
        SetSpawnPointIsActive(SpawnPointIndices[i], !SpawnPoints[SpawnPointIndices[i]].bIsActive);
    }
}

//-----------------------------------------------------------
// Pool Functions
//-----------------------------------------------------------

private function GetPoolIndicesByTag(name PoolTag, out array<byte> PoolIndices)
{
    local int i;

    for (i = 0; i < VehiclePools.Length; ++i)
    {
        if (VehiclePools[i].Tag == PoolTag)
        {
            PoolIndices[PoolIndices.Length] = i;
        }
    }
}

private function SetPoolNextAvailableTime(byte PoolIndex, float NextAvailableTime)
{
    VehiclePools[PoolIndex].NextAvailableTime = NextAvailableTime;
    GRI.SetVehiclePoolNextAvailableTime(PoolIndex, NextAvailableTime);
}

private function SetPoolActiveCount(byte PoolIndex, byte ActiveCount)
{
    VehiclePools[PoolIndex].ActiveCount = ActiveCount;
    GRI.SetVehiclePoolActiveCount(PoolIndex, ActiveCount);
}

private function byte GetPoolSpawnsRemaining(byte PoolIndex)
{
    return VehiclePools[PoolIndex].MaxSpawns - VehiclePools[PoolIndex].SpawnCount;
}

private function SetPoolSpawnCount(byte PoolIndex, byte SpawnCount)
{
    VehiclePools[PoolIndex].SpawnCount = SpawnCount;
    GRI.SetVehiclePoolSpawnsRemaining(PoolIndex, GetPoolSpawnsRemaining(PoolIndex));
}

private function SetPoolMaxSpawns(byte PoolIndex, byte MaxSpawns)
{
    VehiclePools[PoolIndex].MaxSpawns = MaxSpawns;
    GRI.SetVehiclePoolSpawnsRemaining(PoolIndex, GetPoolSpawnsRemaining(PoolIndex));
}

private function SetPoolMaxActive(byte PoolIndex, byte MaxActive)
{
    VehiclePools[PoolIndex].MaxActive = MaxActive;
    GRI.SetVehiclePoolMaxActives(PoolIndex, VehiclePools[PoolIndex].MaxActive);
}

private function AddPoolMaxActive(byte PoolIndex, int Value)
{
    VehiclePools[PoolIndex].MaxActive += Value;
    GRI.SetVehiclePoolMaxActives(PoolIndex, VehiclePools[PoolIndex].MaxActive);
}

private function AddPoolMaxSpawns(byte PoolIndex, int Value)
{
    VehiclePools[PoolIndex].MaxSpawns += Value;
    GRI.SetVehiclePoolSpawnsRemaining(PoolIndex, GetPoolSpawnsRemaining(PoolIndex));
}

private function SetPoolIsActive(int PoolIndex, bool bIsActive)
{
    if (VehiclePools[PoolIndex].bIsActive == bIsActive)
    {
        //no change
        return;
    }

    VehiclePools[PoolIndex].bIsActive = bIsActive;
    GRI.SetVehiclePoolIsActive(PoolIndex, bIsActive);

    if (bIsActive)
    {
        if (VehiclePools[PoolIndex].OnActivatedEvent != '')
        {
            TriggerEvent(VehiclePools[PoolIndex].OnActivatedEvent, none, none);
        }
    }
    else
    {
        if (VehiclePools[PoolIndex].OnDeactivatedEvent != '')
        {
            TriggerEvent(VehiclePools[PoolIndex].OnDeactivatedEvent, none, none);
        }
    }
}

function AddPoolMaxSpawnsByTag(name PoolTag, int Value)
{
    local int i;
    local array<byte> PoolIndices;

    GetPoolIndicesByTag(PoolTag, PoolIndices);

    for (i = 0; i < PoolIndices.Length; ++i)
    {
        AddPoolMaxSpawns(PoolIndices[i], Value);
    }
}

function SetPoolMaxSpawnsByTag(name PoolTag, byte MaxSpawns)
{
    local int i;
    local array<byte> PoolIndices;

    GetPoolIndicesByTag(PoolTag, PoolIndices);

    for (i = 0; i < PoolIndices.Length; ++i)
    {
        SetPoolMaxSpawns(PoolIndices[i], MaxSpawns);
    }
}

function AddPoolMaxActiveByTag(name PoolTag, int Value)
{
    local int i;
    local array<byte> PoolIndices;

    GetPoolIndicesByTag(PoolTag, PoolIndices);

    for (i = 0; i < PoolIndices.Length; ++i)
    {
        AddPoolMaxActive(PoolIndices[i], Value);
    }
}

function SetPoolMaxActiveByTag(name PoolTag, byte Value)
{
    local int i;
    local array<byte> PoolIndices;

    GetPoolIndicesByTag(PoolTag, PoolIndices);

    for (i = 0; i < PoolIndices.Length; ++i)
    {
        SetPoolMaxActive(PoolIndices[i], Value);
    }
}

function SetPoolIsActiveByTag(name PoolTag, bool bIsActive)
{
    local int i;
    local array<byte> PoolIndices;

    GetPoolIndicesByTag(PoolTag, PoolIndices);

    for (i = 0; i < PoolIndices.Length; ++i)
    {
        SetPoolIsActive(PoolIndices[i], bIsActive);
    }
}

function TogglePoolIsActiveByTag(name PoolTag)
{
    local int i;
    local array<byte> PoolIndices;

    GetPoolIndicesByTag(PoolTag, PoolIndices);

    for (i = 0; i < PoolIndices.Length; ++i)
    {
        SetPoolIsActive(PoolIndices[i], !VehiclePools[PoolIndices[i]].bIsActive);
    }
}

function bool IsPoolInfinite(byte PoolIndex)
{
    return VehiclePools[PoolIndex].MaxSpawns == 255;
}

function int GetVehiclePoolCount()
{
    return VehiclePools.Length;
}

function int GetSpawnPointCount()
{
    return SpawnPoints.Length;
}

static function string GetSpawnErrorString(int SpawnError)
{
    //TODO: return correct spawn error strings
    switch (SpawnError)
    {
        case default.SpawnError_None:
        case default.SpawnError_Fatal:
        case default.SpawnError_MaxVehicles:
        case default.SpawnError_Cooldown:
        case default.SpawnError_SpawnLimit:
        case default.SpawnError_ActiveLimit:
        case default.SpawnError_PoolInactive:
        case default.SpawnError_SpawnInactive:
        case default.SpawnError_Blocked:
        case default.SpawnError_Failed:
        case default.SpawnError_BadTeamPool:
        case default.SpawnError_BadTeamSpawnPoint:
        case default.SpawnError_TryToDriveFailed:
            return "ERROR";
    }
}

defaultproperties
{
    bDirectional=false
    DrawScale=3.000000
    SpawnError_None=0
    SpawnError_Fatal=1
    SpawnError_MaxVehicles=2
    SpawnError_Cooldown=3
    SpawnError_SpawnLimit=4
    SpawnError_ActiveLimit=5
    SpawnError_PoolInactive=6
    SpawnError_SpawnInactive=7
    SpawnError_Blocked=8
    SpawnError_Failed=9
    SpawnError_BadTeamPool=10
    SpawnError_BadTeamSpawnPoint=11
    SpawnError_TryToDriveFailed=12
    MaxTeamVehicles(0)=32
    MaxTeamVehicles(1)=32
    MaxDestroyedVehicles=8
    VehicleDestroyedMessageClass=class'DHVehicleDestroyedMessage'
    bDebug=true
    SpawnPointType_Infantry=0
    SpawnPointType_Vehicles=1
}

