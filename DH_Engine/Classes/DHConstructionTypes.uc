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
    NoOp,
    Include,
    Exclude
};

struct SConstructionTagLimit
{
    var byte TeamIndex; // Optional team index for when this is needed (e.g., DH_LevelInfo).
    var byte Tag;
    var int Limit;      // The total limit alotted per round. -1 means no limit.
    var int MaxActive;  // The maximum amount active at a time. -1 means no limit.
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
