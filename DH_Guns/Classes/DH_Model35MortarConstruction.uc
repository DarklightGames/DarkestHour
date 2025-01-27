//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Model35MortarConstruction extends DHConstruction_Vehicle;

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.mortar'
    VehicleClasses(0)=(VehicleClass=class'DH_Guns.DH_Model35Mortar')
    bIsArtillery=true
    SupplyCost=1000
    ProgressMax=8
}
