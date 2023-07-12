//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHMapIconAttachment_Resupply extends DHMapIconAttachment
    dependson(DHResupplyAttachment)
    notplaceable;

var Material IconMaterialVehicle;
var float    IconScaleVehicle;

var private DHResupplyStrategy.EResupplyType ResupplyType;

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        ResupplyType;
}

final function DHResupplyStrategy.EResupplyType GetResupplyType()
{
    return ResupplyType;
}

final function SetResupplyType(DHResupplyStrategy.EResupplyType ResupplyType)
{
    self.ResupplyType = ResupplyType;
}

function EVisibleFor GetVisibility()
{
    return VISIBLE_Team;
}

function EVisibleFor GetVisibilityInDangerZone()
{
    return VISIBLE_All;
}

simulated function Material GetIconMaterial(DHPlayer PC)
{
    switch (ResupplyType)
    {
        case RT_Players:
            return default.IconMaterial;
        case RT_Vehicles:
            return default.IconMaterialVehicle;
        default:
            return default.IconMaterial;
    }
}

simulated function float GetIconScale(DHPlayer PC)
{
    switch (ResupplyType)
    {
        case RT_Players:
            return IconScale;
        case RT_Vehicles:
            return IconScaleVehicle;
        default:
            return IconScale;
    }
}

defaultproperties
{
    IconMaterial=Texture'DH_InterfaceArt2_tex.Icons.munitions_infantry'
    IconScale=0.05

    IconMaterialVehicle=Texture'DH_InterfaceArt2_tex.Icons.munitions_vehicle'
    IconScaleVehicle=0.05
}
