//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_SpringfieldA1Pickup extends DHWeaponPickup;

defaultproperties
{
    InventoryType=class'DH_Weapons.DH_SpringfieldA1Weapon'
    StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.M1903A1_Springfield'
    DrawScale3D=(Y=0.75) // mesh is improperly scaled & need this to make it look right
}
