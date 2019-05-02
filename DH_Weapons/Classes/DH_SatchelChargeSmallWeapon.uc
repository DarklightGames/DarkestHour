//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_SatchelChargeSmallWeapon extends DH_SatchelCharge10lb10sWeapon;

defaultproperties
{
    ItemName="Small Satchel Charge"

    FireModeClass(0)=class'DH_Weapons.DH_SatchelChargeSmallFire'
    AttachmentClass=class'DH_Weapons.DH_SatchelChargeSmallAttachment'
    PickupClass=class'DH_Weapons.DH_SatchelChargeSmallPickup'
}
