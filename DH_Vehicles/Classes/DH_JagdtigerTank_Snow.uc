//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_JagdtigerTank_Snow extends DH_JagdtigerTank;

#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex3.utx

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.jagdtiger_body_snow');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.jagdtiger_skirtwinter');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.jagdtiger_body_snow');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.jagdtiger_skirtwinter');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_JagdtigerCannonPawn_Snow')
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc2.Jagdtiger.Jagdtiger_destsnow'
    Skins(0)=texture'DH_VehiclesGE_tex3.ext_vehicles.JagdTiger_body_snow'
    Skins(4)=texture'DH_VehiclesGE_tex3.ext_vehicles.JagdTiger_skirtwinter'
}
