//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Fiat626TruckSupport extends DH_Fiat626Truck;

defaultproperties
{
    VehicleNameString="Fiat 626 (Logistics)"

    // TODO: logi related stuff

    // Passengers
    PassengerPawns(1)=(AttachBone="passenger_06",DriveAnim="fiat626_passenger_bl",DrivePos=(Z=58),DriveRot=(Yaw=-16384))
    PassengerPawns(2)=(AttachBone="passenger_11",DriveAnim="fiat626_passenger_br",DrivePos=(Z=58),DriveRot=(Yaw=-16384))

    VehicleHudOccupantsX(2)=0.425
    VehicleHudOccupantsY(2)=0.825
    VehicleHudOccupantsX(3)=0.575
    VehicleHudOccupantsY(3)=0.825
}
