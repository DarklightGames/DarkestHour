//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_AutoCarrettaOMTransportSnow extends DH_AutoCarrettaOMTransport;

defaultproperties
{
    RandomAttachmentGroups(0)=(Options=((Probability=0.9,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_AutocarrettaOM_stc.ATTACHMENTS.OM33_WINDSHIELD',Skins=(Texture'DH_AutocarrettaOM_tex.OM.OM_BaseVehicle_Snow',FinalBlend'DH_AutocarrettaOM_tex.OM.OM_Windows_Snow_FB')))))
    RandomAttachmentGroups(1)=(Options=((Probability=0.75,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_AutocarrettaOM_stc.ATTACHMENTS.OM33_ROOF_PASSENGER',Skins=(Texture'DH_AutocarrettaOM_tex.OM.OM_Passenger_Snow'))),(Probability=0.25,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_AutocarrettaOM_stc.ATTACHMENTS.OM33_ROOF_CABIN',Skins=(Texture'DH_AutocarrettaOM_tex.OM.OM_Flatbed_Snow')))))
    RandomAttachmentGroups(3)=(Dependencies=((GroupIndex=0,OptionIndex=0)),Options=((Probability=0.75,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_AutocarrettaOM_stc.ATTACHMENTS.OM33_SEARCHLIGHT',Skins=(Texture'DH_AutocarrettaOM_tex.OM.OM_BaseVehicle_Snow')))))

    Skins(0)=Texture'DH_AutocarrettaOM_tex.OM.OM_BaseVehicle_Snow'
    Skins(1)=Texture'DH_AutocarrettaOM_tex.OM.OM_Grill_Grey'
    Skins(2)=Texture'DH_AutocarrettaOM_tex.OM.OM_Wheels_Snow'
    Skins(3)=Texture'DH_AutocarrettaOM_tex.OM.OM_Passenger_Snow'
}
