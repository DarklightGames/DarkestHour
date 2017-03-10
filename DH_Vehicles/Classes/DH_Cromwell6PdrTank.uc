//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_Cromwell6PdrTank extends DH_CromwellTank;

defaultproperties
{
    VehicleNameString="Cromwell Mk.I"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_Cromwell6PdrCannonPawn')
    Mesh=SkeletalMesh'DH_Cromwell_anm.cromwell6pdr_body_ext'
    MaxCriticalSpeed=1165.0 // 69 kph
    ExhaustPipes(0)=(ExhaustPosition=(X=-185.0,Y=30.0,Z=95.0),ExhaustRotation=(Pitch=20000)) // doesn't have exhaust deflector cowl
    ExhaustPipes(1)=(ExhaustPosition=(X=-185.0,Y=-30.0,Z=95.0),ExhaustRotation=(Pitch=20000))
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Cromwell_Turret_6pdr_Rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Cromwell_Turret_6pdr_Look'
    SpawnOverlay(0)=material'DH_InterfaceArt_tex.Vehicles.cromwell_6pdr'
}
