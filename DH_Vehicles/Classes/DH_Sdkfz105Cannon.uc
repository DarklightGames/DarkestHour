//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Sdkfz105Cannon extends DH_Flak38Cannon;

// Modified to automatically match the cannon mesh to the vehicle's camo variant
simulated function InitializeVehicleBase()
{
    Skins[0] = Base.Skins[2]; // the texture of the FlaK 38 gun mount on the hull

    super.InitializeVehicleBase();
}

defaultproperties
{
}
