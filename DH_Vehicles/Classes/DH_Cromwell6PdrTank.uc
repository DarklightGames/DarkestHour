//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Cromwell6PdrTank extends DH_CromwellTank;

defaultproperties
{
    VehicleNameString="Cromwell Mk.I"
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Cromwell6PdrCannonPawn')
    Mesh=SkeletalMesh'DH_Cromwell_anm.cromwell6pdr_body_ext'
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.Crommy_6pdr_wrecked'
    ExhaustPipes(0)=(ExhaustPosition=(X=-185.0,Y=30.0,Z=95.0),ExhaustRotation=(Pitch=20000)) // doesn't have exhaust deflector cowl
    ExhaustPipes(1)=(ExhaustPosition=(X=-185.0,Y=-30.0,Z=95.0),ExhaustRotation=(Pitch=20000))
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Cromwell_Turret_6pdr_Rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Cromwell_Turret_6pdr_Look'
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.cromwell_6pdr'

	AmmoIgnitionProbability=0.65  // 0.75 default

}
