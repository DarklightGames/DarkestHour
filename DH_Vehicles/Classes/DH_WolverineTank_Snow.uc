//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_WolverineTank_Snow extends DH_WolverineTank;


static function StaticPrecache(LevelInfo L)
{
        Super.StaticPrecache(L);

        L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex2.ext_vehicles.M10_body_snow');
}

simulated function UpdatePrecacheMaterials()
{
        Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex2.ext_vehicles.M10_body_snow');

    Super.UpdatePrecacheMaterials();
}

defaultproperties
{
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_WolverineCannonPawn_Snow')
     Skins(0)=Texture'DH_VehiclesUS_tex2.ext_vehicles.M10_body_snow'
}
