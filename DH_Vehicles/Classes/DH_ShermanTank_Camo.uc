//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ShermanTank_Camo extends DH_ShermanTank;

#exec OBJ LOAD FILE=..\textures\DH_VehiclesUS_tex2.utx

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.int_vehicles.Sherman_body_int');
    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.int_vehicles.Sherman_body_int2');
    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex2.ext_vehicles.Sherman_body_camo1');
    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.treads.Sherman_treads');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.int_vehicles.Sherman_body_int');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.int_vehicles.Sherman_body_int2');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex2.ext_vehicles.Sherman_body_camo1');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.treads.Sherman_treads');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_ShermanCannonPawn_Camo')
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.Sherman.Sherman_Dest2'
    Skins(0)=Texture'DH_VehiclesUS_tex2.ext_vehicles.Sherman_body_camo1'
}
