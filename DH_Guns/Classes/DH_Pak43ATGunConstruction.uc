//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Pak43ATGunConstruction extends DHConstruction_Vehicle;

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.at_large'
    VehicleClasses(0)=(VehicleClass=class'DH_Guns.DH_Pak43ATGun')
    VehicleClasses(1)=(VehicleClass=class'DH_Guns.DH_Pak43ATGun_Camo')
    SupplyCost=2000
    ProgressMax=14
    PlacementOffset=(Z=20)
}
