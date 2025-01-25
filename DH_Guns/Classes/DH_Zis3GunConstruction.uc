//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Zis3GunConstruction extends DHConstruction_Vehicle;

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.at_small'
    VehicleClasses(0)=(VariantIndex=0,VehicleClass=class'DH_Guns.DH_Zis3Gun')
    VehicleClasses(1)=(VariantIndex=0,VehicleClass=class'DH_Guns.DH_Zis3Gun_Snow',SeasonFilters=((Seasons=(SEASON_Winter))))
    SupplyCost=1050
    ProgressMax=14
    PlacementOffset=(Z=16)
}
