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
var int     CollisionRadius;
var int     CollisionHeight;

var DHConstructionTypes.SClassFilter ClassFilters[4];
var DHConstructionTypes.STagFilter TagFilters[4];

defaultproperties
{
    CollisionRadius=32
    CollisionHeight=32
}
