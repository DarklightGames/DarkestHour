//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_PanzerIVJTank_SnowTwo extends DH_PanzerIVJTank; // snow topped version of CamoOne

#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex5.utx

defaultproperties
{
    Skins(0)=texture'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_body_snow2'
    Skins(1)=texture'axis_vehicles_tex.Treads.panzer4F2_treadsnow'
    Skins(2)=texture'axis_vehicles_tex.Treads.panzer4F2_treadsnow'
    Skins(7)=texture'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_armor_camo1'
    CannonSkins(0)=texture'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_body_snow2'
    CannonSkins(1)=texture'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_armor_camo1'
}
