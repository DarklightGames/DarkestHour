//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_PanzerIVHTank_CamoOne extends DH_PanzerIVHTank;

defaultproperties
{
    bHasAddedSideArmor=true
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_PanzerIVHCannonPawn_CamoOne')
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.Panzer4H.Panzer4H_Destroyed'
    VehicleHudImage=texture'InterfaceArt2_tex.Tank_Hud.panzer4H_body'
    Skins(3)=texture'DH_VehiclesGE_tex.ext_vehicles.PanzerIV_armor_camo1'
}
