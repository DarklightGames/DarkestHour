//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHConstructionSocketParameters extends Object
    dependson(DHConstructionTypes);

var bool    bLimitLocalRotation;
var Range   LocalRotationYawRange;
var int     CollisionRadiusMax;         // The maximum collision radius allowable. If 0, then there is no limit.
var bool    bShouldDestroyOccupant;    // When true, destroy the occupant of the construction socket when the construction is destroyed.

var array<DHConstructionTypes.SClassFilter> ClassFilters;
var array<DHConstructionTypes.STagFilter> TagFilters;
