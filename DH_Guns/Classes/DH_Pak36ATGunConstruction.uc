//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Pak36ATGunConstruction extends DHConstruction_Vehicle;

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.at_small'
    VehicleClasses(0)=(VehicleClass=Class'DH_Pak36ATGun')
    VehicleClasses(1)=(VehicleClass=Class'DH_Pak36ATGunCamo',SeasonFilters=((Operation=SFO_None,Seasons=(SEASON_Winter))))
    VehicleClasses(2)=(VehicleClass=Class'DH_Pak36ATGunYellow')
    VehicleClasses(3)=(VehicleClass=Class'DH_Pak36ATGunWinter',SeasonFilters=((Seasons=(SEASON_Winter))))
    SupplyCost=800
    ProgressMax=7
}
