//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// Abstract parent class for each nation's infantry resupply point construction.
//==============================================================================

class DHConstruction_Resupply_Players extends DHConstruction_Resupply
    abstract;

static function class<DHConstruction> GetConstructionClass(DHActorProxy.Context Context)
{
    return Context.LevelInfo.GetTeamNationClass(Context.TeamIndex).default.InfantryResupplyClass;
}

defaultproperties
{
    ResupplyType=RT_Players
    MenuName="Ammo Crate (Infantry)"
    MenuDescription="Provides a resupply point for infantry."
}
