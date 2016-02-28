//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Sdkfz105Flak38CannonPawn extends DH_Flak38CannonPawn;

defaultproperties
{
    PositionInArray=2

    // TODO: get turret_placement aligned with modified FlaK 38 turret mesh, then delete DH_Sdkfz105Flak38Cannon_TEMP class & delete this line (Matt)
    GunClass=class'DH_Vehicles.DH_Sdkfz105Flak38Cannon_TEMP'
}
