//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_LeIG18GunConstruction extends DHConstruction_Vehicle;

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.artillery'
    VehicleClasses(0)=(VehicleClass=class'DH_Guns.DH_LeIG18Gun')
    VehicleClasses(1)=(VehicleClass=class'DH_Guns.DH_LeIG18Gun_Camo')
    SupplyCost=1500
    ProgressMax=9
}
