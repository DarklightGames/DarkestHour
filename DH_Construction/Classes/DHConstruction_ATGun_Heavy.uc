//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHConstruction_ATGun_Heavy extends DHConstruction_Vehicle;

function static class<ROVehicle> GetVehicleClass(int TeamIndex, DH_LevelInfo LI)
{
    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            return class'DH_Guns.DH_Pak43ATGun';
        case ALLIES_TEAM_INDEX:
            if (LI != none && (LI.AlliedNation == NATION_Britain || LI.AlliedNation == NATION_Canada))
            {
                return class'DH_Guns.DH_17PounderGun';
            }
            break;
    }

    return none;
}

function UpdateAppearance()
{
    SetDrawType(DT_Mesh);
    LinkMesh(VehicleClass.default.Mesh);
    SetCollisionSize(VehicleClass.default.CollisionRadius, VehicleClass.default.CollisionHeight);
}

function static bool CanPlayerBuild(DHPlayer PC)
{
    if (!super.CanPlayerBuild(PC))
    {
        return false;
    }

    if (GetVehicleClass(PC.GetTeamNum(), PC.GetLevelInfo()) == none)
    {
        return false;
    }

    return true;
}

defaultproperties
{
    Stages(0)=(Progress=0)
    ProgressMax=18
    PlacementOffset=(Z=30.0)
}

