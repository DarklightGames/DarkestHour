//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_DUKWTransport extends DH_DUKW;

defaultproperties
{
    ExitPositions(4)=(X=-58.00,Y=135.00,Z=60.00)    // Right Passenger 02
    ExitPositions(5)=(X=-58.00,Y=-135.00,Z=60.00)   // Left Passenger 02
    ExitPositions(6)=(X=-108.00,Y=135.00,Z=60.00)   // Right Passenger 03
    ExitPositions(7)=(X=-108.00,Y=-135.00,Z=60.00)  // Left Passenger 03
    ExitPositions(8)=(X=-158.00,Y=135.00,Z=60.00)   // Right Passenger 04
    ExitPositions(9)=(X=-158.00,Y=-135.00,Z=60.00)  // Left Passenger 04
    ExitPositions(10)=(X=-337.00,Y=-40.00,Z=60.00)  // Fallback Exit (rear)
    ExitPositions(11)=(X=-337.00,Y=-40.00,Z=60.00)  // Fallback Exit (rear)

    // Passengers
    PassengerPawns(0)=(AttachBone="passenger_01",DriveAnim="dukw_passenger_01",DrivePos=(Z=58))
    PassengerPawns(1)=(AttachBone="passenger_02",DriveAnim="dukw_passenger_02",DrivePos=(Z=58))
    PassengerPawns(2)=(AttachBone="passenger_03",DriveAnim="dukw_passenger_03",DrivePos=(Z=58))
    PassengerPawns(3)=(AttachBone="passenger_04",DriveAnim="dukw_passenger_04",DrivePos=(Z=58))
    PassengerPawns(4)=(AttachBone="passenger_05",DriveAnim="dukw_passenger_05",DrivePos=(Z=58))
    PassengerPawns(5)=(AttachBone="passenger_06",DriveAnim="dukw_passenger_06",DrivePos=(Z=58))
    PassengerPawns(6)=(AttachBone="passenger_07",DriveAnim="dukw_passenger_07",DrivePos=(Z=58))
    PassengerPawns(7)=(AttachBone="passenger_08",DriveAnim="dukw_passenger_08",DrivePos=(Z=58))
    PassengerPawns(8)=(AttachBone="passenger_09",DriveAnim="dukw_passenger_09",DrivePos=(Z=58))
}
