//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_GMCTruckTransport extends DH_GMCTruck;

defaultproperties
{
    PassengerPawns(1)=(AttachBone="passenger_l_1",DrivePos=(X=8.0,Y=0.0,Z=5.0),DriveAnim="VHalftrack_Rider2_idle")
    PassengerPawns(2)=(AttachBone="passenger_l_3",DrivePos=(X=8.0,Y=0.0,Z=5.0),DriveAnim="VHalftrack_Rider3_idle")
    PassengerPawns(3)=(AttachBone="passenger_l_5",DrivePos=(X=8.0,Y=0.0,Z=5.0),DriveAnim="VHalftrack_Rider4_idle")
    PassengerPawns(4)=(AttachBone="passenger_r_1",DrivePos=(X=8.0,Y=0.0,Z=5.0),DriveAnim="VHalftrack_Rider5_idle")
    PassengerPawns(5)=(AttachBone="passenger_r_3",DrivePos=(X=8.0,Y=0.0,Z=5.0),DriveAnim="VHalftrack_Rider6_idle")
    PassengerPawns(6)=(AttachBone="passenger_r_5",DrivePos=(X=8.0,Y=0.0,Z=5.0),DriveAnim="VHalftrack_Rider1_idle")
    VehicleHudOccupantsX(2)=0.45
    VehicleHudOccupantsY(2)=0.55
    VehicleHudOccupantsX(3)=0.45
    VehicleHudOccupantsY(3)=0.65
    VehicleHudOccupantsX(4)=0.45
    VehicleHudOccupantsY(4)=0.75
    VehicleHudOccupantsX(5)=0.55
    VehicleHudOccupantsY(5)=0.55
    VehicleHudOccupantsX(6)=0.55
    VehicleHudOccupantsY(6)=0.65
    VehicleHudOccupantsX(7)=0.55
    VehicleHudOccupantsY(7)=0.75
    ExitPositions(2)=(X=-273.0,Y=-34.0,Z=25.0) // back left rider
    ExitPositions(3)=(X=-273.0,Y=-34.0,Z=25.0) // back left rider
    ExitPositions(4)=(X=-273.0,Y=-34.0,Z=25.0) // back left rider
    ExitPositions(5)=(X=-271.0,Y=23.0,Z=25.0)  // back right rider
    ExitPositions(6)=(X=-271.0,Y=23.0,Z=25.0)  // back right rider
    ExitPositions(7)=(X=-271.0,Y=23.0,Z=25.0)  // back right rider
}
