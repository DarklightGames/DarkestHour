//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHConstruction_Resupply_Players extends DHConstruction_Resupply;

static function StaticMesh GetConstructedStaticMesh(DHActorProxy.Context Context)
{
    local class<DHNation> NationClass;

    NationClass = Context.LevelInfo.GetTeamNationClass(Context.TeamIndex);

    if (NationClass != none)
    {
        return NationClass.default.InfantryResupplyStaticMesh;
    }
    
    return none;
}

defaultproperties
{
    ResupplyType=RT_Players
    MenuName="Ammo Crate (Infantry)"
    MenuDescription="Provides a resupply point for infantry."
}

