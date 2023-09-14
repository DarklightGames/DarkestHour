//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_PanzerIIILTank_Camo extends DH_PanzerIIILTank;

defaultproperties
{
    VehicleNameString="Panzer III Ausf.M"

    bHasAddedSideArmor=true
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_PanzerIIILCannonPawn_Camo')
    Skins(0)=Texture'DH_VehiclesGE_tex2.ext_vehicles.panzer3_body_camo1'
    Skins(1)=Texture'DH_VehiclesGE_tex2.ext_vehicles.panzer3_armor_camo1'
    CannonSkins(0)=Texture'DH_VehiclesGE_tex2.ext_vehicles.panzer3_body_camo1'
    CannonSkins(1)=Texture'DH_VehiclesGE_tex2.ext_vehicles.panzer3_armor_camo1'
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc2.Panzer3.Panzer3L_dest'
}
