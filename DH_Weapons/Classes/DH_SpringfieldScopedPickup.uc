//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_SpringfieldScopedPickup extends DHWeaponPickup
    notplaceable;

defaultproperties
{
    DrawScale3d=(Y=0.75) // Mesh is improperly scaled, need this to make it look right
    InventoryType=class'DH_Weapons.DH_SpringfieldScopedWeapon'
    StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.M1903A4_Springfield'
    PrePivot=(Z=3.0)
    CollisionRadius=25.0
    CollisionHeight=3.0
}
