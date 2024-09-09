//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_PantherGTank_CamoOne extends DH_PantherGTank;

defaultproperties
{
    Skins(0)=Texture'DH_VehiclesGE_tex.ext_vehicles.PantherG_body_camo1'
    CannonSkins(0)=Texture'DH_VehiclesGE_tex.ext_vehicles.PantherG_body_camo1'
    RandomAttachmentGroups(0)=(Options=((Probability=0.3,Attachment=(StaticMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherSchurzen1',Skins=(Texture'DH_VehiclesGE_tex.ext_vehicles.PantherG_armor_camo1'))),(Probability=0.15,Attachment=(StaticMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherSchurzen2',Skins=(Texture'DH_VehiclesGE_tex.ext_vehicles.PantherG_armor_camo1'))),(Probability=0.1,Attachment=(StaticMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherSchurzen3',Skins=(Texture'DH_VehiclesGE_tex.ext_vehicles.PantherG_armor_camo1'))),(Probability=0.15,Attachment=(StaticMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherSchurzen4',Skins=(Texture'DH_VehiclesGE_tex.ext_vehicles.PantherG_armor_camo1')))))
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherG_Destroyed'
}
