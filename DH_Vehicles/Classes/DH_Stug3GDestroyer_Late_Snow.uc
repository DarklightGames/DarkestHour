//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_Stug3GDestroyer_Late_Snow extends DH_Stug3GDestroyer_Late;

#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex3.utx

defaultproperties
{
    Skins(0)=texture'DH_VehiclesGE_tex3.ext_vehicles.stug3g_body_snow'
    Skins(1)=texture'DH_VehiclesGE_tex3.ext_vehicles.stug3g_armor_snow'
    CannonSkins(0)=texture'DH_VehiclesGE_tex3.ext_vehicles.stug3g_body_snow'
    DestroyedMeshSkins(0)=combiner'DH_VehiclesGE_tex3.Destroyed.stug3g_snow_dest'
    DestroyedMeshSkins(1)=combiner'DH_VehiclesGE_tex3.Destroyed.stug3g_snowarmor_dest'
}
