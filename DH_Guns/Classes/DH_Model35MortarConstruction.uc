//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Model35MortarConstruction extends DHConstruction_Vehicle;

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.mortar'
    VehicleClasses(0)=(VehicleClass=Class'DH_Model35Mortar')
    bIsArtillery=true
    SupplyCost=1000
    ProgressMax=8
    ConstructionTags=(CT_Mortar)
}
