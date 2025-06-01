//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Flak38GunConstruction extends DHConstruction_Vehicle;

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.at_small'
    VehicleClasses(0)=(VariantIndex=0,VehicleClass=class'DH_Guns.DH_Flak38Gun')
    VehicleClasses(1)=(VariantIndex=0,VehicleClass=class'DH_Guns.DH_Flak38Gun_Camo')
    VehicleClasses(2)=(VariantIndex=0,VehicleClass=class'DH_Guns.DH_Flak38Gun_Snow',SeasonFilters=((Seasons=(SEASON_Winter))))
    VehicleClasses(3)=(VariantIndex=1,VehicleClass=class'DH_Guns.DH_Flak38Gun_Trailer')
    VehicleClasses(4)=(VariantIndex=1,VehicleClass=class'DH_Guns.DH_Flak38Gun_Trailer_Camo')
    VehicleClasses(5)=(VariantIndex=1,VehicleClass=class'DH_Guns.DH_Flak38Gun_Trailer_Snow',SeasonFilters=((Seasons=(SEASON_Winter))))
    SupplyCost=1050
    ProgressMax=7
}
