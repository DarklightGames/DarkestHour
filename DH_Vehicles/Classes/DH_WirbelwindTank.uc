//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_WirbelwindTank extends DH_PanzerIVGLateTank;

defaultproperties
{
    VehicleNameString="Flakpanzer IV 'Wirbelwind'"
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_WirbelwindCannonPawn')
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.wirbelwind_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.wirbelwind_turret_look'
    SpawnOverlay(0)=Texture'DH_InterfaceArt_tex.wirbelwind'

    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc4.Wirbelwind_destro'

	// Damage
	// compared to pz4: 20mm ammo was unlikely to explode
	AmmoIgnitionProbability=0.2  // 0.75 default
    TurretDetonationThreshold=5000.0 // increased from 1750
}

