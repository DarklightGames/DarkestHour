//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PantherGTank_ArdennesTwo extends DH_PantherGTank;

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.PantherG_body_ardennes2');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.PantherG_body_ardennes2');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_PantherGCannonPawn_ArdennesTwo')
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherG_Destroyed5'
    Skins(0)=Texture'DH_VehiclesGE_tex3.ext_vehicles.PantherG_body_ardennes2'
    SchurzenTexture=texture'DH_VehiclesGE_tex3.ext_vehicles.PantherG_armor_ardennes2'
}
