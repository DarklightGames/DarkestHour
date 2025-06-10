//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Granatwerfer34MortarConstruction extends DHConstruction_Vehicle;

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.mortar'
    VehicleClasses(0)=(VehicleClass=Class'DH_Granatwerfer34MortarGray')
    VehicleClasses(1)=(VehicleClass=Class'DH_Granatwerfer34Mortar')
    VehicleClasses(2)=(VehicleClass=Class'DH_Granatwerfer34MortarCamo')
    VehicleClasses(3)=(VehicleClass=Class'DH_Granatwerfer34MortarWinter',SeasonFilters=((Seasons=(SEASON_Winter))))
    bIsArtillery=true
    SupplyCost=1000
    ProgressMax=8
}
