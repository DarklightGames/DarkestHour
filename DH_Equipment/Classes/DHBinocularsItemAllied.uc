//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHBinocularsItemAllied extends DHBinocularsItem;

defaultproperties
{
    ItemName="M13 Binoculars 6x30"
    PickupClass=Class'DHBinocularsPickupAllied'
    AttachmentClass=Class'DHBinocularsAttachmentAllied'

    Skins(2)=Texture'DH_Equipment_tex.Binocs.BinoccanvasAllied'
    HighDetailOverlay=Shader'DH_Equipment_tex.Binocs.AlliedBinoc_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
    
    ScopeOverlay=Texture'DH_VehicleOptics_tex.General.BINOC_overlay_6x30Allied'
}
