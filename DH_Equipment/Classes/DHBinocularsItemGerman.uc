//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHBinocularsItemGerman extends DHBinocularsItem;

#exec OBJ LOAD FILE=DH_VehicleOptics_tex.utx

defaultproperties
{
    ItemName="Zeiss Dienstglas 6x30"
    PickupClass=Class'DHBinocularsPickupGerman'
    ScopeOverlay=Texture'DH_VehicleOptics_tex.BINOC_overlay_6x30Germ'
}
