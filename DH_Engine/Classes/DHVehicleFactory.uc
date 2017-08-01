//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHVehicleFactory extends ROVehicleFactory
    abstract;

var(ROVehicleFactory)   name    FactoryDepletedEvent; // option for specified event to be triggered if the last vehicle the factory can spawn is killed/destroyed

var     bool    bLastVehicle;            // on the last vehicle this factory is meant to spawn
var     bool    bControlledBySpawnPoint; // flags that this factory is activated or deactivated by a spawn point, based on whether that spawn is active (set by SP)

// Modified to call UpdatePrecacheMaterials(), allowing any subclassed factory materials to be cached
// And we no longer call StaticPrecache on the VehicleClass from here, as that gets done in our UpdatePrecacheMaterials(), so we don't want to do it twice
simulated function PostBeginPlay()
{
    if (Level.NetMode != NM_DedicatedServer)
    {
        UpdatePrecacheMaterials();
    }
}

// Modified so doesn't activate if controlled by a spawn point (similar to if linked to a spawn area)
function Reset()
{
    TotalSpawnedVehicles = 0;

    if (!bUsesSpawnAreas && !bControlledBySpawnPoint)
    {
        SpawnVehicle();
        Activate(TeamNum);
    }
    else
    {
        Deactivate();
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
