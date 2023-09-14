//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHRestrictionVolume extends Volume;

var()   bool                            bNoSquadRallyPoints;
var()   bool                            bNoConstructions;
var()   array<class<DHConstruction> >   ConstructionClasses;
