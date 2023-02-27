//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Stug3GDestroyer_Late extends DH_Stug3GDestroyer; // late war version with remote-controlled MG & with saukopf mantlet

defaultproperties
{
    bHasAddedSideArmor=true
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_Stug3GCannonPawn_Late')
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_StuH42MountedMGPawn')
    Mesh=SkeletalMesh'DH_Stug3G_anm.StuH_body_ext'
    Skins(0)=Texture'DH_VehiclesGE_tex2.ext_vehicles.Stug3g_body_camo2'
    Skins(1)=Texture'DH_VehiclesGE_tex2.ext_vehicles.Stug3G_armor_camo2'
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.Stug3.stug3g_destlate'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.stug3g_turret_late_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.stug3g_turret_late_look'
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.stug3g_late'
}
