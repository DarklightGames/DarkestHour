//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHConstruction_HMG extends DHConstruction_Vehicle;

function static class<DHVehicle> GetVehicleClass(DHActorProxy.Context Context)
{
    switch (Context.TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            if (Context.LevelInfo == none) break;

            switch (Context.LevelInfo.AxisNation)
            {
                case NATION_Italy:
                    return class'DH_Guns.DH_Fiat1435Gun';
                default:
                    return none;
            }
        default:
            break;
    }

    return none;
}

defaultproperties
{
    GroupClass=class'DHConstructionGroup_Guns'
    bCanOnlyPlaceOnTerrain=false
    bCanPlaceIndoors=true
    ArcLengthTraceIntervalInMeters=0.125
}
