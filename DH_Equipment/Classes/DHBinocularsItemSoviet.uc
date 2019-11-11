//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHBinocularsItemSoviet extends DHBinocularsItem;

#exec OBJ LOAD FILE=DH_VehicleOptics_tex.utx

defaultproperties
{
    ItemName="BPP Optik 6x30"
    PickupClass=class'DH_Equipment.DHBinocularsPickupSoviet'
    BinocsOverlay=Texture'DH_VehicleOptics_tex.General.BINOC_overlay_7x50Sov'
}
