//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHBinocularsItemSoviet extends DHBinocularsItem;

#exec OBJ LOAD FILE=DH_VehicleOptics_tex.utx

defaultproperties
{
    ItemName="BPP Optik 6x30"
    PickupClass=class'DH_Equipment.DHBinocularsPickupSoviet'
    AttachmentClass=class'DH_Equipment.DHBinocularsAttachmentSoviet'

    Skins(2)=Texture'DH_Equipment_tex.Binocs.BinoccanvasAllied'
    HighDetailOverlay=shader'DH_Equipment_tex.Binocs.AlliedBinoc_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    BinocsOverlay=Texture'DH_VehicleOptics_tex.General.BINOC_overlay_6x30Sov'
}
