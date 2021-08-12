//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHMapIconAttachment_Resupply extends DHMapIconAttachment
    dependson(DHResupplyAttachment)
    notplaceable;

var Material IconMaterialVehicle;
var float    IconScaleVehicle;

var private DHResupplyAttachment.EResupplyType ResupplyType;

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        ResupplyType;
}

final function DHResupplyAttachment.EResupplyType GetResupplyType()
{
    return ResupplyType;
}

final function SetResupplyType(DHResupplyAttachment.EResupplyType ResupplyType)
{
    self.ResupplyType = ResupplyType;
}

function EVisibleFor GetVisibility()
{
    return VISIBLE_Team;
}

function EVisibleFor GetVisibilityInDangerZone()
{
    return VISIBLE_None;
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
    IconScaleVehicle=0.038
}
