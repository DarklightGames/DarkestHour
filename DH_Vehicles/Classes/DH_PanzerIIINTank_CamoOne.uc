//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_PanzerIIINTank_CamoOne extends DH_PanzerIIINTank;

defaultproperties
{
    bHasAddedSideArmor=true
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_PanzerIIINCannonPawn_CamoOne')
    Skins(1)=Texture'DH_VehiclesGE_tex2.ext_vehicles.panzer3_armor_camo1'
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc2.Panzer3.Panzer3n_destroyed'
}
