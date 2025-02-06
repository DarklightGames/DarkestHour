//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// Just a container for a list of construction classes and their limits.
//==============================================================================

class DHConstructionLoadout extends Object
    abstract;

struct SConstruction
{
    var class<DHConstruction> ConstructionClass;
    var int Limit;      // The total limit alotted per round. -1 means no limit.
    var int MaxActive;  // The maximum amount active at a time. -1 means no limit.
};

var array<SConstruction> Constructions;

defaultproperties
{
}
