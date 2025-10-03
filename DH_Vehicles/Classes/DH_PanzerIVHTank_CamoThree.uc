//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_PanzerIVHTank_CamoThree extends DH_PanzerIVHTank;

defaultproperties
{
    bHasAddedSideArmor=true
    Skins(0)=Texture'DH_VehiclesGE_tex3.Panzer4J_body_camo2'
    Skins(3)=Texture'DH_VehiclesGE_tex.PanzerIV_armor_camo2' // TODO: get a side armour skin made to match the hull camo for this variant
    CannonSkins(0)=Texture'DH_VehiclesGE_tex3.Panzer4J_body_camo2'
    CannonSkins(1)=Texture'DH_VehiclesGE_tex.PanzerIV_armor_camo2'
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.Panzer4H_Destroyed3'
}
