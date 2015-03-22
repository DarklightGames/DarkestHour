//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_PantherGTank_SnowOne extends DH_PantherGTank;

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_PantherGCannonPawn_SnowOne')
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherG_Destroyed4'
    Skins(0)=texture'DH_VehiclesGE_tex3.ext_vehicles.PantherG_body_snow1'
    SchurzenTexture=none // we don't have a schurzen skin for this camo variant, so add here if one gets made
}
