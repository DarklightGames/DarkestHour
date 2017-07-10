//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_JagdpanzerIVL48Destroyer_Snow extends DH_JagdpanzerIVL48Destroyer;

#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex5.utx

defaultproperties
{
    Skins(0)=texture'DH_VehiclesGE_tex5.ext_vehicles.jagdpanzeriv_body_snow'
    Skins(1)=texture'DH_VehiclesGE_tex5.ext_vehicles.jagdpanzeriv_armor_snow'
    Skins(2)=texture'DH_VehiclesGE_tex5.ext_vehicles.jagdpanzeriv_wheels_snow'
    Skins(3)=texture'axis_vehicles_tex.Treads.Panzer4F2_treadsnow'
    Skins(4)=texture'axis_vehicles_tex.Treads.Panzer4F2_treadsnow'
    CannonSkins(0)=texture'DH_VehiclesGE_tex5.ext_vehicles.jagdpanzeriv_body_snow'
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc4.Jagdpanzer4.Jagdpanzer4_dest48_snow'
}
