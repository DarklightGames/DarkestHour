//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Stug3GDestroyer_Snow extends DH_Stug3GDestroyer;

#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex3.utx

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.stug3G_body_snow');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.treads.stug3g_treads');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.stug3G_armor_snow');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.stug3G_body_snow');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.treads.stug3g_treads');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.stug3G_armor_snow');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
    bHasAddedSideArmor=true
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_Stug3GCannonPawn_Snow')
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_Stug3GMountedMGPawn_Snow')
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.Stug3.stug3g_dest3'
    Skins(0)=texture'DH_VehiclesGE_tex3.ext_vehicles.stug3g_body_snow'
    Skins(1)=texture'DH_VehiclesGE_tex3.ext_vehicles.stug3g_armor_snow'
}
