//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_PanzerIVHTank_SnowOne extends DH_PanzerIVHTank;

defaultproperties
{
    bHasAddedSideArmor=true
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_PanzerIVHCannonPawn_SnowOne')
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.Panzer4H.Panzer4H_Destroyed'
    Skins(0)=texture'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_body_snow2'
    Skins(3)=texture'DH_VehiclesGE_tex3.ext_vehicles.PanzerIV_armor_snow1'
}
