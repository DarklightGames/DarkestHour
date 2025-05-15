//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_OpelBlitzSupport_Snow extends DH_OpelBlitzSupport;

defaultproperties
{
    RandomAttachmentGroups(4)=(Options=((Probability=1.0,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_OpelBlitz_stc.OPELBLITZ_ATTACHMENT_TRAILER'))))
    RandomAttachmentGroups(5)=(Options=((Probability=0.8,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_OpelBlitz_stc.OPELBLITZ_ATTACHMENT_ENGINE_COVER'))))
}
