//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_TigerTank_Ardennes extends DH_TigerTank_Late;

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.tiger_body_ardennes');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.tiger_body_ardennes');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_TigerCannonPawn_Ardennes')
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.Tiger1.Tiger1_Destroyed'
    Skins(0)=texture'DH_VehiclesGE_tex3.ext_vehicles.tiger_body_ardennes'
}
