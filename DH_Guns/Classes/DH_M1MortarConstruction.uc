//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M1MortarConstruction extends DHConstruction_Vehicle;

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.mortar'
    VehicleClasses(0)=(VehicleClass=Class'DH_M1Mortar')
    bIsArtillery=true
    SupplyCost=750
    ProgressMax=8
}
