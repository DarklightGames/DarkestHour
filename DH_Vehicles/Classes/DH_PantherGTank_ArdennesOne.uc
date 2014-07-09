//===================================================================
// DH_Ardennes_PantherG_CamoTank
//===================================================================
class DH_PantherGTank_ArdennesOne extends DH_PantherGTank;


static function StaticPrecache(LevelInfo L)
{
    Super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.PantherG_body_ardennes1');

}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.PantherG_body_ardennes1');
	Super.UpdatePrecacheMaterials();
}

defaultproperties
{
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_PantherGCannonPawn_ArdennesOne')
     DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherG_Destroyed4'
     Skins(0)=Texture'DH_VehiclesGE_tex3.ext_vehicles.PantherG_body_ardennes1'
}
