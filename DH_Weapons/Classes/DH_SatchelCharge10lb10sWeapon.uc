//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_SatchelCharge10lb10sWeapon extends DHExplosiveWeapon;

defaultproperties
{
    ItemName="3KG Satchel Charge"
    FireModeClass(0)=class'DH_Weapons.DH_SatchelCharge10lb10sFire'
    AttachmentClass=class'DH_Weapons.DH_SatchelCharge10lb10sAttachment'
    PickupClass=class'DH_Weapons.DH_SatchelCharge10lb10sPickup'

    InventoryGroup=7
    GroupOffset=2
    Priority=2

    Mesh=SkeletalMesh'DH_Satchels_anm.No73Animation'


    FuzeLength=15.0
    PreFireHoldAnim="Weapon_Down"
}
