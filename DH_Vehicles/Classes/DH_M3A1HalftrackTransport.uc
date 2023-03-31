//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_M3A1HalftrackTransport extends DH_M3Halftrack;

defaultproperties
{
    VehicleNameString="M3A1 Halftrack"
    Mesh=SkeletalMesh'DH_M3Halftrack_anm.m3_body'
    DestroyedVehicleMesh=StaticMesh'DH_M3Halftrack_stc.m3.m3_destro'

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_M3HalftrackMGPawn',WeaponBone="turret_placement")
    PassengerPawns(0)=(AttachBone="body",DrivePos=(X=-10.0,Y=-30.0,Z=85.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider1_idle")
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-45.0,Y=-30.0,Z=85.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider2_idle")
    PassengerPawns(2)=(AttachBone="body",DrivePos=(X=-80.0,Y=-30.0,Z=85.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider3_idle")
    PassengerPawns(3)=(AttachBone="body",DrivePos=(X=-120.0,Y=-30.0,Z=85.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider4_idle")
    PassengerPawns(4)=(AttachBone="body",DrivePos=(X=-155.0,Y=-30.0,Z=85.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider5_idle")
    PassengerPawns(5)=(AttachBone="body",DrivePos=(X=-10.0,Y=30.0,Z=85.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider6_idle")
    PassengerPawns(6)=(AttachBone="body",DrivePos=(X=-45.0,Y=30.0,Z=85.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider1_idle")
    PassengerPawns(7)=(AttachBone="body",DrivePos=(X=-80.0,Y=30.0,Z=85.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider2_idle")
    PassengerPawns(8)=(AttachBone="body",DrivePos=(X=-120.0,Y=30.0,Z=85.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider3_idle")
    PassengerPawns(9)=(AttachBone="body",DrivePos=(X=-155.0,Y=30.0,Z=85.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider4_idle")

    // HUD
    VehicleHudImage=Texture'DH_M3Halftrack_tex.hud.m3a1_body'
    VehicleHudOccupantsX(1)=0.54 // 50 cal gunner
    VehicleHudOccupantsY(1)=0.45
    VehicleHudOccupantsX(2)=0.45 // rear left passengers
    VehicleHudOccupantsY(2)=0.55
    VehicleHudOccupantsX(3)=0.45
    VehicleHudOccupantsY(3)=0.6125
    VehicleHudOccupantsX(4)=0.45
    VehicleHudOccupantsY(4)=0.675
    VehicleHudOccupantsX(5)=0.45
    VehicleHudOccupantsY(5)=0.7375
    VehicleHudOccupantsX(6)=0.45
    VehicleHudOccupantsY(6)=0.8
    VehicleHudOccupantsX(7)=0.55 // rear right passengers
    VehicleHudOccupantsY(7)=0.55
    VehicleHudOccupantsX(8)=0.55
    VehicleHudOccupantsY(8)=0.6125
    VehicleHudOccupantsX(9)=0.55
    VehicleHudOccupantsY(9)=0.675
    VehicleHudOccupantsX(10)=0.55
    VehicleHudOccupantsY(10)=0.7375
    VehicleHudOccupantsX(11)=0.55
    VehicleHudOccupantsY(11)=0.8
    SpawnOverlay(0)=Material'DH_M3Halftrack_tex.hud.m3a1_menu'
}
