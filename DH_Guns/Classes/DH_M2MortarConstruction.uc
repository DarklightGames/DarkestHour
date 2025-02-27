//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M2MortarConstruction extends DHConstruction_Vehicle;

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.mortar'
    VehicleClasses(0)=(VehicleClass=class'DH_Guns.DH_M2Mortar')
    bIsArtillery=true
    SupplyCost=750
    ProgressMax=8
    bSinglePlayerOnly=true
}
