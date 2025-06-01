//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_AutoCarrettaOMSupportCamo extends DH_AutoCarrettaOMSupport;

defaultproperties
{
    DestroyedMeshSkins(0)=Combiner'DH_AutocarrettaOM_tex.Destroyed.OM_Flatbed_Camo01_D'
    DestroyedMeshSkins(2)=Combiner'DH_AutocarrettaOM_tex.Destroyed.OM_BaseVehicle_Camo01_D'
    RandomAttachmentGroups(0)=(Options=((Probability=0.9,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_AutocarrettaOM_stc.ATTACHMENTS.OM33_WINDSHIELD',Skins=(Texture'DH_AutocarrettaOM_tex.OM.OM_BaseVehicle_Camo01')))))
    RandomAttachmentGroups(2)=(Dependencies=((GroupIndex=0,OptionIndex=0)),Options=((Probability=0.75,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_AutocarrettaOM_stc.ATTACHMENTS.OM33_SEARCHLIGHT',Skins=(Texture'DH_AutocarrettaOM_tex.OM.OM_BaseVehicle_Camo01')))))
    Skins(0)=Texture'DH_AutocarrettaOM_tex.OM.OM_BaseVehicle_Camo01'
    Skins(3)=Texture'DH_AutocarrettaOM_tex.OM.OM_Flatbed_Camo01'
}
