//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_PantherGTank_CamoThree extends DH_PantherGTank;

defaultproperties
{
    Skins(0)=Texture'DH_VehiclesGE_tex.ext_vehicles.PantherG_body_camo3'
    CannonSkins(0)=Texture'DH_VehiclesGE_tex.ext_vehicles.PantherG_body_camo3'
    RandomAttachmentGroups(0)=(Options=((Probability=0.3,Attachment=(StaticMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherSchurzen1',Skins=(Texture'DH_VehiclesGE_tex.ext_vehicles.PantherG_armor_camo3'))),(Probability=0.15,Attachment=(StaticMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherSchurzen2',Skins=(Texture'DH_VehiclesGE_tex.ext_vehicles.PantherG_armor_camo3'))),(Probability=0.1,Attachment=(StaticMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherSchurzen3',Skins=(Texture'DH_VehiclesGE_tex.ext_vehicles.PantherG_armor_camo3'))),(Probability=0.15,Attachment=(StaticMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherSchurzen4',Skins=(Texture'DH_VehiclesGE_tex.ext_vehicles.PantherG_armor_camo3')))))
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherG_Destroyed3'
}
