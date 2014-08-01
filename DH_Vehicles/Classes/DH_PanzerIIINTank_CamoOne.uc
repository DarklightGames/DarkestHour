//===================================================================
// PanzerIIITank
//
// Copyright (C) 2005 John "Ramm-Jaeger"  Gibson
//
// Panzer 3 light tank class
//===================================================================
class DH_PanzerIIINTank_CamoOne extends DH_PanzerIIINTank;


static function StaticPrecache(LevelInfo L)
{
    super(ROTreadCraft).StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.panzer3_body_camo1');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.panzer3_armor_camo1');
    L.AddPrecacheMaterial(Material'axis_vehicles_tex.Treads.Panzer3_treads');
    L.AddPrecacheMaterial(Material'axis_vehicles_tex.int_vehicles.panzer3_int');
    L.AddPrecacheMaterial(Material'axis_vehicles_tex.int_vehicles.panzer3_int_s');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.panzer3_body_camo1');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.panzer3_armor_camo1');
    Level.AddPrecacheMaterial(Material'axis_vehicles_tex.Treads.Panzer3_treads');
    Level.AddPrecacheMaterial(Material'axis_vehicles_tex.int_vehicles.panzer3_int');
    Level.AddPrecacheMaterial(Material'axis_vehicles_tex.int_vehicles.panzer3_int_s');

    super(ROTreadCraft).UpdatePrecacheMaterials();
}

defaultproperties
{
     bHasAddedSideArmor=true
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_PanzerIIINCannonPawn_CamoOne')
     Skins(1)=Texture'DH_VehiclesGE_tex2.ext_vehicles.panzer3_armor_camo1'
}
