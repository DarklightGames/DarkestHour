//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Zis2GunConstruction extends DHConstruction_Vehicle;

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.at_large'
    VehicleClasses(0)=(VehicleClass=Class'DH_Zis2Gun')
    VehicleClasses(1)=(VehicleClass=Class'DH_Zis2Gun_Snow',SeasonFilters=((Seasons=(SEASON_Winter))))
    SupplyCost=1250
    ProgressMax=14
}
