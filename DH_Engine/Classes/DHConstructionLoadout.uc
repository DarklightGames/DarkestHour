//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// Just a container for a list of construction classes and their limits.
//==============================================================================

class DHConstructionLoadout extends Object
    dependson(DHConstructionTypes)
    abstract;

struct SConstruction
{
    var class<DHConstruction> ConstructionClass;
    var int Limit;      // The total limit alotted per round. -1 means no limit.
    var int MaxActive;  // The maximum amount active at a time. -1 means no limit.
    var byte Tag;       // Optional tag to group similar constructions together for limit purposes. 0 means no tag.
};

struct STagLimit
{
    var byte Tag;
    var int Limit;      // The total limit alotted per round. -1 means no limit.
    var int MaxActive;  // The maximum amount active at a time. -1 means no limit.
};

var array<SConstruction> Constructions;
var array<Class<DHConstructionLoadout> > Loadouts;
var array<DHConstructionTypes.SConstructionTagLimit> TagLimits;

// static function byte GetConstructionTag(class<DHConstruction> ConstructionClass)
// {
//     local int i;

//     for (i = 0; i < Constructions.Length; i++)
//     {
//         if (Constructions[i].ConstructionClass == ConstructionClass)
//         {
//             return Constructions[i].Tag;
//         }
//     }

//     return 0;
// }
