//==============================================================================
// DH_WolverineTank_Snow
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// M10 American tank destroyer "Wolverine" - winter variant
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
