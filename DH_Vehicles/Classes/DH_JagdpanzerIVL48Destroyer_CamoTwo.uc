class DH_JagdpanzerIVL48Destroyer_CamoTwo extends DH_JagdpanzerIVL48Destroyer;


static function StaticPrecache(LevelInfo L)
{
    Super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_body_camo3');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_armor_camo3');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_wheels_camo3');
    L.AddPrecacheMaterial(Material'axis_vehicles_tex.Treads.panzer4F2_treads');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex4.int_vehicles.jagdpanzeriv_body_int');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_body_camo3');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_armor_camo3');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_wheels_camo3');
    Level.AddPrecacheMaterial(Material'axis_vehicles_tex.Treads.panzer4F2_treads');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex4.int_vehicles.jagdpanzeriv_body_int');

	Super.UpdatePrecacheMaterials();
}

defaultproperties
{
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_JagdpanzerIVL48CannonPawn_CamoTwo')
     DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc4.Jagdpanzer4.jagdpanzer4_dest483'
     Skins(0)=Texture'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_body_camo3'
     Skins(1)=Texture'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_armor_camo3'
     Skins(2)=Texture'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_wheels_camo3'
}
