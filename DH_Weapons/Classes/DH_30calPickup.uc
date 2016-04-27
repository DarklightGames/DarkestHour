//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_30calPickup extends DHWeaponPickup
    notplaceable;

defaultproperties
{
    InventoryType=class'DH_Weapons.DH_30calWeapon'
    StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.30Cal'
    PrePivot=(Z=3.0)
    CollisionRadius=25.0
    CollisionHeight=3.0
    BarrelSteamEmitterOffset=(X=-20.0,Y=0.0,Z=10.0)
}
