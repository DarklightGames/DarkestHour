//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_PantherGTank_CamoThree extends DH_PantherGTank;

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.PantherG_body_camo3');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.PantherG_body_camo3');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_PantherGCannonPawn_CamoThree')
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherG_Destroyed3'
    Skins(0)=texture'DH_VehiclesGE_tex.ext_vehicles.PantherG_body_camo3'
    SchurzenTexture=texture'DH_VehiclesGE_tex.ext_vehicles.PantherG_armor_camo3'
}
