//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
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

