//==============================================================================
// DH_Stug3GDestroyer_Snow
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// German Sturmgeschutze III Ausf.G tank destroyer - winter version
//==============================================================================
class DH_Stug3GDestroyer_Snow extends DH_Stug3GDestroyer;

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
     bHasAddedSideArmor=true
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_Stug3GCannonPawn_Snow')
     PassengerWeapons(1)=(WeaponPawnClass=Class'DH_Vehicles.DH_Stug3GMountedMGPawn_Snow')
     DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.Stug3.stug3g_dest3'
     Skins(0)=Texture'DH_VehiclesGE_tex3.ext_vehicles.stug3g_body_snow'
     Skins(1)=Texture'DH_VehiclesGE_tex3.ext_vehicles.stug3g_armor_snow'
}
