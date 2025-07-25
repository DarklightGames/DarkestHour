//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// This is the OM 32 variant, with the hard wheels and flatbed.
//==============================================================================

class DH_AutoCarrettaOMSupport extends DH_AutocarrettaOM;

defaultproperties
{
    VehicleNameString="Autocarretta OM 36Mt (Logistics)"
    MapIconMaterial=Texture'DH_GUI_tex.supply_point'

    Mesh=SkeletalMesh'DH_AutocarrettaOM_anm.OM33_BODY_SUPPORT_EXT'
    
    RandomAttachmentGroups(0)=(Options=((Probability=0.9,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_AutocarrettaOM_stc.OM33_WINDSHIELD'))))
    RandomAttachmentGroups(1)=(Options=((Probability=0.75,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_AutocarrettaOM_stc.OM33_ROOF_CABIN'))))
    RandomAttachmentGroups(2)=(Dependencies=((GroupIndex=0,OptionIndex=0)),Options=((Probability=0.75,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_AutocarrettaOM_stc.OM33_SEARCHLIGHT'))))
    RandomAttachmentGroups(3)=(Options=((Probability=0.75,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_AutocarrettaOM_stc.OM33_SPARE_WHEEL_1920S'))))
    RandomAttachmentGroups(4)=(Dependencies=((GroupIndex=0,OptionIndex=-1),(GroupIndex=1,OptionIndex=0)),Options=((Probability=1.0,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_AutocarrettaOM_stc.OM33_TENT_STRAPS'))))
    RandomAttachmentGroups(5)=(Options=((Probability=1.0,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_AutocarrettaOM_stc.OM33_LOGI',CullDistance=3000))))

    PassengerPawns(1)=(AttachBone="BODY",DriveAnim="OM33_PASSENGER_SUPPORT_01",DrivePos=(X=-17.8056,Y=-22.1263,Z=107.282),DriveRot=(Yaw=32768))
    PassengerPawns(2)=(AttachBone="BODY",DriveAnim="OM33_PASSENGER_SUPPORT_02",DrivePos=(X=-17.8056,Y=22.1263,Z=107.282),DriveRot=(Yaw=32768))

    ExitPositions(1)=(X=60.0,Y=-90.0,Z=58.0)    // Front Passenger
    ExitPositions(2)=(X=-20,Y=-90.0,Z=58.0)     // Rear Passenger Left
    ExitPositions(3)=(X=-20,Y=90.0,Z=58.0)      // Rear Passenger Right

    VehicleHudImage=Texture'DH_AutocarrettaOM_tex.om_support_clock'
    SpawnOverlay(0)=Texture'DH_AutocarrettaOM_tex.om_support_profile'

    // Driver
    VehicleHudOccupantsX(0)=0.575
    VehicleHudOccupantsY(0)=0.37
    // Front Passenger
    VehicleHudOccupantsX(1)=0.425
    VehicleHudOccupantsY(1)=0.37
    // Flatbed Passengers
    VehicleHudOccupantsX(2)=0.435
    VehicleHudOccupantsY(2)=0.5
    VehicleHudOccupantsX(3)=0.565
    VehicleHudOccupantsY(3)=0.5

    DestroyedVehicleMesh=StaticMesh'DH_AutocarrettaOM_stc.OM33_DESTROYED_SUPPORT'
    DestroyedMeshSkins(0)=Combiner'DH_AutocarrettaOM_tex.OM_Flatbed_Green_D'
    DestroyedMeshSkins(1)=Combiner'DH_AutocarrettaOM_tex.OM_Wheels_Green_D'
    DestroyedMeshSkins(2)=Combiner'DH_AutocarrettaOM_tex.OM_BaseVehicle_Green_D'
    
    // Logistics
    SupplyAttachmentClass=Class'DHConstructionSupplyAttachment_Vehicle'
    SupplyAttachmentBone="BODY"
    SupplyAttachmentOffset=(X=-91.7437,Y=0.0,Z=61.4152)
    SupplyAttachmentStaticMesh=None
    SupplyAttachmentSupplyCountMax=1000 // Reduced capacity due to small size.

    ResupplyAttachmentBone="BODY"
    bRequiresDriverLicense=true
    FriendlyResetDistance=15000.0  // 250 meters
}
