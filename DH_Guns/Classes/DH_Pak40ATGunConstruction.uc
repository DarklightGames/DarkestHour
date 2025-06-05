//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Pak40ATGunConstruction extends DHConstruction_Vehicle;

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.at_small'
    VehicleClasses(0)=(VariantIndex=0,VehicleClass=class'DH_Guns.DH_Pak40ATGun')
    VehicleClasses(1)=(VariantIndex=0,VehicleClass=class'DH_Guns.DH_Pak40ATGun_CamoOne')
    VehicleClasses(2)=(VariantIndex=0,VehicleClass=class'DH_Guns.DH_Pak40ATGun_CamoTwo')
    VehicleClasses(3)=(VariantIndex=0,VehicleClass=class'DH_Guns.DH_Pak40ATGun_Winter',SeasonFilters=((Seasons=(SEASON_Winter))))
    SupplyCost=1200
    ProgressMax=14
}
