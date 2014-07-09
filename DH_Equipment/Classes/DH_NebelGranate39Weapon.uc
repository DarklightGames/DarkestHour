//=============================================================================
// NebelGranate39Weapon
//=============================================================================
// Weapon class for the German NebelHandGranate 39 smoke grenade
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2006 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================

class DH_NebelGranate39Weapon extends DH_StielGranateWeapon;

defaultproperties
{
     FireModeClass(0)=Class'DH_Equipment.DH_NebelGranate39Fire'
     FireModeClass(1)=Class'DH_Equipment.DH_NebelGranate39TossFire'
     InventoryGroup=7
     PickupClass=Class'DH_Equipment.DH_NebelGranate39Pickup'
     AttachmentClass=Class'DH_Equipment.DH_NebelGranate39Attachment'
     ItemName="Nebelhandgranate 39"
     Skins(2)=Texture'Weapons1st_tex.Grenades.StielGranate_smokenade'
     HighDetailOverlay=None
     bUseHighDetailOverlayIndex=False
}
