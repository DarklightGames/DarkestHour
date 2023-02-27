//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_GMCTruckTransport extends DH_GMCTruck;

defaultproperties
{
    VehicleNameString="GMC CCKW (Transport)"
    VehicleAttachments(0)=(StaticMesh=StaticMesh'DH_allies_vehicles_stc.Trucks.gmc_deco_bench')
    PassengerPawns(1)=(AttachBone="body",DriveRot=(Yaw=16384),DrivePos=(X=-20.0,Y=-45.0,Z=97.0),DriveAnim="VHalftrack_Rider2_idle")
    PassengerPawns(2)=(AttachBone="body",DriveRot=(Yaw=16384),DrivePos=(X=-60.0,Y=-45.0,Z=97.0),DriveAnim="VHalftrack_Rider3_idle")
    PassengerPawns(3)=(AttachBone="body",DriveRot=(Yaw=16384),DrivePos=(X=-100.0,Y=-45.0,Z=97.0),DriveAnim="VHalftrack_Rider4_idle")
    PassengerPawns(4)=(AttachBone="body",DriveRot=(Yaw=16384),DrivePos=(X=-140.0,Y=-45.0,Z=97.0),DriveAnim="VHalftrack_Rider5_idle")
    PassengerPawns(5)=(AttachBone="body",DriveRot=(Yaw=16384),DrivePos=(X=-180.0,Y=-45.0,Z=97.0),DriveAnim="VHalftrack_Rider6_idle")
    PassengerPawns(6)=(AttachBone="body",DriveRot=(Yaw=-16384),DrivePos=(X=-20.0,Y=45.0,Z=97.0),DriveAnim="VHalftrack_Rider1_idle")
    PassengerPawns(7)=(AttachBone="body",DriveRot=(Yaw=-16384),DrivePos=(X=-60.0,Y=45.0,Z=97.0),DriveAnim="VHalftrack_Rider2_idle")
    PassengerPawns(8)=(AttachBone="body",DriveRot=(Yaw=-16384),DrivePos=(X=-100.0,Y=45.0,Z=97.0),DriveAnim="VHalftrack_Rider3_idle")
    PassengerPawns(9)=(AttachBone="body",DriveRot=(Yaw=-16384),DrivePos=(X=-140.0,Y=45.0,Z=97.0),DriveAnim="VHalftrack_Rider4_idle")
    PassengerPawns(10)=(AttachBone="body",DriveRot=(Yaw=-16384),DrivePos=(X=-180.0,Y=45.0,Z=97.0),DriveAnim="VHalftrack_Rider5_idle")
    ExitPositions(2)=(X=-273.0,Y=-34.0,Z=25.0) // back left rider
    ExitPositions(3)=(X=-273.0,Y=-34.0,Z=25.0) // back left rider
    ExitPositions(4)=(X=-273.0,Y=-34.0,Z=25.0) // back left rider
    ExitPositions(5)=(X=-273.0,Y=-34.0,Z=25.0) // back left rider
    ExitPositions(6)=(X=-273.0,Y=-34.0,Z=25.0) // back left rider
    ExitPositions(7)=(X=-271.0,Y=23.0,Z=25.0)  // back right rider
    ExitPositions(8)=(X=-271.0,Y=23.0,Z=25.0)  // back right rider
    ExitPositions(9)=(X=-271.0,Y=23.0,Z=25.0)  // back right rider
    ExitPositions(10)=(X=-271.0,Y=23.0,Z=25.0)  // back right rider
    ExitPositions(11)=(X=-271.0,Y=23.0,Z=25.0)  // back right rider
    VehicleHudOccupantsX(2)=0.45
    VehicleHudOccupantsY(2)=0.5125
    VehicleHudOccupantsX(3)=0.45
    VehicleHudOccupantsY(3)=0.584375
    VehicleHudOccupantsX(4)=0.45
    VehicleHudOccupantsY(4)=0.65625
    VehicleHudOccupantsX(5)=0.45
    VehicleHudOccupantsY(5)=0.728125
    VehicleHudOccupantsX(6)=0.45
    VehicleHudOccupantsY(6)=0.8
    VehicleHudOccupantsX(7)=0.55
    VehicleHudOccupantsY(7)=0.5125
    VehicleHudOccupantsX(8)=0.55
    VehicleHudOccupantsY(8)=0.584375
    VehicleHudOccupantsX(9)=0.55
    VehicleHudOccupantsY(9)=0.65625
    VehicleHudOccupantsX(10)=0.55
    VehicleHudOccupantsY(10)=0.728125
    VehicleHudOccupantsX(11)=0.55
    VehicleHudOccupantsY(11)=0.8
}
