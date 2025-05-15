//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_OpelBlitzTransport_Snow extends DH_OpelBlitzTransport;

defaultproperties
{
    Skins(0)=Texture'DH_VehiclesGE_tex3.ext_vehicles.OpelBlitz_body_snow'
    Skins(1)=Texture'DH_VehiclesGE_tex3.ext_vehicles.OpelBlitz_body_snow'
    RandomAttachmentGroups(3)=(Options=((Probability=1.0,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_OpelBlitz_stc.OPELBLITZ_ATTACHMENT_CANVAS'))))
    RandomAttachmentGroups(4)=(Options=((Probability=0.8,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_OpelBlitz_stc.OPELBLITZ_ATTACHMENT_ENGINE_COVER'))))
}
