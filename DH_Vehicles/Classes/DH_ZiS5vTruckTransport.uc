//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ZiS5vTruckTransport extends DH_ZiS5vTruck;

defaultproperties
{
    VehicleNameString="ZiS-5V (Transport)"
    PassengerPawns(1)=(AttachBone="Passenger_L1",DriveAnim="VHalftrack_Rider3_idle")
    PassengerPawns(2)=(AttachBone="Passenger_L2",DriveAnim="VHalftrack_Rider2_idle")
    PassengerPawns(3)=(AttachBone="Passenger_L3",DriveAnim="VHalftrack_Rider1_idle")
    PassengerPawns(4)=(AttachBone="Passenger_R1",DriveAnim="VHalftrack_Rider4_idle")
    PassengerPawns(5)=(AttachBone="Passenger_R2",DriveAnim="VHalftrack_Rider5_idle")
    PassengerPawns(6)=(AttachBone="Passenger_R3",DriveAnim="VHalftrack_Rider6_idle")
    ExitPositions(2)=(X=-210.0,Y=-40.0,Z=70.0) // left side rear passengers
    ExitPositions(3)=(X=-210.0,Y=-40.0,Z=70.0)
    ExitPositions(4)=(X=-210.0,Y=-40.0,Z=70.0)
    ExitPositions(5)=(X=-210.0,Y=40.0,Z=70.0)
    ExitPositions(6)=(X=-210.0,Y=40.0,Z=70.0)
    ExitPositions(7)=(X=-210.0,Y=40.0,Z=70.0)
    VehicleHudOccupantsX(2)=0.38
    VehicleHudOccupantsY(2)=0.52
    VehicleHudOccupantsX(3)=0.38
    VehicleHudOccupantsY(3)=0.655
    VehicleHudOccupantsX(4)=0.38
    VehicleHudOccupantsY(4)=0.79
    VehicleHudOccupantsX(5)=0.62
    VehicleHudOccupantsY(5)=0.52
    VehicleHudOccupantsX(6)=0.62
    VehicleHudOccupantsY(6)=0.655
    VehicleHudOccupantsX(7)=0.62
    VehicleHudOccupantsY(7)=0.79
}
