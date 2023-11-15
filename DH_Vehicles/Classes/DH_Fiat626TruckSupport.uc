//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Fiat626TruckSupport extends DH_Fiat626Truck;

defaultproperties
{
    VehicleNameString="Fiat 626 Truck (Logistics)"

    // TODO: logi related stuff

    // Passengers
    PassengerPawns(1)=(AttachBone="passenger_06",DriveAnim="fiat626_passenger_bl",DrivePos=(Z=58),DriveRot=(Yaw=-16384))
    PassengerPawns(2)=(AttachBone="passenger_11",DriveAnim="fiat626_passenger_br",DrivePos=(Z=58),DriveRot=(Yaw=-16384))
}
