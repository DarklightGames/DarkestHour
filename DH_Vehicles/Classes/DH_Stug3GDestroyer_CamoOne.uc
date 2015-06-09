//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Stug3GDestroyer_CamoOne extends DH_Stug3GDestroyer;

defaultproperties
{
    bHasAddedSideArmor=true
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_Stug3GCannonPawn_CamoOne')
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.Stug3.stug3g_dest2'
    Skins(0)=texture'DH_VehiclesGE_tex2.ext_vehicles.stug3g_body_camo1'
    Skins(1)=texture'DH_VehiclesGE_tex2.ext_vehicles.stug3g_armor_camo1'
}
