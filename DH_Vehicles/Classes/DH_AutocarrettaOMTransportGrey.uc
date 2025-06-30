//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_AutoCarrettaOMTransportGrey extends DH_AutoCarrettaOMTransport;

defaultproperties
{
    DestroyedMeshSkins(0)=Combiner'DH_AutocarrettaOM_tex.OM_Passenger_Grey_D'
    DestroyedMeshSkins(1)=Combiner'DH_AutocarrettaOM_tex.OM_Wheels_Grey_D'
    DestroyedMeshSkins(2)=Combiner'DH_AutocarrettaOM_tex.OM_BaseVehicle_Grey_D'

    RandomAttachmentGroups(0)=(Options=((Probability=0.9,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_AutocarrettaOM_stc.OM33_WINDSHIELD',Skins=(Texture'DH_AutocarrettaOM_tex.OM_BaseVehicle_Grey')))))
    RandomAttachmentGroups(3)=(Dependencies=((GroupIndex=0,OptionIndex=0)),Options=((Probability=0.75,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_AutocarrettaOM_stc.OM33_SEARCHLIGHT',Skins=(Texture'DH_AutocarrettaOM_tex.OM_BaseVehicle_Grey')))))

    Skins(0)=Texture'DH_AutocarrettaOM_tex.OM_BaseVehicle_Grey'
    Skins(1)=Texture'DH_AutocarrettaOM_tex.OM_Grill_Grey'
    Skins(2)=Texture'DH_AutocarrettaOM_tex.OM_Wheels_Grey'
    Skins(3)=Texture'DH_AutocarrettaOM_tex.OM_Passenger_Grey'
}
