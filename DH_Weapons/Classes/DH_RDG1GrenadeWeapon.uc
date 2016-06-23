//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_RDG1GrenadeWeapon extends DH_StielGranateWeapon;

defaultproperties
{
     FireModeClass(0)=Class'DH_Weapons.DH_RDG1GrenadeFire'
     FireModeClass(1)=Class'DH_Weapons.DH_RDG1GrenadeTossFire'
     PutDownAnim="putaway"
     PickupClass=Class'DH_Weapons.DH_RDG1GrenadePickup'
     AttachmentClass=Class'DH_Weapons.DH_RDG1GrenadeAttachment'
     ItemName="RDG-1 Smoke Grenade"
     Mesh=SkeletalMesh'Allies_RGD1_1st.RGD1_mesh'
     HighDetailOverlay=None
     bUseHighDetailOverlayIndex=False
     InventoryGroup=7
}
