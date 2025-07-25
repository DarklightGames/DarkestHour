//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_JagdpantherTank_SnowTwo extends DH_JagdpantherTank;

defaultproperties
{
    Skins(0)=Texture'DH_VehiclesGE_tex3.jagdpanther_body_snow2'
    Skins(1)=Texture'DH_VehiclesGE_tex3.Jagdpanther_treads_snow'
    Skins(2)=Texture'DH_VehiclesGE_tex3.Jagdpanther_treads_snow'
    CannonSkins(0)=Texture'DH_VehiclesGE_tex3.jagdpanther_body_snow2'
    RandomAttachmentGroups(0)=(Options=((Attachment=(AttachBone="body",Offset=(X=-18.0,Y=-1.65,Z=-14.0),StaticMesh=StaticMesh'DH_German_vehicles_stc.PantherSchurzen1',Skins=(Texture'DH_VehiclesGE_tex3.Jagdpanther_armor_snow')),Probability=0.3),(Attachment=(AttachBone="body",Offset=(X=-18.0,Y=-1.65,Z=-14.0),StaticMesh=StaticMesh'DH_German_vehicles_stc.PantherSchurzen2',Skins=(Texture'DH_VehiclesGE_tex3.Jagdpanther_armor_snow')),Probability=0.15),(Attachment=(AttachBone="body",Offset=(X=-18.0,Y=-1.65,Z=-14.0),StaticMesh=StaticMesh'DH_German_vehicles_stc.PantherSchurzen3',Skins=(Texture'DH_VehiclesGE_tex3.Jagdpanther_armor_snow')),Probability=0.10),(Attachment=(AttachBone="body",Offset=(X=-18.0,Y=-1.65,Z=-14.0),StaticMesh=StaticMesh'DH_German_vehicles_stc.PantherSchurzen4',Skins=(Texture'DH_VehiclesGE_tex3.Jagdpanther_armor_snow')),Probability=0.15)))
    DestroyedMeshSkins(0)=Combiner'DH_VehiclesGE_tex3.Jagdpanther_snow_dest'
}
