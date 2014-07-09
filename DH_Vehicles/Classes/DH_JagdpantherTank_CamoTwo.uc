//===================================================================
// DH_JagdpantherTank
//
// Copyright (C) 2004 John "Ramm-Jaeger"  Gibson
//
// Mighty JagdPanther tank destroyer (E) - Ambush camo pattern
//===================================================================
class DH_JagdpantherTank_CamoTwo extends DH_JagdpantherTank;


static function StaticPrecache(LevelInfo L)
{
    Super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.Jagdpanther_body_ambush');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.treads.jagdpanther_treads');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.int_vehicles.jagdpanther_walls_int');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.int_vehicles.jagdpanther_body_int');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.Jagdpanther_body_ambush');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.treads.jagdpanther_treads');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.int_vehicles.jagdpanther_walls_int');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.int_vehicles.jagdpanther_body_int');

	Super.UpdatePrecacheMaterials();
}

defaultproperties
{
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_JagdpantherCannonPawn_CamoTwo')
     DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc2.Jagdpanther.Jagdpanther_dest2'
     Skins(0)=Texture'DH_VehiclesGE_tex2.ext_vehicles.Jagdpanther_body_ambush'
}
