//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Tiger2BTank_Ardennes extends DH_Tiger2BTank;

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.Tiger2B_body_ardennes');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.treads.Tiger2B_treads');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.int_vehicles.Tiger2B_body_int');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.Tiger2B_body_ardennes');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.treads.Tiger2B_treads');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.int_vehicles.Tiger2B_body_int');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_Tiger2BCannonPawn_Ardennes')
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc2.Tiger2B.Tiger2B_dest2'
    Skins(0)=texture'DH_VehiclesGE_tex3.ext_vehicles.tiger2B_body_ardennes'
}
