//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_JagdpantherTank_SnowTwo extends DH_JagdpantherTank;

defaultproperties
{
    Skins(0)=Texture'DH_VehiclesGE_tex3.ext_vehicles.jagdpanther_body_snow2'
    Skins(1)=Texture'DH_VehiclesGE_tex3.Treads.Jagdpanther_treads_snow'
    Skins(2)=Texture'DH_VehiclesGE_tex3.Treads.Jagdpanther_treads_snow'
    CannonSkins(0)=Texture'DH_VehiclesGE_tex3.ext_vehicles.jagdpanther_body_snow2'
    RandomAttachmentGroups(0)=(Options=((Attachment=(AttachBone="body",Offset=(X=-18.0,Y=-1.65,Z=-14.0),StaticMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherSchurzen1',Skins=(Texture'DH_VehiclesGE_tex3.ext_vehicles.Jagdpanther_armor_snow')),Probability=0.3),(Attachment=(AttachBone="body",Offset=(X=-18.0,Y=-1.65,Z=-14.0),StaticMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherSchurzen2',Skins=(Texture'DH_VehiclesGE_tex3.ext_vehicles.Jagdpanther_armor_snow')),Probability=0.15),(Attachment=(AttachBone="body",Offset=(X=-18.0,Y=-1.65,Z=-14.0),StaticMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherSchurzen3',Skins=(Texture'DH_VehiclesGE_tex3.ext_vehicles.Jagdpanther_armor_snow')),Probability=0.10),(Attachment=(AttachBone="body",Offset=(X=-18.0,Y=-1.65,Z=-14.0),StaticMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherSchurzen4',Skins=(Texture'DH_VehiclesGE_tex3.ext_vehicles.Jagdpanther_armor_snow')),Probability=0.15)))
    DestroyedMeshSkins(0)=Combiner'DH_VehiclesGE_tex3.Destroyed.Jagdpanther_snow_dest'
}
