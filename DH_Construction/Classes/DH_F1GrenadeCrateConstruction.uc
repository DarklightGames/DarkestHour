//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_F1GrenadeCrateConstruction extends DHConstruction_InventorySpawner;

defaultproperties
{
    StartRotationMin=(Yaw=16384)
    StartRotationMax=(Yaw=16384)
    SupplyCost=400
    MenuIcon=Texture'DH_InterfaceArt2_tex.grenade'
    SpawnerClass=Class'DH_F1GrenadeSpawner'
}
