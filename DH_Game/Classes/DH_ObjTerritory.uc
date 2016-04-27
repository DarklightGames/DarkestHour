//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

// Legacy support for old objective actor
// This class cannot be moved to DH_Engine package
// DHObjective is in DH_Engine package and can be accessed by DarkestHourGame,
// which allows us to have the game access DHObjective variables

class DH_ObjTerritory extends DHObjective
    hidecategories(Assault,GameObjective,JumpDest,JumpSpot,MothershipHack)
    placeable;

