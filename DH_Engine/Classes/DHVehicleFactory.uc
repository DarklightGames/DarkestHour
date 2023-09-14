//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHVehicleFactory extends ROVehicleFactory
    abstract;

var(ROVehicleFactory)   name    FactoryDepletedEvent; // option for specified event to be triggered if the last vehicle the factory can spawn is killed/destroyed

var     bool    bLastVehicle;            // on the last vehicle this factory is meant to spawn
var     bool    bControlledBySpawnPoint; // flags that this factory is activated or deactivated by a spawn point, based on whether that spawn is active (set by SP)

var()   bool    bStartsWithDamagedTreadLeft;
var()   bool    bStartsWithDamagedTreadRight;

// Modified to call UpdatePrecacheMaterials(), allowing any subclassed factory materials to be cached
// And we no longer call StaticPrecache on the VehicleClass from here, as that gets done in our UpdatePrecacheMaterials(), so we don't want to do it twice
simulated function PostBeginPlay()
{
    if (Level.NetMode != NM_DedicatedServer)
    {
        UpdatePrecacheMaterials();
    }
}

// Modified so if factory is controlled by a spawn point, we don't activate or deactivate the factory, instead leaving that to the spawn point
function Reset()
{
    TotalSpawnedVehicles = 0;

    if (!bControlledBySpawnPoint)
    {
        if (bUsesSpawnAreas)
        {
            Deactivate();
        }
        else
        {
            SpawnVehicle();
            Activate(TeamNum);
        }
    }
}

// Modified so if factory is controlled by a spawn point, we add a slight timer delay before a vehicle gets spawned
// This is because at start of round, all actors get Reset(), but factories are left until last as otherwise the vehicles they spawn also get reset & destroyed
// But if controlled by a spawn point, the spawn gets reset earlier & if it's initially active that causes any linked factory to activate & spawn a vehicle
// The vehicle would then get reset too, causing it to destroy itself, so as a workaround we need to add this slight delay before spawning the vehicle
function Activate(ROSideIndex T)
{
    if (!bFactoryActive || TeamNum != T)
    {
        TeamNum = T;
        bFactoryActive = true;
        SpawningBuildEffects = true;

        if (bControlledBySpawnPoint)
        {
            SetTimer(0.5, false);
        }
        else
        {
            Timer();
        }
    }
}

event VehicleDestroyed(Vehicle V)
{
    super.VehicleDestroyed(V);

    if (bLastVehicle)
    {
        TriggerEvent(FactoryDepletedEvent, self, none);
    }
}

// Triggered when the vehicle is actually spawned. Allows for custom overrides
// in subclasses.
function VehicleSpawned(Vehicle V)
{
    local DHArmoredVehicle AV;

    AV = DHArmoredVehicle(V);

    if (AV != none && AV.bHasTreads)
    {
        if (bStartsWithDamagedTreadLeft)
        {
            AV.DamTrack("L");
        }

        if (bStartsWithDamagedTreadRight)
        {
            AV.DamTrack("R");
        }
    }
}

// Modified to trigger any FactoryDepletedEvent when last vehicle is spawned
// Also so factory is owner of spawned vehicle, allowing vehicle to access factory's properties during vehicle's initialization (allows use of leveller-specified properties in factory)
function SpawnVehicle()
{
    local ROLevelInfo ROL;
    local Pawn        P;
    local bool        bBlocked;

    ROL = ROTeamGame(Level.Game).LevelInfo;

    // Don't spawn this vehicle if there are too many already
    if (ROL != none && ROL.bUseVehicleTotalLimits && ROL.OverVehicleLimit(class<ROVehicle>(VehicleClass)))
    {
        bBlocked = true;
    }
    // Otherwise check if vehicle spawn is blocked by another pawn
    else
    {
        foreach CollidingActors(class'Pawn', P, VehicleClass.default.CollisionRadius * 1.25)
        {
            bBlocked = true;
            break;
        }
    }

    // If vehicle can't spawn, try again later
    if (bBlocked)
    {
        SetTimer(1.0, false);
    }
    // Otherwise spawn a vehicle
    else
    {
        LastSpawnedVehicle = Spawn(VehicleClass, self,, Location, Rotation);

        if (LastSpawnedVehicle != none)
        {
            VehicleCount++;
            TotalSpawnedVehicles++;

            if (ROL != none)
            {
                ROL.HandleSpawnedVehicle(class<ROVehicle>(VehicleClass));
            }

            LastSpawnedTime = Level.TimeSeconds;
            LastSpawnedVehicle.SetTeamNum(TeamNum);
            LastSpawnedVehicle.ParentFactory = self;
            LastSpawnedVehicle.SetOwner(none); // reset (vehicle will have completed its own initialization by now)

            // Trigger any FactoryDepletedEvent if factory has reached its vehicle limit
            if (FactoryDepletedEvent != '' && TotalSpawnedVehicles >= VehicleRespawnLimit)
            {
                bLastVehicle = true;
            }

            VehicleSpawned(LastSpawnedVehicle);
        }
        else
        {
            Log("Spawned vehicle failed for" @ self);
        }
    }
}

defaultproperties
{
    RespawnTime=1.0
}
