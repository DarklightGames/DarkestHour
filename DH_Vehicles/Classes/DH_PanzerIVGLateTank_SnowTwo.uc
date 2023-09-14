//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_PanzerIVGLateTank_SnowTwo extends DH_PanzerIVGLateTank_CamoTwo; // snow topped version of CamoTwo

defaultproperties
{
    bIsWinterVariant=true
    Skins(0)=Texture'DH_VehiclesGE_tex3.ext_vehicles.PanzerIV_body_snow2'
    Skins(1)=Texture'axis_vehicles_tex.Treads.Panzer4F2_treadsnow'
    Skins(2)=Texture'axis_vehicles_tex.Treads.Panzer4F2_treadsnow'
    CannonSkins(0)=Texture'DH_VehiclesGE_tex3.ext_vehicles.PanzerIV_body_snow2'
    CannonSkins(1)=Texture'DH_VehiclesGE_tex3.ext_vehicles.PanzerIV_armor_snow1' // number appears wrong, but is correct
}
