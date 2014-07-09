//==============================================================================
// DH_Stug3GDestroyer_Snow
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// German Sturmgeschutze III Ausf.G tank destroyer - winter version 2
//==============================================================================
class DH_Stug3GDestroyer_SnowTwo extends DH_Stug3GDestroyer_CamoTwo;

#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex3.utx

static function StaticPrecache(LevelInfo L)
{
    Super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.stug3G_body_snow');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.stug3G_armor_snow');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.stug3G_body_snow');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.stug3G_armor_snow');

    Super.UpdatePrecacheMaterials();
}

defaultproperties
{
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_Stug3GCannonPawn_SnowTwo')
     PassengerWeapons(1)=(WeaponPawnClass=Class'DH_Vehicles.DH_StuH42MountedMGPawn_Snow')
     DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.Stug3.stug3g_destroyed'
     Skins(0)=Texture'DH_VehiclesGE_tex3.ext_vehicles.stug3g_body_snow'
     Skins(1)=Texture'DH_VehiclesGE_tex3.ext_vehicles.stug3g_armor_snow'
}
