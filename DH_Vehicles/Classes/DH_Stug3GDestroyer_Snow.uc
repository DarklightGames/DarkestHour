//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_Stug3GDestroyer_Snow extends DH_Stug3GDestroyer;

#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex3.utx

defaultproperties
{
    bHasAddedSideArmor=true
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.Stug3.stug3g_dest3'
    Skins(0)=texture'DH_VehiclesGE_tex3.ext_vehicles.stug3g_body_snow'
    Skins(1)=texture'DH_VehiclesGE_tex3.ext_vehicles.stug3g_armor_snow'
    // TODO: get snow treads made for StuG & add here (same in factory class & other StuG/StuH winter variants)
    CannonSkins(0)=texture'DH_VehiclesGE_tex3.ext_vehicles.stug3g_body_snow'
}
