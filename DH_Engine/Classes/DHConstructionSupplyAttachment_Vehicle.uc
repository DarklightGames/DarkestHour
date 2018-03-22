//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHConstructionSupplyAttachment_Vehicle extends DHConstructionSupplyAttachment;

simulated function string GetHumanReadableName()
{
    local ROVehicle ROV;

    ROV = ROVehicle(Base);

    if (ROV != none)
    {
        return ROV.VehicleNameString @ super.GetHumanReadableName();
    }

    return super.GetHumanReadableName();
}

defaultproperties
{
    bCanBeResupplied=true
    bShouldMapIconBeRotated=true
    MapIcon=Texture'DH_GUI_Tex.GUI.supply_point'
}

