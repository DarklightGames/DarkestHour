//==============================================================================
// DH_VehicleFactory
// Copyright (C) 2004 Jeffrey Nakai
//
// This class is currently a work-in-progress.  It is based off the
//	ONSVehicleFactory class with certain undesireable features removed.  This
//	class will be expanded as we get a better sense of how the RO vehicles are
//	going to work.  We need to start twisting some arms soon to get vehicle
//	designs from Alan
//==============================================================================
class DH_VehicleFactory extends ROVehicleFactory
	abstract;

var()	name	FactoryDepletedEvent;

function SpawnVehicle()
{
	super.SpawnVehicle();

	if(FactoryDepletedEvent == '')
		return;

	if(TotalSpawnedVehicles >= VehicleRespawnLimit)
		TriggerEvent(FactoryDepletedEvent, self, none);
}

defaultproperties
{
}
