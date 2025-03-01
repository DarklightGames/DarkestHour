//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Granatwerfer34MortarConstruction extends DHMortarConstruction;

defaultproperties
{
    VehicleClasses(0)=(VehicleClass=class'DH_Guns.DH_Granatwerfer34MortarGray')
    VehicleClasses(1)=(VehicleClass=class'DH_Guns.DH_Granatwerfer34Mortar')
    VehicleClasses(2)=(VehicleClass=class'DH_Guns.DH_Granatwerfer34MortarCamo')
    VehicleClasses(3)=(VehicleClass=class'DH_Guns.DH_Granatwerfer34MortarWinter',SeasonFilters=((Seasons=(SEASON_Winter))))
    SupplyCost=1000
    ProgressMax=8
}
