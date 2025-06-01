//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_ML3InchMortarConstruction extends DHConstruction_Vehicle;

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.mortar'
    VehicleClasses(0)=(VehicleClass=class'DH_Guns.DH_ML3InchMortar')
    bIsArtillery=true
    SupplyCost=1000
    ProgressMax=8
}
