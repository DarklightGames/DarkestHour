//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_SdKfz251_22Transport extends DH_Sdkfz251Transport;

// Modified to set cannon pawn class, as can't be done in default properties, since as DH_Guns code package isn't compiled until after this package
// Also to remove the MG position & void the PassengerPawns array, as we inherit unwanted positions that can't be used due to the mounted Pak 40
simulated function PostBeginPlay()
{
    // Remove the inherited MG position & riders (note array length adjustment needs to go before the Super)
    PassengerWeapons.Length = 1;
    PassengerPawns.Length = 0;
    VehicleHudOccupantsX.Length = 2;
    VehicleHudOccupantsY.Length = 2;

    super.PostBeginPlay();

    PassengerWeapons[0].WeaponPawnClass = class<VehicleWeaponPawn>(DynamicLoadObject("DH_Guns.DH_SdKfz251_22CannonPawn", class'Class'));
}

defaultproperties
{
    //standart health (same as marder)
    Health=525
    HealthMax=525.0
    EngineHealth=300
    bIsApc=false
    bMustBeTankCommander=true

    //EngineToHullFireChance=0.1  //increased from 0.05 for all petrol engines
    //^ "unknown property"
    DisintegrationHealth=-200.0 // increased because other burning properties dont seem to exist on this vehicle type, hence "compensation"
    VehicleNameString="Sd.Kfz.251/22 Halftrack"
    ReinforcementCost=2
    PassengerWeapons(0)=(WeaponBone="body") // cannon pawn class has to be set in PostBeginPlay() due to build order
    Mesh=SkeletalMesh'DH_Sdkfz251Halftrack_anm.Sdkfz251_22_body_ext'
    Skins(0)=Texture'DH_VehiclesGE_tex.ext_vehicles.Halftrack_body_camo2'
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.Halftrack.SdKfz251_22_Destroyed'

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
