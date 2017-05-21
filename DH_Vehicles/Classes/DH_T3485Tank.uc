//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_T3485Tank extends DH_T3476Tank;

defaultproperties
{
    VehicleNameString="T34/85"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_T3485CannonPawn')
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_T3485MountedMGPawn')
    Skins(0)=texture'allies_vehicles_tex.ext_vehicles.T3485_ext'
    Skins(1)=texture'allies_vehicles_tex.Treads.T3485_treads'
    Skins(2)=texture'allies_vehicles_tex.Treads.T3485_treads'
    Skins(3)=texture'allies_vehicles_tex.int_vehicles.T3485_int'
    HighDetailOverlay=shader'allies_vehicles_tex.int_vehicles.T3485_int_s'
    DestroyedVehicleMesh=StaticMesh'allies_vehicles_stc.T3485_Destroyed'
    DestroyedMeshSkins(0)=combiner'DH_VehiclesSOV_tex.Destroyed.T3485_ext_dest'
    DriveAnim="Vt3485_driver_idle_close"
    HUDOverlayClass=class'ROVehicles.T34DriverOverlay'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.t34_85_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.t34_85_turret_look'
    SpawnOverlay(0)=material'DH_InterfaceArt_tex.Vehicles.T34_85'
}
