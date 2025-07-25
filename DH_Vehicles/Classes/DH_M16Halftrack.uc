//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M16Halftrack extends DH_M3Halftrack;

defaultproperties
{
    VehicleNameString="M16 Halftrack"
    Mesh=SkeletalMesh'DH_M3Halftrack_anm.m16_body'
    DestroyedVehicleMesh=StaticMesh'DH_M3Halftrack_stc.m16_destro'

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_M45QuadmountMGPawn',WeaponBone="turret_placement")
    PassengerPawns(0)=(AttachBone="body",DrivePos=(X=40.0,Y=35.0,Z=75.0),DriveAnim="VHalftrack_Rider1_idle")
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-10.0,Y=-30.0,Z=85.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider2_idle")
    PassengerPawns(2)=(AttachBone="body",DrivePos=(X=-45.0,Y=-30.0,Z=85.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider3_idle")
    PassengerPawns(3)=(AttachBone="body",DrivePos=(X=-10.0,Y=30.0,Z=85.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider4_idle")
    PassengerPawns(4)=(AttachBone="body",DrivePos=(X=-45.0,Y=30.0,Z=85.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider5_idle")

    //Damage
    VehHitpoints(5)=(PointRadius=20.0,PointBone="body",PointOffset=(X=-160.0,Y=52.0,Z=80.0),DamageMultiplier=1.5,HitPointType=HP_AmmoStore) // Spare .50 tombstones, won't really explode but incendiaries and propellent might start a fire
    VehHitpoints(6)=(PointRadius=20.0,PointBone="body",PointOffset=(X=-160.0,Y=-52.0,Z=80.0),DamageMultiplier=1.5,HitPointType=HP_AmmoStore)

    // HUD
    VehicleHudImage=Texture'DH_M3Halftrack_tex.m16_body'
    VehicleHudTurret=TexRotator'DH_M3Halftrack_tex.m16_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_M3Halftrack_tex.m16_turret_look'
    VehicleHudOccupantsX(1)=0.50 // quadmount gunner
    VehicleHudOccupantsY(1)=0.72
    VehicleHudOccupantsX(2)=0.55 // front passenger
    VehicleHudOccupantsY(2)=0.45
    VehicleHudOccupantsX(3)=0.45 // rear left passenger
    VehicleHudOccupantsY(3)=0.55
    VehicleHudOccupantsX(4)=0.45
    VehicleHudOccupantsY(4)=0.6125
    VehicleHudOccupantsX(5)=0.55 // rear right passenger
    VehicleHudOccupantsY(5)=0.55
    VehicleHudOccupantsX(6)=0.55
    VehicleHudOccupantsY(6)=0.6125
    SpawnOverlay(0)=Material'DH_M3Halftrack_tex.m16_menu'
}
