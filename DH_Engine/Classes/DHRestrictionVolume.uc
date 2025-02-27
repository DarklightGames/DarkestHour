//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHRestrictionVolume extends Volume;

var()   bool                            bNoSquadRallyPoints;
var()   bool                            bNoConstructions;
var()   array<class<DHConstruction> >   ConstructionClasses;
