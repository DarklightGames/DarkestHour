//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_SovietMolotovCrateConstruction extends DHConstruction_InventorySpawner;

defaultproperties
{
    SpawnerClass=class'DH_SovietMolotovSpawner'
    StartRotationMin=(Yaw=16384)
    StartRotationMax=(Yaw=16384)
    SupplyCost=400
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.at_crate'
}
