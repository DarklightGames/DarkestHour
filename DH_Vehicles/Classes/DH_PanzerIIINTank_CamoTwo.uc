//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_PanzerIIINTank_CamoTwo extends DH_PanzerIIINTank;

defaultproperties
{
    bHasAddedSideArmor=true
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_PanzerIIINCannonPawn_CamoTwo')
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc2.Panzer3.Panzer3n_destroyed'
    Skins(0)=texture'DH_VehiclesGE_tex2.ext_vehicles.panzer3_body_camo2'
    Skins(1)=texture'DH_VehiclesGE_tex2.ext_vehicles.panzer3_armor_camo2'
}
