//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Pak38ATGunConstruction extends DHConstruction_Vehicle;

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.at_small'
    VehicleClasses(0)=(VehicleClass=class'DH_Guns.DH_Pak38ATGun')
    VehicleClasses(1)=(VehicleClass=class'DH_Guns.DH_Pak38ATGunGray')
    VehicleClasses(2)=(VehicleClass=class'DH_Guns.DH_Pak38ATGunCamoOne')
    VehicleClasses(3)=(VehicleClass=class'DH_Guns.DH_Pak38ATGunCamoTwo')
    VehicleClasses(4)=(VehicleClass=class'DH_Guns.DH_Pak38ATGunWinter',SeasonFilters=((Seasons=(SEASON_Winter))))
    SupplyCost=900
    ProgressMax=8
}
