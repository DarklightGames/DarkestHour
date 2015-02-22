//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Stug3GDestroyer_CamoTwo extends DH_Stug3GDestroyer;

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.stug3G_body_camo2');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.treads.stug3g_treads');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.stug3G_armor_camo2');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.stug3G_body_camo2');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.treads.stug3g_treads');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.stug3G_armor_camo2');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
    bHasAddedSideArmor=true
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_Stug3GCannonPawn_CamoTwo')
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_StuH42MountedMGPawn')
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.Stug3.stug3g_destlate'
    Mesh=SkeletalMesh'DH_Stug3G_anm.StuH_body_ext'
    Skins(0)=texture'DH_VehiclesGE_tex2.ext_vehicles.Stug3g_body_camo2'
    Skins(1)=texture'DH_VehiclesGE_tex2.ext_vehicles.Stug3G_armor_camo2'
}
