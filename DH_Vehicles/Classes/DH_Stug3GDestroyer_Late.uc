//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_Stug3GDestroyer_Late extends DH_Stug3GDestroyer; // late war version with remote-controlled MG & with saukopf mantlet

defaultproperties
{
    bHasAddedSideArmor=true
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_Stug3GCannonPawn_Late')
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_StuH42MountedMGPawn')
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.Stug3.stug3g_destlate'
    Mesh=SkeletalMesh'DH_Stug3G_anm.StuH_body_ext'
    Skins(0)=texture'DH_VehiclesGE_tex2.ext_vehicles.Stug3g_body_camo2'
    Skins(1)=texture'DH_VehiclesGE_tex2.ext_vehicles.Stug3G_armor_camo2'
    SpawnOverlay(0)=material'DH_InterfaceArt_tex.Vehicles.stug3g_late'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.stug3g_turret_late_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.stug3g_turret_late_look'
}
