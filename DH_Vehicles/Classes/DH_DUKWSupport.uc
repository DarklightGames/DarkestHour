//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// TODO: make this make sense!
//==============================================================================

class DH_DUKWSupport extends DH_DUKW;

defaultproperties
{
    VehicleNameString="DUKW (Support)"

    SupplyAttachmentClass=class'DHConstructionSupplyAttachment_Vehicle'
    SupplyAttachmentBone="SUPPLY_ATTACHMENT"

    PassengerPawns(0)=(AttachBone="passenger_01",DriveAnim="dukw_passenger_01",DrivePos=(Z=58))
    PassengerPawns(1)=(AttachBone="passenger_02",DriveAnim="dukw_passenger_02",DrivePos=(Z=58))
    PassengerPawns(2)=(AttachBone="passenger_03",DriveAnim="dukw_passenger_03",DrivePos=(Z=58))
}
