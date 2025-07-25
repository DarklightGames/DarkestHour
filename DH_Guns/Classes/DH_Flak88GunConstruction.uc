//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Flak88GunConstruction extends DHConstruction_Vehicle;

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.at_large'
    VehicleClasses(0)=(VehicleClass=Class'DH_Flak88Gun')
    VehicleClasses(1)=(VehicleClass=Class'DH_Flak88Gun_Green')
    VehicleClasses(2)=(VehicleClass=Class'DH_Flak88Gun_Tan')
    VehicleClasses(3)=(VehicleClass=Class'DH_Flak88Gun_Snow',SeasonFilters=((Seasons=(SEASON_Winter))))
    SupplyCost=2000
    ProgressMax=14
    CollisionRadius=200
}
