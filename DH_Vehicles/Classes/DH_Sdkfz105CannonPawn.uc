//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Sdkfz105CannonPawn extends DH_Flak38CannonPawn;

// Modified to skip over the Super in DHATGunCannonPawn, so gunner can switch positions
simulated function SwitchWeapon(byte F)
{
    super(DHVehicleCannonPawn).SwitchWeapon(F);
}

defaultproperties
{
    GunClass=class'DH_Vehicles.DH_Sdkfz105Cannon'
    PositionInArray=1
}
