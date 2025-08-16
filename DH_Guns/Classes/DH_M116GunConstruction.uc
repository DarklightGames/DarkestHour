//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M116GunConstruction extends DHConstruction_Vehicle;

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.artillery'
    VehicleClasses(0)=(VehicleClass=Class'DH_M116Gun')
    VehicleClasses(1)=(VehicleClass=Class'DH_M116Gun_Winter',SeasonFilters=((Seasons=(SEASON_Winter))))
    SupplyCost=1500
    ProgressMax=9
}
