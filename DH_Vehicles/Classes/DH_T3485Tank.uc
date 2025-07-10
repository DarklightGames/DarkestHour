//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_T3485Tank extends DH_T3476Tank;

defaultproperties
{
    VehicleNameString="T34/85"
    ReinforcementCost=6
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_T3485CannonPawn')
    PassengerWeapons(1)=(WeaponPawnClass=Class'DH_T3485MountedMGPawn')
    Skins(0)=Texture'allies_vehicles_tex.T3485_ext'
    Skins(1)=Texture'allies_vehicles_tex.T3485_treads'
    Skins(2)=Texture'allies_vehicles_tex.T3485_treads'
    Skins(3)=Texture'allies_vehicles_tex.T3485_int'
    HighDetailOverlay=Shader'allies_vehicles_tex.T3485_int_s'
    DestroyedVehicleMesh=StaticMesh'allies_vehicles_stc.T3485_Destroyed'
    DestroyedMeshSkins(0)=Combiner'DH_VehiclesSOV_tex.T3485_ext_dest'
    DestroyedMeshSkins(1)=Combiner'DH_VehiclesSOV_tex.T3485_treads_dest'
    DriveAnim="Vt3485_driver_idle_close"
    HUDOverlayClass=Class'T34DriverOverlay'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.t34_85_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.t34_85_turret_look'
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.T34_85'

    // Damage
	// pros: diesel fuel; 5 men crew
	// cons: fuel tanks in crew compartment
    Health=525
    HealthMax=525
    EngineHealth=300

    PlayerFireDamagePer2Secs=12.0 // reduced from 15 for all diesels
    FireDetonationChance=0.045  //reduced from 0.07 for all diesels
    DisintegrationHealth=-1200.0 //diesel
    AmmoIgnitionProbability=0.8 // 0.75 default
}
