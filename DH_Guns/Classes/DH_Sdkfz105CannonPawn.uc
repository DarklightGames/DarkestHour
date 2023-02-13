//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Sdkfz105CannonPawn extends DH_Flak38CannonPawn;

defaultproperties
{
    GunClass=class'DH_Guns.DH_Sdkfz105Cannon'
    PositionInArray=1 // because front seat passenger is passenger pawn zero in this vehicle
}
