//==============================================================================
// DH_Stug3GDestroyer_CamoOne
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// German Sturmgeschutze III Ausf.G tank destroyer - Camo One
//==============================================================================
class DH_Stug3GDestroyer_CamoOne extends DH_Stug3GDestroyer;


static function StaticPrecache(LevelInfo L)
{
    Super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.stug3G_body_camo1');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.treads.stug3g_treads');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.stug3G_armor_camo1');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.stug3G_body_camo1');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.treads.stug3g_treads');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.stug3G_armor_camo1');

	Super.UpdatePrecacheMaterials();
}

defaultproperties
{
     bHasAddedSideArmor=true
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_Stug3GCannonPawn_CamoOne')
     PassengerWeapons(1)=(WeaponPawnClass=Class'DH_Vehicles.DH_Stug3GMountedMGPawn_CamoOne')
     DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.Stug3.stug3g_dest2'
     Skins(0)=Texture'DH_VehiclesGE_tex2.ext_vehicles.stug3g_body_camo1'
     Skins(1)=Texture'DH_VehiclesGE_tex2.ext_vehicles.stug3g_armor_camo1'
}
