//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_PanzerIVJTank_SnowOne extends DH_PanzerIVJTank; // snow topped version of non-camo tank

#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex5.utx

defaultproperties
{
    Skins(0)=texture'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_body_snow1'
    Skins(1)=texture'axis_vehicles_tex.Treads.panzer4F2_treadsnow'
    Skins(2)=texture'axis_vehicles_tex.Treads.panzer4F2_treadsnow'
    CannonSkins(0)=texture'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_body_snow1'
}
