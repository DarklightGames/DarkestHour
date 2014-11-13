//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_JacksonTank_Snow extends DH_JacksonTank;

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex5.ext_vehicles.M36_Bodysnow_ext');
    //L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.treads.M10_treads');
    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex5.ext_vehicles.M36_turretsnow_ext');
    //L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.int_vehicles.M10_body_int2');
    //L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.int_vehicles.M10_body_int');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex5.ext_vehicles.M36_Bodysnow_ext');
    //Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.treads.M10_treads');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex5.ext_vehicles.M36_turretsnow_ext');
    //Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.int_vehicles.M10_body_int2');
    //Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.int_vehicles.M10_body_int');

    super.UpdatePrecacheMaterials();
}

DefaultProperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_JacksonCannonPawn_Snow',WeaponBone="Turret_placement")
    Skins(0)=texture'DH_VehiclesUS_tex5.ext_vehicles.M36_Bodysnow_ext'
    Skins(1)=texture'DH_VehiclesUS_tex5.ext_vehicles.M36_turretsnow_ext'
    //Skins(2)=texture'DH_VehiclesUS_tex.int_vehicles.M10_body_int'
    //Skins(3)=texture'DH_VehiclesUS_tex.int_vehicles.M10_body_int2'
    //Skins(4)=texture'DH_VehiclesUS_tex.Treads.M10_treads'
    //Skins(5)=texture'DH_VehiclesUS_tex.Treads.M10_treads'
}
