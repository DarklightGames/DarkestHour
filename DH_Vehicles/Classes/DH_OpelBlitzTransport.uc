//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_OpelBlitzTransport extends DH_OpelBlitz;

defaultproperties
{
    VehicleNameString="Opel Blitz (Transport)"
    
    // TODO: offset these by once once we add the front passenger
    PassengerPawns(1)=(AttachBone="BODY",DriveRot=(Yaw=-49151),DrivePos=(X=-14.67,Y=-39.00,Z=128.49),DriveAnim="fiat626_passenger_fl")
    PassengerPawns(2)=(AttachBone="BODY",DriveRot=(Yaw=-16384),DrivePos=(X=-18.49,Y=44.09,Z=128.49),DriveAnim="opeblitz_passenger_fr")
    PassengerPawns(3)=(AttachBone="BODY",DriveRot=(Yaw=-49151),DrivePos=(X=-51.49,Y=-39.00,Z=128.49),DriveAnim="fiat626_passenger_03")
    PassengerPawns(4)=(AttachBone="BODY",DriveRot=(Yaw=-16384),DrivePos=(X=-48.86,Y=37.69,Z=128.89),DriveAnim="fiat626_passenger_04")
    PassengerPawns(5)=(AttachBone="BODY",DriveRot=(Yaw=-49151),DrivePos=(X=-88.14,Y=-35.13,Z=130.29),DriveAnim="fiat626_passenger_04")
    PassengerPawns(6)=(AttachBone="BODY",DriveRot=(Yaw=-16384),DrivePos=(X=-94.73,Y=41.01,Z=130.29),DriveAnim="fiat626_passenger_02")
    PassengerPawns(7)=(AttachBone="BODY",DriveRot=(Yaw=-49151),DrivePos=(X=-128.17,Y=-39.90,Z=131.24),DriveAnim="fiat626_passenger_02")
    PassengerPawns(8)=(AttachBone="BODY",DriveRot=(Yaw=-16384),DrivePos=(X=-132.18,Y=39.90,Z=131.24),DriveAnim="fiat626_passenger_03")
    PassengerPawns(9)=(AttachBone="BODY",DriveRot=(Yaw=-49151),DrivePos=(X=-165.40,Y=-41.93,Z=131.75),DriveAnim="opelblitz_passenger_bl")
    PassengerPawns(10)=(AttachBone="BODY",DriveRot=(Yaw=-16384),DrivePos=(X=-168.31,Y=46.43,Z=132.21),DriveAnim="opelblitz_passenger_br")

    ExitPositions(2)=(X=-267,Y=-41,Z=60)
    ExitPositions(3)=(X=-267,Y=41,Z=60)
    ExitPositions(4)=(X=-267,Y=-41,Z=60)
    ExitPositions(5)=(X=-267,Y=41,Z=60)
    ExitPositions(6)=(X=-267,Y=-41,Z=60)
    ExitPositions(7)=(X=-267,Y=41,Z=60)
    ExitPositions(8)=(X=-267,Y=-41,Z=60)
    ExitPositions(9)=(X=-267,Y=41,Z=60)
    ExitPositions(10)=(X=-267,Y=-41,Z=60)
    ExitPositions(11)=(X=-267,Y=41,Z=60)

    VehicleHudOccupantsX(2)=0.43
    VehicleHudOccupantsY(2)=0.475
    VehicleHudOccupantsX(3)=0.57
    VehicleHudOccupantsY(3)=0.475
    VehicleHudOccupantsX(4)=0.43
    VehicleHudOccupantsY(4)=0.5625
    VehicleHudOccupantsX(5)=0.57
    VehicleHudOccupantsY(5)=0.5625
    VehicleHudOccupantsX(6)=0.43
    VehicleHudOccupantsY(6)=0.65
    VehicleHudOccupantsX(7)=0.57
    VehicleHudOccupantsY(7)=0.65
    VehicleHudOccupantsX(8)=0.43
    VehicleHudOccupantsY(8)=0.7375
    VehicleHudOccupantsX(9)=0.57
    VehicleHudOccupantsY(9)=0.7375
    VehicleHudOccupantsX(10)=0.43
    VehicleHudOccupantsY(10)=0.825
    VehicleHudOccupantsX(11)=0.57
    VehicleHudOccupantsY(11)=0.825
}
