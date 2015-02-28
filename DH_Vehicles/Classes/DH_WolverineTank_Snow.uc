//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_WolverineTank_Snow extends DH_WolverineTank;

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex2.ext_vehicles.M10_body_snow');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex2.ext_vehicles.M10_body_snow');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_WolverineCannonPawn_Snow')
    Skins(0)=texture'DH_VehiclesUS_tex2.ext_vehicles.M10_body_snow'
    Skins(1)=texture'DH_VehiclesUS_tex2.ext_vehicles.M10_turret_snow'
    Skins(4)=texture'DH_VehiclesUS_tex2.ext_vehicles.M10_turret_snow'
}
