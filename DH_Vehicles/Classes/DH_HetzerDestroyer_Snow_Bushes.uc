//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_HetzerDestroyer_Snow_Bushes extends DH_HetzerDestroyer_Snow;

defaultproperties
{
    VehicleAttachments(0)=(StaticMesh=StaticMesh'DH_Hetzer_stc.HETZER_BODY_ATTACHMENT_BUSHES',AttachBone="BODY",Skins=(Texture'DH_Vegetation2_tex.pinebranch_d_snow'))
    VehicleAttachments(1)=(StaticMesh=StaticMesh'DH_Hetzer_stc.HETZER_TURRET_ATTACHMENT_BUSHES',AttachBone="PITCH",bAttachToWeapon=true,Skins=(Texture'DH_Vegetation2_tex.pinebranch_d_snow'))
}
