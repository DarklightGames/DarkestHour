//===================================================================
// DH_PantherGTank
//===================================================================
class DH_PantherGTank_CamoOne extends DH_PantherGTank;


static function StaticPrecache(LevelInfo L)
{
    Super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.PantherG_body_camo1');

}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.PantherG_body_camo1');
	Super.UpdatePrecacheMaterials();
}

defaultproperties
{
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_PantherGCannonPawn_CamoOne')
     DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherG_Destroyed'
     Skins(0)=Texture'DH_VehiclesGE_tex.ext_vehicles.PantherG_body_camo1'
}
