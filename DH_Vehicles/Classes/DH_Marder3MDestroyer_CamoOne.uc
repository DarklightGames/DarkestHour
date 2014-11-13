//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Marder3MDestroyer_CamoOne extends DH_Marder3MDestroyer;


static function StaticPrecache(LevelInfo L)
{
        Super.StaticPrecache(L);

        L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex7.ext_vehicles.marder_body_camo1');
        L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex7.ext_vehicles.marder_turret_camo1');
        L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex7.treads.marder_treads');
        L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex7.int_vehicles.marder3m_body_int');
}

simulated function UpdatePrecacheMaterials()
{
        Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex7.ext_vehicles.marder_body_camo1');
        Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex7.ext_vehicles.marder_turret_camo1');
        Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex7.treads.marder_treads');
        Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex7.int_vehicles.marder3m_body_int');

    Super.UpdatePrecacheMaterials();
}

defaultproperties
{
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_Marder3MCannonPawn_CamoOne')
     Skins(0)=Texture'DH_VehiclesGE_tex7.ext_vehicles.marder_turret_camo1'
     Skins(1)=Texture'DH_VehiclesGE_tex7.ext_vehicles.marder_body_camo1'
}
