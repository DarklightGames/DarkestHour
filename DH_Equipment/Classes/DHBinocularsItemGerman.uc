//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHBinocularsItemGerman extends DHBinocularsItem;

#exec OBJ LOAD FILE=DH_VehicleOptics_tex.utx

defaultproperties
{
    ItemName="Zeiss Dienstglas 6x30"
    PickupClass=class'DH_Equipment.DHBinocularsPickupGerman'
    BinocsOverlay=Texture'DH_VehicleOptics_tex.General.BINOC_overlay_6x30Germ'
}
