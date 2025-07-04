//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_WillysJeep_Roof extends DH_WillysJeep;

defaultproperties
{
    // Attachments
    VehicleAttachments(0)=(StaticMesh=StaticMesh'DH_Jeep_stc.jeep_roof_up',AttachBone="Body")

    // HUD
    SpawnOverlay(0)=Material'DH_Jeep_tex.profile_roof'
    VehicleHudImage=Texture'DH_Jeep_tex.jeep_body2'
}

