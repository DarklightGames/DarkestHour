//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// Abstract parent class for each nation's infantry resupply point construction.
//==============================================================================

class DHConstructionResupplyPlayers extends DHConstruction_Resupply
    abstract;

defaultproperties
{
    ResupplyType=RT_Players
    MenuName="Ammo Crate (Infantry)"
    MenuDescription="Provides a resupply point for infantry."
}
