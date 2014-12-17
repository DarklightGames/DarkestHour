//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PantherGTank_ArdennesOne extends DH_PantherGTank;

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.PantherG_body_ardennes1');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.PantherG_body_ardennes1');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_PantherGCannonPawn_ArdennesOne')
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherG_Destroyed4'
    Skins(0)=texture'DH_VehiclesGE_tex3.ext_vehicles.PantherG_body_ardennes1'
    SchurzenTexture=none // Matt: we don't have a schurzen skin for this camo variant, so add here if one gets made
}
