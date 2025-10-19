//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// Shared type definitions.
//==============================================================================

class DHConstructionTypes extends Object
    abstract;

enum EConstructionTag
{
    CT_Mortar,
    CT_MortarPit,
};

enum EFilterOperation
{
    Include,
    Exclude
};

struct SClassFilter
{
    var EFilterOperation Operation;
    var class<Actor> Class;
};

struct STagFilter
{
    var EFilterOperation Operation;
    var EConstructionTag Tag;
};
