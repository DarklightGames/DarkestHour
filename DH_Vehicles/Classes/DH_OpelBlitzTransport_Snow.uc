//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_OpelBlitzTransport_Snow extends DH_OpelBlitzTransport;

defaultproperties
{
    Skins(0)=Texture'DH_OpelBlitz_tex.Opel_Blitz_Exterior_Winter'
    Skins(1)=Texture'DH_OpelBlitz_tex.Opel_Blitz_Interior_Grey'
    Skins(2)=Texture'DH_OpelBlitz_tex.Opel_Blitz_Canvas_Winter'
    Skins(4)=Texture'DH_OpelBlitz_tex.Opel_Blitz_Attachments_Winter'
    DestroyedMeshSkins(0)=Combiner'DH_OpelBlitz_tex.Opel_Blitz_Exterior_Winter_Destroyed'
    DestroyedMeshSkins(1)=Combiner'DH_OpelBlitz_tex.Opel_Blitz_Interior_Grey_Destroyed'
    DestroyedMeshSkins(2)=Combiner'DH_OpelBlitz_tex.Opel_Blitz_Canvas_Winter_Destroyed'
    RandomAttachmentGroups(4)=(Options=((Probability=0.8,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_OpelBlitz_stc.OPELBLITZ_ATTACHMENT_ENGINE_COVER',SkinIndexMap=((VehicleSkinIndex=4,AttachmentSkinIndex=0))))))
}
