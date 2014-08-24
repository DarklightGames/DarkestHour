//==============================================================================
// DH_CromwellTank_Snow
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// British Cruiser Tank Mk.VIII Cromwell Mk.IV - winter variant
//==============================================================================
class DH_CromwellTank_Snow extends DH_CromwellTank;


static function StaticPrecache(LevelInfo L)
{
    Super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesUK_Tex.ext_vehicles.Cromwell_body_snow');
    L.AddPrecacheMaterial(Material'DH_VehiclesUK_Tex.ext_vehicles.Cromwell_armor_snow');
    L.AddPrecacheMaterial(Material'DH_VehiclesUK_Tex.treads.Cromwell_treads');
    L.AddPrecacheMaterial(Material'DH_VehiclesUK_Tex.int_vehicles.Cromwell_body_int2');
    L.AddPrecacheMaterial(Material'DH_VehiclesUK_Tex.int_vehicles.Cromwell_body_int');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesUK_Tex.ext_vehicles.Cromwell_body_snow');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUK_Tex.ext_vehicles.Cromwell_armor_snow');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUK_Tex.treads.Cromwell_treads');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUK_Tex.int_vehicles.Cromwell_body_int2');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUK_Tex.int_vehicles.Cromwell_body_int');

    Super.UpdatePrecacheMaterials();
}

defaultproperties
{
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_CromwellCannonPawn_Snow')
     PassengerWeapons(1)=(WeaponPawnClass=Class'DH_Vehicles.DH_CromwellMountedMGPawn_Snow')
     Skins(0)=Texture'DH_VehiclesUK_tex.ext_vehicles.Cromwell_body_snow'
     Skins(1)=Texture'DH_VehiclesUK_tex.ext_vehicles.Cromwell_armor_snow'
}
