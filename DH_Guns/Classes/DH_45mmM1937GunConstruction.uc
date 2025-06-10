//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_45mmM1937GunConstruction extends DHConstruction_Vehicle;

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.at_small'
    VehicleClasses(0)=(VehicleClass=Class'DH_45mmM1937Gun')
    VehicleClasses(1)=(VehicleClass=Class'DH_45mmM1937Gun_Snow',SeasonFilters=((Seasons=(SEASON_Winter))))
    SupplyCost=700
    ProgressMax=8
    PlacementOffset=(Z=10.0)
}
