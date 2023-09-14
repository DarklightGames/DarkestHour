//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

// Just a legacy class for backwards compatibility, as DHObjective is now in DH_Engine code package
// That allows it to be accessed by DarkestHourGame, which allows us to have the game access DHObjective variables

// Do not make this notplacable because it deletes the actor on rebuild with no warning or indication!
// At this point this actor should NOT ever be deleted as it would break even official maps.

class DH_ObjTerritory extends DHObjective
    hidecategories(Assault,GameObjective,JumpDest,JumpSpot,MothershipHack)
    placeable;
