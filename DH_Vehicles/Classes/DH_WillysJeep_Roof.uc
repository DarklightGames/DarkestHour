//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_WillysJeep_Roof extends DH_WillysJeep;

defaultproperties
{
    // Attachments
    VehicleAttachments(0)=(StaticMesh=StaticMesh'DH_Jeep_stc.Roof.jeep_roof_up',AttachBone="Body")

    // HUD
    SpawnOverlay(0)=Material'DH_Jeep_tex.HUD.profile_roof'
    VehicleHudImage=Texture'DH_Jeep_tex.HUD.jeep_body2'
}

