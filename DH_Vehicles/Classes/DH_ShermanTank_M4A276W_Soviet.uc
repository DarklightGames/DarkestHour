//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ShermanTank_M4A276W_Soviet extends DH_ShermanTank_M4A375W;

defaultproperties
{
    VehicleNameString="M4A2(76)W"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_ShermanCannonPawnA_76mm')
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc3.ShermanM4A3.M4A3_762dest'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Sherman76_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Sherman76_turret_look'
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.sherman_m4a3_76w'

    CannonSkins(0)=Texture'DH_VehiclesUS_tex.ext_vehicles.Sherman76w_turret_ext_nosymbols'

    // Sounds
    IdleSound=SoundGroup'Vehicle_Engines.SU76.SU76_engine_loop'  //different sounds because its a diesel engine
    StartUpSound=Sound'Vehicle_Engines.SU76.SU76_engine_start'
    ShutDownSound=Sound'Vehicle_Engines.SU76.SU76_engine_stop'
    LeftTreadSound=Sound'Vehicle_EnginesTwo.UC.UC_tread_L'
    RightTreadSound=Sound'Vehicle_EnginesTwo.UC.UC_tread_R'
    RumbleSoundBone="placeholder_int"
    RumbleSound=Sound'DH_AlliedVehicleSounds.Sherman.inside_rumble01'

    // Visual effects
    ExhaustEffectClass=class'ROEffects.ExhaustDieselEffect' //Sherman M4A2, which was the version with a diesel engine
    ExhaustEffectLowClass=class'ROEffects.ExhaustDieselEffect_simple'


    // Hull mesh
    Mesh=SkeletalMesh'DH_ShermanM4A3_anm.M4A3_body_ext_alt'
    Skins(0)=Texture'DH_VehiclesUS_tex3.ext_vehicles.ShermanM4A2_soviet'

    // Movement
	//different diesel engine
    MaxCriticalSpeed=777.0 // 45 kph
    GearRatios(1)=0.19
    GearRatios(3)=0.62
    GearRatios(4)=0.76
    TransRatio=0.094

    // Damage
	// Compared to A3: diesel fuel
    EngineToHullFireChance=0.05  //standart 0.05 for diesel
    PlayerFireDamagePer2Secs=12.0 // reduced from 15 for all diesels
    FireDetonationChance=0.045  //reduced from 0.07 for all diesels
    DisintegrationHealth=-1400.0 //diesel and wet stowage

	//to do: destroyed textures
}

