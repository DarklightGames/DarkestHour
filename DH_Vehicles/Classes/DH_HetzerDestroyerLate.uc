//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// The late version of the Hetzer that began manufacturing in December 1944.
// Should only be used on 1945 maps.
//==============================================================================

class DH_HetzerDestroyerLate extends DH_HetzerDestroyer
    abstract;

defaultproperties
{
    Mesh=SkeletalMesh'DH_Hetzer_anm.HETZER_BODY_LATE_EXT'
    ExhaustPipes(0)=(ExhaustPosition=(X=-123,Y=25,Z=86),ExhaustRotation=(Yaw=16384))
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_HetzerCannonPawnLate')
    // This version has hand-written messages on the attachments that are specific to Berlin, so make sure these are always on.
    RandomAttachmentGroups(2)=(Options=((Probability=1.0,Attachment=(StaticMesh=StaticMesh'DH_Hetzer_stc.HETZER_ATTACHMENT_SIDE_SKIRT_3',AttachBone="body"))))
    RandomAttachmentGroups(4)=(Options=((Probability=1.0,Attachment=(StaticMesh=StaticMesh'DH_Hetzer_stc.HETZER_ATTACHMENT_SIDE_SKIRT_5',AttachBone="body"))))
    RandomAttachmentGroups(5)=(Options=((Probability=1.0,Attachment=(StaticMesh=StaticMesh'DH_Hetzer_stc.HETZER_ATTACHMENT_SIDE_SKIRT_6',AttachBone="body"))))

}
