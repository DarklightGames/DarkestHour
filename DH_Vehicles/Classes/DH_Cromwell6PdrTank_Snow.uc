//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Cromwell6PdrTank_Snow extends DH_Cromwell6PdrTank;


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
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_Cromwell6PdrCannonPawn_Snow')
     PassengerWeapons(1)=(WeaponPawnClass=Class'DH_Vehicles.DH_CromwellMountedMGPawn_Snow')
     Skins(0)=Texture'DH_VehiclesUK_tex.ext_vehicles.Cromwell_body_snow'
     Skins(1)=Texture'DH_VehiclesUK_tex.ext_vehicles.Cromwell_armor_snow'
}
