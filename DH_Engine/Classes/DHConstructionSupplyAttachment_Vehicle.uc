//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
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
    bCanGenerateSupplies=true
    SupplyDepositInterval=15
    SupplyGenerationRate=100
    bShouldShowOnMap=true
}

