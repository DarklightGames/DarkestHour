//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Fiat508CMTransport_Green extends DH_Fiat508CMTransport;

defaultproperties
{
    Skins(0)=Texture'DH_Fiat508CM_tex.fiat508.fiat508cm_green'
    Skins(1)=Texture'DH_Fiat508CM_tex.fiat508.fiat508cm_gear_green'
    DestroyedMeshSkins(0)=Combiner'DH_Fiat508CM_tex.fiat508cm_gear_green_dest'
    DestroyedMeshSkins(1)=Combiner'DH_Fiat508CM_tex.fiat508cm_green_dest'
    VehicleAttachments(0)=(StaticMesh=StaticMesh'DH_Fiat508cm_stc.attachments.fiat508cm_radio',AttachBone="BODY",Skins=(Texture'DH_Fiat508CM_tex.fiat508.fiat508cm_gear_green'))
    RandomAttachmentGroups(0)=(Options=((Probability=0.5,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_Fiat508CM_stc.attachments.fiat508cm_searchlight',Skins=(Texture'DH_Fiat508CM_tex.fiat508.fiat508cm_green')))))
    RandomAttachmentGroups(1)=(Options=((Probability=0.5,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_Fiat508CM_stc.attachments.fiat508cm_tools',Skins=(Texture'DH_Fiat508CM_tex.fiat508.fiat508cm_gear_green')))))
    RandomAttachmentGroups(2)=(Options=((Probability=0.5,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_Fiat508CM_stc.attachments.fiat508cm_jerry_can',Skins=(Texture'DH_Fiat508CM_tex.fiat508.fiat508cm_gear_green')))))
    RandomAttachmentGroups(3)=(Options=((Probability=0.5,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_Fiat508CM_stc.attachments.fiat508cm_roof',Skins=(Texture'DH_Fiat508CM_tex.fiat508.fiat508cm_roof_green')))))
    RandomAttachmentGroups(4)=(Options=((Probability=0.5,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_Fiat508CM_stc.attachments.fiat508cm_windows',Skins=(Texture'DH_Fiat508CM_tex.fiat508.fiat508cm_roof_green')))))
    RandomAttachmentGroups(5)=(Options=((Probability=0.5,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_Fiat508CM_stc.attachments.fiat508cm_headlights',Skins=(Texture'DH_Fiat508CM_tex.fiat508.fiat508cm_green'))),(Probability=0.5,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_Fiat508CM_stc.attachments.fiat508cm_headlights_protected',Skins=(Texture'DH_Fiat508CM_tex.fiat508.fiat508cm_green')))))
}
