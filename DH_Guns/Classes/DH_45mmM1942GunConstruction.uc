//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_45mmM1942GunConstruction extends DHConstruction_Vehicle;

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.at_small'
    VehicleClasses(0)=(VehicleClass=class'DH_Guns.DH_45mmM1942Gun')
    VehicleClasses(1)=(VehicleClass=class'DH_Guns.DH_45mmM1942Gun_Snow',SeasonFilters=((Seasons=(SEASON_Winter))))
    SupplyCost=800
    ProgressMax=8
}
