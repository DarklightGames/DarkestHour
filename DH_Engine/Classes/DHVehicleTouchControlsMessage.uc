//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// Usage
// RelatedPRI_1: The PRI of the local player (needed for PlayerController)
// OptionalObject: The vehicle that the player is touching.
//==============================================================================

class DHVehicleTouchControlsMessage extends DHControlsMessage
    abstract;

static function string GetHeaderString(
    optional PlayerReplicationInfo RelatedPRI_1, 
    optional PlayerReplicationInfo RelatedPRI_2, 
    optional Object OptionalObject)
{
    return Vehicle(OptionalObject).VehicleNameString;
}

defaultproperties
{
    Controls(0)=(Keys=("USE"),Text="Enter")
}