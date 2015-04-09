//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHVehicleFactory extends ROVehicleFactory
    abstract;

var() name FactoryDepletedEvent;

function SpawnVehicle()
{
    super.SpawnVehicle();

    if (FactoryDepletedEvent != '' && TotalSpawnedVehicles >= VehicleRespawnLimit)
    {
        TriggerEvent(FactoryDepletedEvent, self, none);
    }
}

// Matt: emptied out as we call StaticPrecache on the VehicleClass in PostBeginPlay(), so we don't want to do it twice
simulated function UpdatePrecacheMaterials()
{
}

defaultproperties
{
}
