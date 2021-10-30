//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================
// Late variant

class DH_SdKfz2519DTransport extends DH_Sdkfz251Transport;

defaultproperties
{
    VehicleNameString="Sd.Kfz.251/9 Ausf.D Stummel"
    ReinforcementCost=4
    VehicleMass=10.0
    bIsApc=true

    Health=500
    HealthMax=500.0
    DisintegrationHealth=-200.0 // increased because other burning properties dont seem to exist on this vehicle type, hence "compensation"
    EngineHealth=300

    VehHitpoints(3)=(PointRadius=25.0,PointScale=1.0,PointBone="Body",PointOffset=(X=-45.0,Y=0.0,Z=15.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)

    DriverPositions(1)=(ViewPitchUpLimit=5000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=11700,ViewNegativeYawLimit=-15000) // reduced limits so driver can't look behind & see wrong interior without Pak40
    DriverPositions(2)=(ViewPitchUpLimit=5000,ViewPitchDownLimit=55500,ViewPositiveYawLimit=12800,ViewNegativeYawLimit=-16000)

    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_SdKfz2519DCannonPawn',WeaponBone="mg_base")

    ExitPositions(1)=(X=-240.0,Y=-30.0,Z=5.0) // pak gunner (same as driver - rear door, left side)

    PassengerPawns(0)=None
    PassengerPawns(1)=None
    PassengerPawns(2)=None
    PassengerPawns(3)=None
    PassengerPawns(4)=None
    PassengerPawns(5)=None

    Mesh=SkeletalMesh'DH_Sdkfz251Halftrack_anm.Sdkfz251_9_body_ext'
    Skins(0)=Texture'DH_VehiclesGE_tex.ext_vehicles.Halftrack_body_camo2'
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.Halftrack.SdKfz251_9D_Destro'

    SpawnOverlay(0)=Texture'DH_InterfaceArt_tex.Vehicles.sdkfz_251_9d'
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.sdkfz2519d_body'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.sdkfz2519d_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.sdkfz2519d_turret_look'

    VehicleHudOccupantsX(0)=0.45
    VehicleHudOccupantsY(0)=0.4
    VehicleHudOccupantsX(1)=0.45
    VehicleHudOccupantsY(1)=0.53
    VehicleHudOccupantsX(2)=0.0
    VehicleHudOccupantsY(2)=0.0
    VehicleHudOccupantsX(3)=0.0
    VehicleHudOccupantsY(3)=0.0
    VehicleHudOccupantsX(4)=0.0
    VehicleHudOccupantsY(4)=0.0
    VehicleHudOccupantsX(5)=0.0
    VehicleHudOccupantsY(5)=0.0
    VehicleHudOccupantsX(6)=0.0
    VehicleHudOccupantsY(6)=0.0
    VehicleHudOccupantsX(7)=0.0
    VehicleHudOccupantsY(7)=0.0

    //AmmoIgnitionProbability=0.75  // 0.75 default
    //EngineToHullFireChance=0.1  //increased from 0.05 for all petrol engines
}
