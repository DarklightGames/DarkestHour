//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ShermanTank_M4A376W_Snow extends DH_ShermanTank_M4A376W;

#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUS_tex2.utx

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex2.ext_vehicles.ShermanM4A3_ext_snow');
    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex2.ext_vehicles.ShermanM4A3E2_wheels_snow');
    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.int_vehicles.Sherman_hatch_int');
    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.int_vehicles.Sherman_body_int');
    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.Treads.Sherman_treads');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex2.ext_vehicles.ShermanM4A3_ext_snow');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex2.ext_vehicles.ShermanM4A3E2_wheels_snow');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.int_vehicles.Sherman_hatch_int');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.int_vehicles.Sherman_body_int');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.Treads.Sherman_treads');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_ShermanCannonPawn_M4A376W_Snow')
    Skins(0)=texture'DH_VehiclesUS_tex2.ext_vehicles.ShermanM4A3_ext_snow'
    Skins(1)=texture'DH_VehiclesUS_tex2.ext_vehicles.ShermanM4A3E2_wheels_snow'
}
