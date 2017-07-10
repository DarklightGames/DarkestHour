//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_PanzerIIILTank_Camo extends DH_PanzerIIILTank;

#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex2.utx

defaultproperties
{
    bHasAddedSideArmor=true
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_PanzerIIILCannonPawn_Camo')
    Skins(1)=texture'DH_VehiclesGE_tex2.ext_vehicles.panzer3_armor_camo1'
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc2.Panzer3.Panzer3L_dest'
}
