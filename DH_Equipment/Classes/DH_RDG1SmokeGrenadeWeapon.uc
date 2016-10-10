//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_RDG1SmokeGrenadeWeapon extends DHExplosiveWeapon;

defaultproperties
{
    FireModeClass(0)=class'DH_Equipment.DH_RDG1SmokeGrenadeFire'
    FireModeClass(1)=class'DH_Equipment.DH_RDG1SmokeGrenadeTossFire'
    PickupClass=class'DH_Equipment.DH_RDG1SmokeGrenadePickup'
    AttachmentClass=class'DH_Equipment.DH_RDG1SmokeGrenadeAttachment'
    ItemName="RDG-1 Smoke Grenade"
    Mesh=SkeletalMesh'Allies_RGD1_1st.RGD1_mesh'
    InventoryGroup=7
    PutDownAnim="putaway"
}
