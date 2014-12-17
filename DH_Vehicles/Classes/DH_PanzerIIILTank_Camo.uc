//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PanzerIIILTank_Camo extends DH_PanzerIIILTank;

#exec OBJ LOAD FILE=..\textures\DH_VehiclesGE_tex2.utx

static function StaticPrecache(LevelInfo L)
{
    super(ROTreadCraft).StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.panzer3_body_camo1');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.panzer3_armor_camo1');
    L.AddPrecacheMaterial(Material'axis_vehicles_tex.Treads.Panzer3_treads');
    L.AddPrecacheMaterial(Material'axis_vehicles_tex.int_vehicles.panzer3_int');
    L.AddPrecacheMaterial(Material'axis_vehicles_tex.int_vehicles.panzer3_int_s');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.gear_stug');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.panzer3_body_camo1');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.panzer3_armor_camo1');
    Level.AddPrecacheMaterial(Material'axis_vehicles_tex.Treads.Panzer3_treads');
    Level.AddPrecacheMaterial(Material'axis_vehicles_tex.int_vehicles.panzer3_int');
    Level.AddPrecacheMaterial(Material'axis_vehicles_tex.int_vehicles.panzer3_int_s');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.gear_stug');

    super(ROTreadCraft).UpdatePrecacheMaterials();
}

defaultproperties
{
    bHasAddedSideArmor=true
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_PanzerIIILCannonPawn_Camo')
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc2.Panzer3.Panzer3L_dest'
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.panzer3n_body'
    Skins(1)=texture'DH_VehiclesGE_tex2.ext_vehicles.panzer3_armor_camo1'
}
