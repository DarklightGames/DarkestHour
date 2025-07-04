//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Stug3GDestroyer_Late extends DH_Stug3GDestroyer; // late war version with remote-controlled MG & with saukopf mantlet

defaultproperties
{
    bHasAddedSideArmor=true
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Stug3GCannonPawn_Late')
    PassengerWeapons(1)=(WeaponPawnClass=Class'DH_StuH42MountedMGPawn')
    Mesh=SkeletalMesh'DH_Stug3G_anm.StuH_body_ext'
    Skins(0)=Texture'DH_VehiclesGE_tex2.Stug3g_body_camo2'
    Skins(1)=Texture'DH_VehiclesGE_tex2.Stug3G_armor_camo2'
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.stug3g_destlate'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.stug3g_turret_late_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.stug3g_turret_late_look'
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.stug3g_late'
}
