//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_PanzerfaustCrateConstruction extends DHConstruction_InventorySpawner;

defaultproperties
{
    SpawnerClass=class'DH_Weapons.DH_PanzerfaustSpawner'
    StartRotationMin=(Yaw=16384)
    StartRotationMax=(Yaw=16384)
    SupplyCost=850
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.at_crate'
}

