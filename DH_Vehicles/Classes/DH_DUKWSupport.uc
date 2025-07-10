//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_DUKWSupport extends DH_DUKW;

defaultproperties
{
    VehicleNameString="DUKW (Logistics)"
    MapIconMaterial=Texture'DH_InterfaceArt2_tex.craft_supply_topdown'

    SupplyAttachmentClass=Class'DHConstructionSupplyAttachment_Vehicle'
    SupplyAttachmentStaticMesh=StaticMesh'DH_Construction_stc.USA_Supply_cache_full'
    SupplyAttachmentBone="SUPPLY_ATTACHMENT"

    PassengerPawns(0)=(AttachBone="passenger_01",DriveAnim="dukw_passenger_01",DrivePos=(Z=58))
    PassengerPawns(1)=(AttachBone="passenger_02",DriveAnim="dukw_passenger_02",DrivePos=(Z=58))
    PassengerPawns(2)=(AttachBone="passenger_03",DriveAnim="dukw_passenger_03",DrivePos=(Z=58))

    bRequiresDriverLicense=true
    FriendlyResetDistance=15000.0  // 250 meters

    ExitPositions(4)=(X=-337.00,Y=-40.00,Z=60.00)  // Fallback Exit (rear)
    ExitPositions(5)=(X=-337.00,Y=-40.00,Z=60.00)  // Fallback Exit (rear)
}
