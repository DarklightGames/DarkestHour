//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHBinocularsItemItalian extends DHBinocularsItem;

defaultproperties
{
    Mesh=SkeletalMesh'DH_Binoc_anm.Italian_Binoculars'
    Skins(2)=Texture'DH_Equipment_tex.Binocs.Binoc_italy'
    ItemName="Fratelli Koristka 7x50"
    PickupClass=class'DH_Equipment.DHBinocularsPickupItalian'
    ScopeOverlay=Texture'DH_VehicleOptics_tex.General.BINOC_overlay_Italian'
    // Technically this is not "Allied", but it's the same color as the Allied binoculars so it's fine.
    AttachmentClass=class'DH_Equipment.DHBinocularsAttachmentAllied'
}
