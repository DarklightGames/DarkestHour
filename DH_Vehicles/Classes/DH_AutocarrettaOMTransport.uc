//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_AutoCarrettaOMTransport extends DH_AutocarrettaOM;

defaultproperties
{
    // Front Row
    PassengerPawns(1)=(AttachBone="BODY",DriveAnim="OM33_PASSENGER_TRANSPORT_01",DrivePos=(X=8.80619,Y=0,Z=108.489))
    PassengerPawns(2)=(AttachBone="BODY",DriveAnim="OM33_PASSENGER_TRANSPORT_02",DrivePos=(X=8.80619,Y=-24.6791,Z=108.489))
    PassengerPawns(3)=(AttachBone="BODY",DriveAnim="OM33_PASSENGER_TRANSPORT_03",DrivePos=(X=8.80619,Y=24.6791,Z=108.489))

    // Middle Row (Rear Facing)
    PassengerPawns(4)=(AttachBone="BODY",DriveAnim="OM33_PASSENGER_TRANSPORT_04",DrivePos=(X=-62.8844,Y=0,Z=108.489),DriveRot=(Yaw=32768))
    PassengerPawns(5)=(AttachBone="BODY",DriveAnim="OM33_PASSENGER_TRANSPORT_03",DrivePos=(X=-62.8844,Y=-24.6791,Z=108.489),DriveRot=(Yaw=32768))
    PassengerPawns(6)=(AttachBone="BODY",DriveAnim="OM33_PASSENGER_TRANSPORT_02",DrivePos=(X=-62.8844,Y=24.6791,Z=108.489),DriveRot=(Yaw=32768))

    // Back Row
    PassengerPawns(7)=(AttachBone="BODY",DriveAnim="OM33_PASSENGER_TRANSPORT_06",DrivePos=(X=-76.0907,Y=14.2551,Z=108.489))
    PassengerPawns(8)=(AttachBone="BODY",DriveAnim="OM33_PASSENGER_TRANSPORT_05",DrivePos=(X=-76.0907,Y=-14.2551,Z=108.489))

    RandomAttachmentGroups(0)=(Options=((Probability=0.9,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_AutocarrettaOM_stc.ATTACHMENTS.OM33_WINDSHIELD'))))
    RandomAttachmentGroups(1)=(Options=((Probability=0.75,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_AutocarrettaOM_stc.ATTACHMENTS.OM33_ROOF_PASSENGER')),(Probability=0.25,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_AutocarrettaOM_stc.ATTACHMENTS.OM33_ROOF_CABIN'))))
    RandomAttachmentGroups(2)=(Dependencies=((GroupIndex=0,OptionIndex=0)),Options=((Probability=0.75,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_AutocarrettaOM_stc.ATTACHMENTS.OM33_SEARCHLIGHT'))))
    RandomAttachmentGroups(3)=(Options=((Probability=0.75,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_AutocarrettaOM_stc.ATTACHMENTS.OM33_SPARE_WHEEL_1930S'))))
    RandomAttachmentGroups(4)=(Dependencies=((GroupIndex=0,OptionIndex=-1),(GroupIndex=1,OptionIndex=1)),Options=((Probability=1.0,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_AutocarrettaOM_stc.ATTACHMENTS.OM33_TENT_STRAPS'))))

    VehicleHudImage=Texture'DH_AutocarrettaOM_tex.Interface.om_transport_clock'
    SpawnOverlay(0)=Texture'DH_AutocarrettaOM_tex.Interface.om_transport_profile'

    // Driver
    VehicleHudOccupantsX(0)=0.575
    VehicleHudOccupantsY(0)=0.34

    // Front Passenger
    VehicleHudOccupantsX(1)=0.425
    VehicleHudOccupantsY(1)=0.34

    // Front Row
    VehicleHudOccupantsX(2)=0.5
    VehicleHudOccupantsY(2)=0.5
    VehicleHudOccupantsX(3)=0.415
    VehicleHudOccupantsY(3)=0.5
    VehicleHudOccupantsX(4)=0.585
    VehicleHudOccupantsY(4)=0.5

    // Middle Row (Rear Facing)
    VehicleHudOccupantsX(5)=0.5
    VehicleHudOccupantsY(5)=0.605
    VehicleHudOccupantsX(6)=0.415
    VehicleHudOccupantsY(6)=0.605
    VehicleHudOccupantsX(7)=0.585
    VehicleHudOccupantsY(7)=0.605

    // Back Row
    VehicleHudOccupantsX(8)=0.55
    VehicleHudOccupantsY(8)=0.775
    VehicleHudOccupantsX(9)=0.45
    VehicleHudOccupantsY(9)=0.775
}
