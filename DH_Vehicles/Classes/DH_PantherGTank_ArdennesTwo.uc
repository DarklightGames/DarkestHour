//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_PantherGTank_ArdennesTwo extends DH_PantherGTank;

defaultproperties
{
    Skins(0)=Texture'DH_VehiclesGE_tex3.PantherG_body_ardennes2'
    CannonSkins(0)=Texture'DH_VehiclesGE_tex3.PantherG_body_ardennes2'
    RandomAttachmentGroups(0)=(Options=((Probability=0.3,Attachment=(StaticMesh=StaticMesh'DH_German_vehicles_stc.PantherSchurzen1',Skins=(Texture'DH_VehiclesGE_tex3.PantherG_armor_ardennes2'))),(Probability=0.15,Attachment=(StaticMesh=StaticMesh'DH_German_vehicles_stc.PantherSchurzen2',Skins=(Texture'DH_VehiclesGE_tex3.PantherG_armor_ardennes2'))),(Probability=0.1,Attachment=(StaticMesh=StaticMesh'DH_German_vehicles_stc.PantherSchurzen3',Skins=(Texture'DH_VehiclesGE_tex3.PantherG_armor_ardennes2'))),(Probability=0.15,Attachment=(StaticMesh=StaticMesh'DH_German_vehicles_stc.PantherSchurzen4',Skins=(Texture'DH_VehiclesGE_tex3.PantherG_armor_ardennes2')))))
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.PantherG_Destroyed6'
}
