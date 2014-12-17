//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Stug3GDestroyer_SnowTwo extends DH_Stug3GDestroyer_CamoTwo;

#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex3.utx

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.stug3G_body_snow');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.stug3G_armor_snow');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.stug3G_body_snow');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.stug3G_armor_snow');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_Stug3GCannonPawn_SnowTwo')
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_StuH42MountedMGPawn_Snow')
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.Stug3.stug3g_destroyed'
    Skins(0)=texture'DH_VehiclesGE_tex3.ext_vehicles.stug3g_body_snow'
    Skins(1)=texture'DH_VehiclesGE_tex3.ext_vehicles.stug3g_armor_snow'
}
