//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHConstruction_ATGun_Medium extends DHConstruction_Vehicle;

function static class<ROVehicle> GetVehicleClass(int TeamIndex, DH_LevelInfo LI)
{
    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            if (LI != none && LI.Season == SEASON_Autumn)
            {
                return class'DH_Guns.DH_Pak40ATGun_CamoOne';
            }
            else
            {
                return class'DH_Guns.DH_Pak40ATGun';
            }
        case ALLIES_TEAM_INDEX:
            if (LI != none && (LI.AlliedNation == NATION_Britain || LI.AlliedNation == NATION_Canada))
            {
                return class'DH_Guns.DH_6PounderGun';
            }
            else
            {
                return class'DH_Guns.DH_AT57Gun';
            }
    }
}

function UpdateAppearance()
{
    SetDrawType(DT_Mesh);
    LinkMesh(VehicleClass.default.Mesh);
    SetCollisionSize(VehicleClass.default.CollisionRadius, VehicleClass.default.CollisionHeight);
}

defaultproperties
{
    Stages(0)=(Progress=0)
    ProgressMax=4
    PlacementOffset=(Z=24.0)
    SupplyCost=500
}
