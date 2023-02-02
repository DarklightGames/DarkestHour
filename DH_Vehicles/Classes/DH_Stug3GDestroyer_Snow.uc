//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Stug3GDestroyer_Snow extends DH_Stug3GDestroyer;

defaultproperties
{
    bIsWinterVariant=true
    bHasAddedSideArmor=true
    Skins(0)=Texture'DH_VehiclesGE_tex3.ext_vehicles.stug3g_body_snow'
    Skins(1)=Texture'DH_VehiclesGE_tex3.ext_vehicles.stug3g_armor_snow'
    Skins(2)=Texture'DH_VehiclesGE_tex3.Treads.Stug3_treads_snow'
    Skins(3)=Texture'DH_VehiclesGE_tex3.Treads.Stug3_treads_snow'
    CannonSkins(0)=Texture'DH_VehiclesGE_tex3.ext_vehicles.stug3g_body_snow'
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.Stug3.stug3g_dest3'
}
