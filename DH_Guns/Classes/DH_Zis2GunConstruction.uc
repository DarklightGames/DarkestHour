//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Zis2GunConstruction extends DHConstruction_Vehicle;

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.at_large'
    VehicleClasses(0)=(VehicleClass=class'DH_Guns.DH_Zis2Gun')
    VehicleClasses(1)=(VehicleClass=class'DH_Guns.DH_Zis2Gun_Snow',SeasonFilters=((Seasons=(SEASON_Winter))))
    SupplyCost=1250
    ProgressMax=14
    PlacementOffset=(Z=16)
}
