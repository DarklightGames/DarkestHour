//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_MobileDeployVehicles extends DH_VehicleFactory;

var()   bool                bRequiresSLToDrive; //requires a leader to drive the MDV

//modified function to set the spawned vehicle with a custom tag (called by the teleporter)
function SpawnVehicle()
{
    //Call the super
    super.SpawnVehicle();

    //Because RequiresLeader is defaulted to true, lets only change it to false if needed
    if (!bRequiresSLToDrive && LastSpawnedVehicle != none)
    {
        //TODO:
        if (LastSpawnedVehicle.IsA('DH_MobileDeployVehicle_Allies'))
        {
            DH_MobileDeployVehicle_Allies(LastSpawnedVehicle).bMustBeSL = bRequiresSLToDrive;
        }
        else if (LastSpawnedVehicle.IsA('DH_MobileDeployVehicle_UK'))
        {
            DH_MobileDeployVehicle_UK(LastSpawnedVehicle).bMustBeSL = bRequiresSLToDrive;
        }
        else if (LastSpawnedVehicle.IsA('DH_MobileDeployVehicle_Axis'))
        {
            DH_MobileDeployVehicle_Axis(LastSpawnedVehicle).bMustBeSL = bRequiresSLToDrive;
        }
    }
}

defaultproperties
{
    bRequiresSLToDrive=true
}
