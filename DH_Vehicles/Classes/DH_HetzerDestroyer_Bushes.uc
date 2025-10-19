//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_HetzerDestroyer_Bushes extends DH_HetzerDestroyer;

defaultproperties
{
    VehicleAttachments(0)=(StaticMesh=StaticMesh'DH_Hetzer_stc.HETZER_BODY_ATTACHMENT_BUSHES',AttachBone="BODY")
    VehicleAttachments(1)=(StaticMesh=StaticMesh'DH_Hetzer_stc.HETZER_TURRET_ATTACHMENT_BUSHES',AttachBone="PITCH",bAttachToWeapon=true)
}
