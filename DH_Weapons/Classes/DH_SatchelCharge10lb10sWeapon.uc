//=============================================================================
// SatchelCharge10lb10sWeapon
//=============================================================================
// Weapon class for the 10 pund 10 second fuse SatchelCharge
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2005 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================

class DH_SatchelCharge10lb10sWeapon extends DH_SatchelChargeMantleWeapon;

#exec OBJ LOAD FILE=..\Animations\Common_Satchel_1st.ukx

defaultproperties
{
     FireModeClass(0)=Class'DH_Weapons.DH_SatchelCharge10lb10sFire'
     FireModeClass(1)=Class'DH_Weapons.DH_SatchelCharge10lb10sFire'
     PickupClass=Class'DH_Weapons.DH_SatchelCharge10lb10sPickup'
     AttachmentClass=Class'DH_Weapons.DH_SatchelCharge10lb10sAttachment'
     ItemName="10lb Satchel Charge"
}
