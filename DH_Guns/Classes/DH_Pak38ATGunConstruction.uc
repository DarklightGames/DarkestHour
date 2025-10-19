//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Pak38ATGunConstruction extends DHConstruction_Vehicle;

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.at_small'
    VehicleClasses(0)=(VehicleClass=Class'DH_Pak38ATGunGray')
    VehicleClasses(1)=(VehicleClass=Class'DH_Pak38ATGunCamoOne',SeasonFilters=((Operation=SFO_None,Seasons=(SEASON_Winter))))
    VehicleClasses(2)=(VehicleClass=Class'DH_Pak38ATGunCamoTwo',SeasonFilters=((Operation=SFO_None,Seasons=(SEASON_Winter))))
    VehicleClasses(3)=(VehicleClass=Class'DH_Pak38ATGun')
    VehicleClasses(4)=(VehicleClass=Class'DH_Pak38ATGunWinter',SeasonFilters=((Seasons=(SEASON_Winter))))
    SupplyCost=900
    ProgressMax=8
}
