//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_SatchelCharge10lb10sWeapon extends DH_SatchelChargeMantleWeapon;

#exec OBJ LOAD FILE=..\Animations\Common_Satchel_1st.ukx

defaultproperties
{
    bCanThrow=false //cannot be dropped
    FuzeLength=15.0 //was 10
    FireModeClass(0)=class'DH_Weapons.DH_SatchelCharge10lb10sFire'
    FireModeClass(1)=class'DH_Weapons.DH_SatchelCharge10lb10sFire'
    PickupClass=class'DH_Weapons.DH_SatchelCharge10lb10sPickup'
    AttachmentClass=class'DH_Weapons.DH_SatchelCharge10lb10sAttachment'
    ItemName="10lb Satchel Charge"
}
