//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHBinocularsItemSoviet extends DHBinocularsItem;

defaultproperties
{
    ItemName="BPP Optik 6x30"
    PickupClass=Class'DHBinocularsPickupSoviet'
    AttachmentClass=Class'DHBinocularsAttachmentSoviet'

    Skins(2)=Texture'DH_Equipment_tex.BinoccanvasAllied'
    HighDetailOverlay=Shader'DH_Equipment_tex.AlliedBinoc_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    ScopeOverlay=Texture'DH_VehicleOptics_tex.BINOC_overlay_6x30Sov'
}
