//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Zis3GunConstruction extends DHConstruction_Vehicle;

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.at_small'
    VehicleClasses(0)=(VehicleClass=Class'DH_Zis3Gun')
    VehicleClasses(1)=(VehicleClass=Class'DH_Zis3Gun_Camo')
    VehicleClasses(2)=(VehicleClass=Class'DH_Zis3Gun_Snow',SeasonFilters=((Seasons=(SEASON_Winter))))
    VehicleClasses(3)=(VehicleClass=Class'DH_Zis3Gun_SnowCamo',SeasonFilters=((Seasons=(SEASON_Winter))))
    SupplyCost=1050
    ProgressMax=14
}
