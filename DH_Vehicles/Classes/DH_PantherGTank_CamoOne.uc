//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_PantherGTank_CamoOne extends DH_PantherGTank;

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_PantherGCannonPawn_CamoOne')
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherG_Destroyed'
    Skins(0)=texture'DH_VehiclesGE_tex.ext_vehicles.PantherG_body_camo1'
    SchurzenTexture=texture'DH_VehiclesGE_tex.ext_vehicles.PantherG_armor_camo1'
}
