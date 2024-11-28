//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_AutocarrettaOM33Support extends DH_AutocarrettaOM33;

defaultproperties
{
    Mesh=SkeletalMesh'DH_AutocarrettaOM_anm.OM33_BODY_SUPPORT_EXT'
    RandomAttachmentGroups(0)=(Options=((Probability=0.9,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_AutocarrettaOM_stc.ATTACHMENTS.OM33_WINDSHIELD'))))
    RandomAttachmentGroups(1)=(Options=((Probability=0.5,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_AutocarrettaOM_stc.ATTACHMENTS.OM33_ROOF_CABIN'))))
    RandomAttachmentGroups(3)=(Dependencies=((GroupIndex=0,OptionIndex=-1)),Options=((Probability=0.75,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_AutocarrettaOM_stc.ATTACHMENTS.OM33_SEARCHLIGHT'))))
    RandomAttachmentGroups(4)=(Options=((Probability=0.75,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_AutocarrettaOM_stc.ATTACHMENTS.OM33_SPARE_WHEEL_1920S'))))
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_AutocarrettaOMMGPawn',WeaponBone="TURRET_ATTACHMENT")
}
