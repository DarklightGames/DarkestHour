//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_SpringfieldScopedPickup extends DHWeaponPickup;

defaultproperties
{
    InventoryType=Class'DH_SpringfieldScopedWeapon'
    StaticMesh=StaticMesh'DH_WeaponPickups.M1903A4_Springfield'
    DrawScale3D=(Y=0.75) // mesh is improperly scaled & need this to make it look right
}
