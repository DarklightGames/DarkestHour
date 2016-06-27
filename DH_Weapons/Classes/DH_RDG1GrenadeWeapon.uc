//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_RDG1GrenadeWeapon extends DH_StielGranateWeapon;

defaultproperties
{
    FireModeClass(0)=class'DH_Weapons.DH_RDG1GrenadeFire'
    FireModeClass(1)=class'DH_Weapons.DH_RDG1GrenadeTossFire'
    PutDownAnim="putaway"
    PickupClass=class'DH_Weapons.DH_RDG1GrenadePickup'
    AttachmentClass=class'DH_Weapons.DH_RDG1GrenadeAttachment'
    ItemName="RDG-1 Smoke Grenade"
    Mesh=SkeletalMesh'Allies_RGD1_1st.RGD1_mesh'
    HighDetailOverlay=None
    bUseHighDetailOverlayIndex=false
    InventoryGroup=7
}
