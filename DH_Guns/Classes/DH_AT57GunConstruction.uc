//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_AT57GunConstruction extends DHConstruction_Vehicle;

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.at_small'
    VehicleClasses(0)=(VehicleClass=class'DH_Guns.DH_AT57Gun')
    SupplyCost=1050
    ProgressMax=10
    PlacementOffset=(Z=10.0)
}
