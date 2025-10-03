//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_WolverineCannon_British extends DH_WolverineCannon_Early; // British Wolverine won't have HVAP

defaultproperties
{
    Skins(0)=Texture'DH_VehiclesUK_tex.Achilles_turret_ext'
    VehicleAttachments(0)=(AttachBone="Turret",StaticMesh=StaticMesh'DH_allies_vehicles_stc.Brit_M10_StowageAttachment')
}
