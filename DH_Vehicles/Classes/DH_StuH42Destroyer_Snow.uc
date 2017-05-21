//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_StuH42Destroyer_Snow extends DH_StuH42Destroyer;

#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex3.utx

defaultproperties
{
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc2.StuH.Stuh_destsnow'
    Skins(0)=texture'DH_VehiclesGE_tex3.ext_vehicles.stug3g_body_snow'
    Skins(1)=texture'DH_VehiclesGE_tex3.ext_vehicles.stug3g_armor_snow'
    CannonSkins(0)=texture'DH_VehiclesGE_tex3.ext_vehicles.stug3g_body_snow'
}
