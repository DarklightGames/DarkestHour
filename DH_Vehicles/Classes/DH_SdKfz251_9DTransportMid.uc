//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_SdKfz251_9DTransportMid extends DH_Sdkfz251Transport;



    //PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_SdKfz251_9DCannonPawn',WeaponBone="mg_base")



    //PassengerPawns(1)=(AttachBone="body",DrivePos=(X=7.5,Y=30.0,Z=41.0),DriveAnim="VUC_rider1_idle")

defaultproperties
{
    //standard health (525 same as marder)
    Health=500
    HealthMax=500.0
    EngineHealth=300
    ReinforcementCost=4

    VehicleMass=10.0

    bIsApc=true

    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_SdKfz251_9DCannonPawnMid',WeaponBone="mg_base")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_StummelMMountedMGPawn',WeaponBone="mg_base")


    PassengerPawns(0)=None
    PassengerPawns(1)=None
    PassengerPawns(2)=None
    PassengerPawns(3)=None
    PassengerPawns(4)=None
    PassengerPawns(5)=None

    //EngineToHullFireChance=0.1  //increased from 0.05 for all petrol engines
    //^ "unknown property"
    DisintegrationHealth=-200.0 // increased because other burning properties dont seem to exist on this vehicle type, hence "compensation"
    VehicleNameString="Sd.Kfz.251/9C Stummel"
    //PassengerWeapons(0)=(WeaponBone="mg_base") // cannon pawn class has to be set in PostBeginPlay() due to build order
    Mesh=SkeletalMesh'DH_Sdkfz251Halftrack_anm.Sdkfz251_9_body_ext'
    Skins(0)=Texture'DH_VehiclesGE_tex.ext_vehicles.Halftrack_body_camo1'
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.Halftrack.SdKfz251_9D_Destro'

    DriverPositions(1)=(ViewPitchUpLimit=5000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=11700,ViewNegativeYawLimit=-15000) // reduced limits so driver can't look behind & see wrong interior without Pak40
    DriverPositions(2)=(ViewPitchUpLimit=5000,ViewPitchDownLimit=55500,ViewPositiveYawLimit=12800,ViewNegativeYawLimit=-16000)
    ExitPositions(1)=(X=-240.0,Y=-30.0,Z=5.0) // pak gunner (same as driver - rear door, left side)
    VehicleHudTurret=TexRotator'DH_Artillery_Tex.ATGun_Hud.Pak40_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_Artillery_Tex.ATGun_Hud.Pak40_turret_look'
    VehicleHudOccupantsX(1)=0.45
    VehicleHudOccupantsY(1)=0.65
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.sdkfz_251_22'

    //Add AMMO HIT BOX for 7.5 cm shell storage
    VehHitpoints(3)=(PointRadius=25.0,PointScale=1.0,PointBone="Body",PointOffset=(X=-45.0,Y=0.0,Z=15.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    //AmmoIgnitionProbability=0.75  // 0.75 default
    //^ "unknown property"

}
