//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

// Just a legacy class for backwards compatibility, as DHObjective is now in DH_Engine code package
// That allows it to be accessed by DarkestHourGame, which allows us to have the game access DHObjective variables
// TODO - this class should be removed in some future release when people have had time to convert maps to the new actor
class DH_ObjTerritory extends DHObjective
    hidecategories(Assault,GameObjective,JumpDest,JumpSpot,MothershipHack)
    notplaceable;