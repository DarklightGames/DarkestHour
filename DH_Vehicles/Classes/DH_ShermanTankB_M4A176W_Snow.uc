//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ShermanTankB_M4A176W_Snow extends DH_ShermanTankB_M4A176W;

#exec OBJ LOAD FILE=..\textures\DH_VehiclesUS_tex2.utx

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex2.ext_vehicles.Sherman_body_snow');
    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.Treads.M10_treads');
    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex2.ext_vehicles.Sherman76W_turret_snow');
    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.int_vehicles.Sherman_body_int');
    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.int_vehicles.Sherman_hatch_int');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex2.ext_vehicles.Sherman_body_snow');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.Treads.M10_treads');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex2.ext_vehicles.Sherman76W_turret_snow');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.int_vehicles.Sherman_body_int');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.int_vehicles.Sherman_hatch_int');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
     PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_ShermanCannonPawnB_M4A176W_Snow')
     Skins(0)=Texture'DH_VehiclesUS_tex2.ext_vehicles.Sherman_body_snow'
     Skins(1)=Texture'DH_VehiclesUS_tex2.ext_vehicles.Sherman76w_turret_Snow'
}
