//==============================================================================
// DH_TigerTank_CamoTwo
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// German Panzer VI Ausf. E "Tiger" tank
//==============================================================================
class DH_TigerTank_CamoTwo extends DH_TigerTank_Late;

static function StaticPrecache(LevelInfo L)
{
    Super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.Tiger_body_222');

}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.Tiger_body_222');

	Super.UpdatePrecacheMaterials();
}

defaultproperties
{
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_TigerCannonPawn_CamoTwo')
     DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.Tiger1.Tiger1_222_Destroyed'
     Skins(0)=Texture'DH_VehiclesGE_tex.ext_vehicles.Tiger_body_222'
}
