//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_StuH42Destroyer extends DH_Stug3GDestroyer;

defaultproperties
{
    VehicleNameString="StuH42 Ausf.G"
    bHasAddedSideArmor=true
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_StuH42CannonPawn')
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_StuH42MountedMGPawn')
    Mesh=SkeletalMesh'DH_Stug3G_anm.StuH_body_ext'
    Skins(1)=texture'DH_VehiclesGE_tex2.ext_vehicles.stug3g_armor_camo1'
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc2.StuH.Stuh_dest'
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.stuh42_body'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.stuh42_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.stuh42_turret_look'
    SpawnOverlay(0)=material'DH_InterfaceArt_tex.Vehicles.stuh42'
}
