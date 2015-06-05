//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Stug3GDestroyer_Late_Snow extends DH_Stug3GDestroyer_Late;

#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex3.utx

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_Stug3GCannonPawn_Late_Snow')
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_StuH42MountedMGPawn_Snow')
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.Stug3.stug3g_destroyed'
    Skins(0)=texture'DH_VehiclesGE_tex3.ext_vehicles.stug3g_body_snow'
    Skins(1)=texture'DH_VehiclesGE_tex3.ext_vehicles.stug3g_armor_snow'
}
