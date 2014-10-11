class DHVehicleManager extends SVehicleFactory;

//-----------------------------------------------------------
// Variables
//-----------------------------------------------------------

struct VehiclePool
{
    var() name              Tag;
    var() class<ROVehicle>  VehicleClass;
    var() bool              bIsInitiallyActive;
    var() float             RespawnTime;
    var() byte              MaxSpawns; //value to determine the overall number of vehicles we can spawn
    var() byte              MaxActive; //value to determine how many active at once

    var() name              OnActivatedEvent;
    var() name              OnDeactivatedEvent;
    var() name              OnDepletedEvent;
    var() name              OnVehicleDestroyedEvent;
    var() name              OnVehicleSpawnedEvent;

    var bool                bIsActive;
    var float               NextAvailableTime;
    var byte                SpawnCount;
    var byte                ActiveCount;
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

var localized array<string> SpawnErrorStrings;

const SpawnPointsMax = 32;
const PoolsMax = 32;

var()       array<VehiclePool>  Pools;
var()       byte                MaxTeamVehicles[2];
var()       byte                MaxDestroyedVehicles;

var         class<LocalMessage> VehicleDestroyedMessageClass;

var private byte                        TeamVehicleCounts[2];
var private array<ROVehicle>            Vehicles;
var private array<DHVehicleSpawnPoint>  SpawnPoints;
var private DHGameReplicationInfo       GRI;
var private config bool                 bDebug;

//-----------------------------------------------------------
// Functions
//-----------------------------------------------------------

function PostBeginPlay()
{
    local byte i;
    local DHVehicleSpawnPoint SP;

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

    Level.Game.Broadcast(self, "Spawn points length=" @ SpawnPoints.Length);

    //Update GameReplicationInfo
    for (i = 0; i < SpawnPoints.Length; ++i)
    {
        UpdateSpawnPointReplicationInfo(i);
    }

    for (i = 0; i < Pools.Length; ++i)
    {
        SetPoolIsActive(i, Pools[i].bIsInitiallyActive);

        UpdatePoolReplicationInfo(i);
    }

    //TODO: verify uniqueness of VehicleClass in Pools
}

function Reset()
{
    Vehicles.Length = 0;

    super.Reset();
}

function UpdateSpawnPointReplicationInfo(byte SpawnPointIndex)
{
    GRI.SetVehicleSpawnPointIsActive(SpawnPointIndex, SpawnPoints[SpawnPointIndex].bIsActive);
    GRI.SetVehicleSpawnPointTeamIndex(SpawnPointIndex, SpawnPoints[SpawnPointIndex].TeamIndex);
    GRI.SetVehicleSpawnPointLocation(SpawnPointIndex, SpawnPoints[SpawnPointIndex].Location);
    GRI.VehicleSpawnPointNames[SpawnPointIndex] = SpawnPoints[SpawnPointIndex].SpawnPointName;
}

function UpdatePoolReplicationInfo(byte PoolIndex)
{
    GRI.SetVehiclePoolVehicleClass(PoolIndex, Pools[PoolIndex].VehicleClass);
    GRI.SetVehiclePoolIsActive(PoolIndex, Pools[PoolIndex].bIsActive);
    GRI.SetVehiclePoolSpawnsRemaining(PoolIndex, GetPoolSpawnsRemaining(PoolIndex));
    GRI.SetVehiclePoolNextAvailableTime(PoolIndex, Pools[PoolIndex].NextAvailableTime);
}

function byte DrySpawn(DHPlayer C, byte PoolIndex, byte SpawnPointIndex, out int LocationHintIndex)
{
    local int i;
    local Pawn P;
    local bool bIsBlocked;

    if (C == none ||
        PoolIndex < 0 || PoolIndex >= PoolsMax || Pools[PoolIndex].VehicleClass == none ||
        SpawnPointIndex < 0 || SpawnPointIndex >= SpawnPointsMax)
    {
        if (bDebug)
        {
            Level.Game.Broadcast(self, "[DHVM] Fatal error in DrySpawn (either invalid indices passed in or pool's VehicleClass is none)");
        }

        return SpawnError_Fatal;
    }

    if (C.GetTeamNum() != Pools[PoolIndex].VehicleClass.default.VehicleTeam)
    {
        if (bDebug)
        {
            Level.Game.Broadcast(self, "[DHVM] Pool team index (" $ Pools[PoolIndex].VehicleClass.default.VehicleTeam $ ") does not match player's (" $ C.GetTeamNum() $ ")");
        }

        return SpawnError_BadTeamPool;
    }

    if (C.GetTeamNum() != SpawnPoints[SpawnPointIndex].TeamIndex)
    {
        if (bDebug)
        {
            Level.Game.Broadcast(self, "[DHVM] Spawn point team index (" $ SpawnPoints[SpawnPointIndex].TeamIndex $ ") does not match player's (" $ C.GetTeamNum() $ ")");
        }

        return SpawnError_BadTeamSpawnPoint;
    }

    if (TeamVehicleCounts[Pools[PoolIndex].VehicleClass.default.VehicleTeam] >= MaxTeamVehicles[Pools[PoolIndex].VehicleClass.default.VehicleTeam])
    {
        if (bDebug)
        {
            Level.Game.Broadcast(self, "[DHVM] Max vehicles (" $ MaxTeamVehicles[Pools[PoolIndex].VehicleClass.default.VehicleTeam] $ ") reached for team" @ Pools[PoolIndex].VehicleClass.default.VehicleTeam);
        }

        return SpawnError_MaxVehicles;
    }

    if (!Pools[PoolIndex].bIsActive)
    {
        if (bDebug)
        {
            Level.Game.Broadcast(self, "[DHVM]" @ Pools[PoolIndex].VehicleClass @ "pool is inactive");
        }

        return SpawnError_PoolInactive;
    }

    if (!SpawnPoints[SpawnPointIndex].bIsActive)
    {
        if (bDebug)
        {
            Level.Game.Broadcast(self, "[DHVM] Spawn point" @ SpawnPointIndex @ "is inactive");
        }

        return SpawnError_SpawnInactive;
    }

    if (Level.TimeSeconds < Pools[PoolIndex].NextAvailableTime)
    {
        if (bDebug)
        {
            Level.Game.Broadcast(self, "[DHVM] Cooldown on" @ Pools[PoolIndex].VehicleClass @ "pool:" @ Pools[PoolIndex].NextAvailableTime - Level.TimeSeconds);
        }

        return SpawnError_Cooldown;
    }

    if (Pools[PoolIndex].SpawnCount >= Pools[PoolIndex].MaxSpawns)
    {
        if (bDebug)
        {
            Level.Game.Broadcast(self, "[DHVM]" @ Pools[PoolIndex].VehicleClass @ "pool is at max spawns (" $ Pools[PoolIndex].MaxSpawns $ ")");
        }

        return SpawnError_SpawnLimit;
    }

    if (Pools[PoolIndex].ActiveCount >= Pools[PoolIndex].MaxActive)
    {
        if (bDebug)
        {
            Level.Game.Broadcast(self, "[DHVM]" @ Pools[PoolIndex].VehicleClass @ "pool is at active limit (" $ Pools[PoolIndex].MaxActive $ ")");
        }

        return SpawnError_ActiveLimit;
    }

    LocationHintIndex = -1;

    if (bDebug)
    {
        Level.Game.Broadcast(self, "SpawnPoints[" $ SpawnPointIndex $ "].LocationHints.Length" @ SpawnPoints[SpawnPointindex].LocationHints.Length);
    }

    for (i = 0; i < SpawnPoints[SpawnPointindex].LocationHints.Length; ++i)
    {
        bIsBlocked = false;

        foreach RadiusActors(class'Pawn', P, Pools[PoolIndex].VehicleClass.default.CollisionRadius * 1.25, SpawnPoints[SpawnPointIndex].LocationHints[i].Location)
        {
            bIsBlocked = true;

            break;
        }

        if (!bIsBlocked)
        {
            LocationHintIndex = i;
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

    SpawnError = SpawnError_Fatal;

    SpawnError = DrySpawn(C, PoolIndex, SpawnPointIndex, LocationHintIndex);

    if (SpawnError != SpawnError_None)
    {
        return none;
    }

    V = Spawn(Pools[PoolIndex].VehicleClass,,, SpawnPoints[SpawnPointindex].LocationHints[LocationHintIndex].Location, SpawnPoints[SpawnPointindex].LocationHints[LocationHintIndex].Rotation);

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
        SetPoolNextAvailableTime(PoolIndex, Level.TimeSeconds + Pools[PoolIndex].RespawnTime);
        SetPoolActiveCount(PoolIndex, Pools[PoolIndex].ActiveCount + 1);
        SetPoolSpawnCount(PoolIndex, Pools[PoolIndex].SpawnCount + 1);

        if (Pools[PoolIndex].OnVehicleSpawnedEvent != '')
        {
            //Trigger OnVehicleSpawned event
            TriggerEvent(Pools[PoolIndex].OnVehicleSpawnedEvent, none, none);
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
    for (i = 0; i < Pools.Length; ++i)
    {
        if (V.class == Pools[i].VehicleClass)
        {
            SetPoolActiveCount(i, Pools[i].ActiveCount - 1);

            if (!IsPoolInfinite(i))
            {
                for (C = Level.ControllerList; C != none; C = C.NextController)
                {
                    if (C.GetTeamNum() == Pools[i].VehicleClass.default.VehicleTeam)
                    {
                        C.BroadcastLocalizedMessage(VehicleDestroyedMessageClass,,,, V);
                    }
                }
            }

            if (Pools[i].OnVehicleDestroyedEvent != '')
            {
                TriggerEvent(Pools[i].OnVehicleDestroyedEvent, none, none);
            }

            if (Pools[i].OnDepletedEvent != '' && GetPoolSpawnsRemaining(i) == 0)
            {
                TriggerEvent(Pools[i].OnDepletedEvent, none, none);
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
    GRI.SetVehicleSpawnPointIsActive(SpawnPointIndex, bIsActive);
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

    for (i = 0; i < Pools.Length; ++i)
    {
        if (Pools[i].Tag == PoolTag)
        {
            PoolIndices[PoolIndices.Length] = i;
        }
    }
}

private function SetPoolNextAvailableTime(byte PoolIndex, float NextAvailableTime)
{
    Pools[PoolIndex].NextAvailableTime = NextAvailableTime;
    GRI.SetVehiclePoolNextAvailableTime(PoolIndex, NextAvailableTime);
}

private function SetPoolActiveCount(byte PoolIndex, byte ActiveCount)
{
    Pools[PoolIndex].ActiveCount = ActiveCount;
    GRI.SetVehiclePoolActiveCount(PoolIndex, ActiveCount);
}

private function byte GetPoolSpawnsRemaining(byte PoolIndex)
{
    Level.Game.Broadcast(self, Pools[PoolIndex].MaxSpawns @ Pools[PoolIndex].SpawnCount);

    return Pools[PoolIndex].MaxSpawns - Pools[PoolIndex].SpawnCount;
}

private function SetPoolSpawnCount(byte PoolIndex, byte SpawnCount)
{
    Pools[PoolIndex].SpawnCount = SpawnCount;
    GRI.SetVehiclePoolSpawnsRemaining(PoolIndex, GetPoolSpawnsRemaining(PoolIndex));
}

private function SetPoolMaxSpawns(byte PoolIndex, byte MaxSpawns)
{
    Pools[PoolIndex].MaxSpawns = MaxSpawns;
    GRI.SetVehiclePoolSpawnsRemaining(PoolIndex, GetPoolSpawnsRemaining(PoolIndex));
}

private function SetPoolMaxActive(byte PoolIndex, byte MaxActive)
{
    Pools[PoolIndex].MaxActive = MaxActive;
    GRI.SetVehiclePoolMaxActives(PoolIndex, Pools[PoolIndex].MaxActive);
}

private function AddPoolMaxActive(byte PoolIndex, int Value)
{
    Pools[PoolIndex].MaxActive += Value;
    GRI.SetVehiclePoolMaxActives(PoolIndex, Pools[PoolIndex].MaxActive);
}

private function AddPoolMaxSpawns(byte PoolIndex, int Value)
{
    Pools[PoolIndex].MaxSpawns += Value;
    GRI.SetVehiclePoolSpawnsRemaining(PoolIndex, GetPoolSpawnsRemaining(PoolIndex));
}

private function SetPoolIsActive(int PoolIndex, bool bIsActive)
{
    if (Pools[PoolIndex].bIsActive == bIsActive)
    {
        //no change
        return;
    }

    Pools[PoolIndex].bIsActive = bIsActive;
    GRI.SetVehiclePoolIsActive(PoolIndex, bIsActive);

    if (bIsActive)
    {
        if (Pools[PoolIndex].OnActivatedEvent != '')
        {
            TriggerEvent(Pools[PoolIndex].OnActivatedEvent, none, none);
        }
    }
    else
    {
        if (Pools[PoolIndex].OnDeactivatedEvent != '')
        {
            TriggerEvent(Pools[PoolIndex].OnDeactivatedEvent, none, none);
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
        SetPoolIsActive(PoolIndices[i], !Pools[PoolIndices[i]].bIsActive);
    }
}

function bool IsPoolInfinite(byte PoolIndex)
{
    return Pools[PoolIndex].MaxSpawns == 255;
}

static function string GetSpawnErrorString(int SpawnError)
{
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
}

