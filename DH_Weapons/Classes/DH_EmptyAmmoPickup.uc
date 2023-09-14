//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_EmptyAmmoPickup extends ROMultiMagAmmoPickup;

defaultproperties
{
     AmmoAmount=99999
     MaxDesireability=0.300000
     InventoryType=class'DH_Weapons.DH_EmptyAmmo'
     PickupMessage=""
     PickupForce="MinigunAmmoPickup"
     DrawType=DT_StaticMesh
     PrePivot=(Z=5.000000)
     CollisionRadius=10.000000
     CollisionHeight=3.000000
}

