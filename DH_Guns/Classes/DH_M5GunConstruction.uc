//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M5GunConstruction extends DHConstruction_Vehicle;

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.at_large'
    VehicleClasses(0)=(VehicleClass=class'DH_Guns.DH_M5Gun')
    VehicleClasses(1)=(VehicleClass=class'DH_Guns.DH_M5Gun_Snow',SeasonFilters=((Seasons=(SEASON_Winter))))
    SupplyCost=1650
    ProgressMax=14
    PlacementOffset=(Z=-2)
}
