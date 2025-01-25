//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_M45QuadmountGunConstruction extends DHConstruction_Vehicle;

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.aa_light'
    VehicleClasses(0)=(VehicleClass=class'DH_Guns.DH_M45QuadmountGun')
    VehicleClasses(1)=(VehicleClass=class'DH_Guns.DH_M45QuadmountGun_Snow',SeasonFilters=((Seasons=(SEASON_Winter))))
    SupplyCost=1050
    ProgressMax=7
}
