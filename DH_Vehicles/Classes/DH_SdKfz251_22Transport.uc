//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_SdKfz251_22Transport extends DH_Sdkfz251Transport;

// Modified to set PassengerWeapons class, as can't be done in default properties, since as DH_Guns code package isn't compiled until after this package
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
    VehicleHudTurret=TexRotator'DH_Artillery_Tex.ATGun_Hud.Pak40_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_Artillery_Tex.ATGun_Hud.Pak40_turret_look'
    PassengerWeapons(0)=(WeaponBone="body")
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.Halftrack.SdKfz251_22_Destroyed'
    DriverPositions(1)=(ViewPitchUpLimit=5000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=11700,ViewNegativeYawLimit=-15000) // reduced limits so driver can't look behind & see wrong interior without Pak40
    DriverPositions(2)=(ViewPitchUpLimit=5000,ViewPitchDownLimit=55500,ViewPositiveYawLimit=12800,ViewNegativeYawLimit=-16000)
    VehicleHudOccupantsX(1)=0.45
    VehicleHudOccupantsY(1)=0.65
    ExitPositions(1)=(X=-240.0,Y=-30.0,Z=5.0) // pak gunner (same as driver - rear door, left side)
    VehicleNameString="Sd.Kfz.251/22 'pakwagen'"
    Mesh=SkeletalMesh'DH_Sdkfz251Halftrack_anm.Sdkfz251_22_body_ext'
    Skins(0)=texture'DH_VehiclesGE_tex.ext_vehicles.Halftrack_body_camo2'
}
