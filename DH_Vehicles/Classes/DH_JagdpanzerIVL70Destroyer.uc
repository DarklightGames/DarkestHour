//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_JagdpanzerIVL70Destroyer extends DH_JagdpanzerIVL48Destroyer;

defaultproperties
{
    VehicleNameString="Jagdpanzer IV/70(V)"
    ReinforcementCost=7
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_JagdpanzerIVL70CannonPawn')
    Mesh=SkeletalMesh'DH_Jagdpanzer4_anm.jagdpanzer4L70_body_ext'
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc4.Jagdpanzer4.Jagdpanzer4_dest70'
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Jagdpanzer4_anm.jagdpanzer4L70_body_int')
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Jagdpanzer4_anm.jagdpanzer4L70_body_int')
    MaxCriticalSpeed=638.0 // 38 kph
    ExhaustPipes(0)=(ExhaustPosition=(X=-190.0,Y=-10.0,Z=36.0),ExhaustRotation=(Pitch=32768,Yaw=0))
    ExhaustPipes(1)=(ExhaustPosition=(X=-190.0,Y=49.0,Z=36.0),ExhaustRotation=(Pitch=32768))
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.JPIVL70_body'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.JPIVL70_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.JPIVL70_turret_look'
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.jagdpanzer_l70'

}
