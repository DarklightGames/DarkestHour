//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PanzerIVJTank_CamoOne extends DH_PanzerIVJTank;


static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_body_camo1');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_armor_camo1');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_body_camo1');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_armor_camo1');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
     PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_PanzerIVJCannonPawn_CamoOne')
     Skins(0)=Texture'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_body_camo1'
     Skins(7)=Texture'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_armor_camo1'
}
