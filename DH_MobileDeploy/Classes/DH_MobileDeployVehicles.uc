//Theel

class DH_MobileDeployVehicles extends DH_VehicleFactory;

var()   bool                bRequiresSLToDrive; //requires a leader to drive the MDV

//modified function to set the spawned vehicle with a custom tag (called by the teleporter)
function SpawnVehicle()
{
    //Call the super
    super.SpawnVehicle();

    //Because RequiresLeader is defaulted to true, lets only change it to false if needed
    if (!bRequiresSLToDrive)
    {
        if (LastSpawnedVehicle != none)
        {
            DH_MobileDeployVehicle_Allies(LastSpawnedVehicle).bMustBeSL = bRequiresSLToDrive;
            DH_MobileDeployVehicle_UK(LastSpawnedVehicle).bMustBeSL = bRequiresSLToDrive;
            DH_MobileDeployVehicle_Axis(LastSpawnedVehicle).bMustBeSL = bRequiresSLToDrive;
        }
    }
}

defaultproperties
{
     bRequiresSLToDrive=true
}
