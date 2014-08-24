//==============================================================================
// DH_HellcatTank_Snow
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// M18 American tank destroyer "Hellcat" - winter variant
//==============================================================================
class DH_HellcatTank_Snow extends DH_HellcatTank;


static function StaticPrecache(LevelInfo L)
{
        Super.StaticPrecache(L);

        L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex5.ext_vehicles.hellcat_body_snow');
        L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex5.ext_vehicles.hellcat_armor_snow');
        L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex5.ext_vehicles.hellcat_turret_snow');
        L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex5.int_vehicles.hellcat_body_int');
        L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex5.treads.hellcat_treadsnow');
}

simulated function UpdatePrecacheMaterials()
{
        Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex5.ext_vehicles.hellcat_body_snow');
        Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex5.ext_vehicles.hellcat_armor_snow');
        Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex5.ext_vehicles.hellcat_turret_snow');
        Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex5.int_vehicles.hellcat_body_int');
        Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex5.treads.hellcat_treadsnow');

    Super.UpdatePrecacheMaterials();
}

defaultproperties
{
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_HellcatCannonPawn_Snow')
     DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc3.Hellcat.Hellcat_destsnow'
     Skins(0)=Texture'DH_VehiclesUS_tex5.ext_vehicles.hellcat_body_snow'
     Skins(1)=Texture'DH_VehiclesUS_tex5.ext_vehicles.hellcat_armor_snow'
     Skins(2)=Texture'DH_VehiclesUS_tex5.ext_vehicles.hellcat_turret_snow'
     Skins(3)=Texture'DH_VehiclesUS_tex5.Treads.hellcat_treadsnow'
     Skins(4)=Texture'DH_VehiclesUS_tex5.Treads.hellcat_treadsnow'
}
