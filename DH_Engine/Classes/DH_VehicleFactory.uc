//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_VehicleFactory extends ROVehicleFactory
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

defaultproperties
{
}
