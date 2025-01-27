//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Cannone4732GunConstruction extends DHConstruction_Vehicle;

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.at_small'
    VehicleClasses(0)=(VariantIndex=0,VehicleClass=class'DH_Guns.DH_Cannone4732Gun')
    VehicleClasses(1)=(VariantIndex=0,VehicleClass=class'DH_Guns.DH_Cannone4732Gun_Desert')
    VehicleClasses(2)=(VariantIndex=0,VehicleClass=class'DH_Guns.DH_Cannone4732Gun_DesertCamo')
    VehicleClasses(3)=(VariantIndex=0,VehicleClass=class'DH_Guns.DH_Cannone4732Gun_Winter',SeasonFilters=((Seasons=(SEASON_Winter))))
    VehicleClasses(4)=(VariantIndex=1,VehicleClass=class'DH_Guns.DH_Cannone4732Gun_NoWheels')
    VehicleClasses(5)=(VariantIndex=1,VehicleClass=class'DH_Guns.DH_Cannone4732Gun_NoWheels_Desert')
    VehicleClasses(6)=(VariantIndex=1,VehicleClass=class'DH_Guns.DH_Cannone4732Gun_NoWheels_DesertCamo')
    VehicleClasses(7)=(VariantIndex=1,VehicleClass=class'DH_Guns.DH_Cannone4732Gun_NoWheels_Winter',SeasonFilters=((Seasons=(SEASON_Winter))))
    SupplyCost=700
    ProgressMax=8
}
