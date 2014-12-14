//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_USSmokeGrenadeWeapon extends DH_StielGranateWeapon;

defaultproperties
{
    FireModeClass(0)=class'DH_Equipment.DH_USSmokeGrenadeFire'
    FireModeClass(1)=class'DH_Equipment.DH_USSmokeGrenadeTossFire'
    InventoryGroup=7
    PickupClass=class'DH_Equipment.DH_USSmokeGrenadePickup'
    AttachmentClass=class'DH_Equipment.DH_USSmokeGrenadeAttachment'
    ItemName="M15 Smoke Grenade"
    Mesh=SkeletalMesh'DH_USSmokeGrenade_1st.smokegrenade'
    HighDetailOverlay=none
    bUseHighDetailOverlayIndex=false
}
