//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_StuH42Destroyer_Snow extends DH_StuH42Destroyer;


#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex3.utx

static function StaticPrecache(LevelInfo L)
{
    Super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.stug3G_body_snow');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.treads.stug3g_treads');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.stug3G_armor_snow');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.stug3G_body_snow');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.treads.stug3g_treads');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.stug3G_armor_snow');

    Super.UpdatePrecacheMaterials();
}

defaultproperties
{
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_StuH42CannonPawn_Snow')
     PassengerWeapons(1)=(WeaponPawnClass=Class'DH_Vehicles.DH_StuH42MountedMGPawn_Snow')
     DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc2.StuH.Stuh_destsnow'
     Skins(0)=Texture'DH_VehiclesGE_tex3.ext_vehicles.stug3g_body_snow'
     Skins(1)=Texture'DH_VehiclesGE_tex3.ext_vehicles.stug3g_armor_snow'
}
