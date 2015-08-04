//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_PanzerIVHTank_CamoTwo extends DH_PanzerIVHTank;

defaultproperties
{
    bHasAddedSideArmor=true
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_PanzerIVHCannonPawn_CamoTwo')
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.Panzer4H.Panzer4H_Destroyed2'
    Skins(0)=texture'DH_VehiclesGE_tex3.ext_vehicles.panzer4J_body_ext'
    Skins(3)=texture'DH_VehiclesGE_tex.ext_vehicles.PanzerIV_armor_camo2'
}
