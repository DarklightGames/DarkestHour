//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Sdkfz2342ArmoredCar extends DH_Sdkfz2341ArmoredCar;

defaultproperties
{
    ReinforcementCost=4
    VehicleNameString="Sd.Kfz. 234/2 Armored Car"
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Sdkfz2342CannonPawn')
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc3.Puma_dest'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.2342_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.2342_turret_look'
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.sdkfz_234_2'

    // Damage
	// pros: diesel fuel
	// 4 men crew
    Health=525
    HealthMax=525.0
	EngineHealth=300
	AmmoIgnitionProbability=0.65  // 0.75 default
    TurretDetonationThreshold=2000.0 // increased from 1750
    PlayerFireDamagePer2Secs=12.0 // reduced from 15 for all diesels
    FireDetonationChance=0.045  //reduced from 0.07 for all diesels
    DisintegrationHealth=-1200.0 //diesel
}
