//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_45mmM1942GunConstruction extends DHConstruction_Vehicle;

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.at_small'
    VehicleClasses(0)=(VehicleClass=class'DH_Guns.DH_45mmM1942Gun')
    VehicleClasses(1)=(VehicleClass=class'DH_Guns.DH_45mmM1942Gun_Snow',SeasonFilters=((Seasons=(SEASON_Winter))))
    SupplyCost=800
    ProgressMax=8
}
