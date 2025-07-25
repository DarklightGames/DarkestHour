//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Cromwell95mmTank extends DH_CromwellTank;

defaultproperties
{
    VehicleNameString="Cromwell Mk.VI"
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Cromwell95mmCannonPawn')
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.Crommy_95mm_wrecked'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Cromwell_Turret_95mm_Rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Cromwell_Turret_95mm_Look'
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.cromwell_95mm'

	// Damage
	// Cons: high-caliber ammunition is more likely to detonate
	AmmoIgnitionProbability=0.84  // 0.75 default
}
