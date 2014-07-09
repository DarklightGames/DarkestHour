//=============================================================================
// DH_USSmokeGrenadeWeapon
//=============================================================================

class DH_USSmokeGrenadeWeapon extends DH_StielGranateWeapon;

defaultproperties
{
     FireModeClass(0)=Class'DH_Equipment.DH_USSmokeGrenadeFire'
     FireModeClass(1)=Class'DH_Equipment.DH_USSmokeGrenadeTossFire'
     InventoryGroup=7
     PickupClass=Class'DH_Equipment.DH_USSmokeGrenadePickup'
     AttachmentClass=Class'DH_Equipment.DH_USSmokeGrenadeAttachment'
     ItemName="M15 Smoke Grenade"
     Mesh=SkeletalMesh'DH_USSmokeGrenade_1st.smokegrenade'
     HighDetailOverlay=None
     bUseHighDetailOverlayIndex=False
}
