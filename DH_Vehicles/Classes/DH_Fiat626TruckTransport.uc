//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Fiat626TruckTransport extends DH_Fiat626Truck;

defaultproperties
{
    VehicleNameString="Fiat 626 (Transport)"

    // Passengers

    // Left Side
    PassengerPawns( 1)=(AttachBone="passenger_02",DriveAnim="fiat626_passenger_fl",DrivePos=(Z=58),DriveRot=(Yaw=-16384))
    PassengerPawns( 2)=(AttachBone="passenger_03",DriveAnim="fiat626_passenger_02",DrivePos=(Z=58),DriveRot=(Yaw=-16384))
    PassengerPawns( 3)=(AttachBone="passenger_04",DriveAnim="fiat626_passenger_03",DrivePos=(Z=58),DriveRot=(Yaw=-16384))
    PassengerPawns( 4)=(AttachBone="passenger_05",DriveAnim="fiat626_passenger_04",DrivePos=(Z=58),DriveRot=(Yaw=-16384))
    PassengerPawns( 5)=(AttachBone="passenger_06",DriveAnim="fiat626_passenger_bl",DrivePos=(Z=58),DriveRot=(Yaw=-16384))
    // Right Side
    PassengerPawns( 6)=(AttachBone="passenger_07",DriveAnim="fiat626_passenger_fr",DrivePos=(Z=58),DriveRot=(Yaw=-16384))
    PassengerPawns( 7)=(AttachBone="passenger_08",DriveAnim="fiat626_passenger_03",DrivePos=(Z=58),DriveRot=(Yaw=-16384))
    PassengerPawns( 8)=(AttachBone="passenger_09",DriveAnim="fiat626_passenger_04",DrivePos=(Z=58),DriveRot=(Yaw=-16384))
    PassengerPawns( 9)=(AttachBone="passenger_10",DriveAnim="fiat626_passenger_02",DrivePos=(Z=58),DriveRot=(Yaw=-16384))
    PassengerPawns(10)=(AttachBone="passenger_11",DriveAnim="fiat626_passenger_br",DrivePos=(Z=58),DriveRot=(Yaw=-16384))

    // Left side cabin
    VehicleHudOccupantsX(2)=0.425
    VehicleHudOccupantsY(2)=0.425
    VehicleHudOccupantsX(3)=0.425
    VehicleHudOccupantsY(3)=0.525
    VehicleHudOccupantsX(4)=0.425
    VehicleHudOccupantsY(4)=0.625
    VehicleHudOccupantsX(5)=0.425
    VehicleHudOccupantsY(5)=0.725
    VehicleHudOccupantsX(6)=0.425
    VehicleHudOccupantsY(6)=0.825

    // Right side cabin
    VehicleHudOccupantsX(7)=0.575
    VehicleHudOccupantsY(7)=0.425
    VehicleHudOccupantsX(8)=0.575
    VehicleHudOccupantsY(8)=0.525
    VehicleHudOccupantsX(9)=0.575
    VehicleHudOccupantsY(9)=0.625
    VehicleHudOccupantsX(10)=0.575
    VehicleHudOccupantsY(10)=0.725
    VehicleHudOccupantsX(11)=0.575
    VehicleHudOccupantsY(11)=0.825
}
