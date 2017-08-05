//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_M16Halftrack extends DH_M3A1HalftrackTransport;

#exec OBJ LOAD FILE=..\Animations\DH_M3Halftrack_anm.ukx

defaultproperties
{
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_M3Halftrack_anm.m16_body')
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_M3Halftrack_anm.m16_body')
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_M3Halftrack_anm.m16_body')

    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_M45QuadmountMGPawn',WeaponBone="turret_placement")
    PassengerPawns(0)=(AttachBone="body",DrivePos=(X=-10,Y=-30,Z=85),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider1_idle")
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-45,Y=-30,Z=85),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider2_idle")
    PassengerPawns(2)=(AttachBone="body",DrivePos=(X=-10,Y=30,Z=85),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider6_idle")
    PassengerPawns(3)=(AttachBone="body",DrivePos=(X=-45,Y=30,Z=85),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider1_idle")
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.M3A1Halftrack_body'

//    VehicleHudOccupantsX(0)=0.45
//    VehicleHudOccupantsY(0)=0.45
//    VehicleHudOccupantsX(1)=0.54
//    VehicleHudOccupantsY(1)=0.45
//    VehicleHudOccupantsX(2)=0.45
//    VehicleHudOccupantsY(2)=0.55
//    VehicleHudOccupantsX(3)=0.45
//    VehicleHudOccupantsY(3)=0.6125
//    VehicleHudOccupantsX(4)=0.45
//    VehicleHudOccupantsY(4)=0.675
//    VehicleHudOccupantsX(5)=0.45
//    VehicleHudOccupantsY(5)=0.7375
//    VehicleHudOccupantsX(6)=0.45
//    VehicleHudOccupantsY(6)=0.8
//    VehicleHudOccupantsX(7)=0.55
//    VehicleHudOccupantsY(7)=0.55
//    VehicleHudOccupantsX(8)=0.55
//    VehicleHudOccupantsY(8)=0.6125
//    VehicleHudOccupantsX(9)=0.55
//    VehicleHudOccupantsY(9)=0.675
//    VehicleHudOccupantsX(10)=0.55
//    VehicleHudOccupantsY(10)=0.7375
//    VehicleHudOccupantsX(11)=0.55
//    VehicleHudOccupantsY(11)=0.8

    VehicleNameString="M16 Halftrack"
    Mesh=SkeletalMesh'DH_M3Halftrack_anm.m16_body'
    SpawnOverlay(0)=material'DH_InterfaceArt_tex.Vehicles.m3a1_halftrack'
}

