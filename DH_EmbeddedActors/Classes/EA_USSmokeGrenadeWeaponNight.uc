//=============================================================================
// EA_USSmokeGrenadeWeapon
//=============================================================================

class EA_USSmokeGrenadeWeaponNight extends DH_StielGranateWeapon;

defaultproperties
{
	 FireModeClass(0)=class'EA_USSmokeGrenadeFireNight'
	 FireModeClass(1)=class'EA_USSmokeGrenadeTossFireNight'
	 PickupClass=class'EA_USSmokeGrenadePickupNight'
	 AttachmentClass=Class'EA_USSmokeGrenadeAttachmentNight'
	 ItemName="M15 Smoke Grenade"
	 Mesh=SkeletalMesh'DH_USSmokeGrenade_1st.smokegrenade'
	 HighDetailOverlay=None
	 bUseHighDetailOverlayIndex=False
	 InventoryGroup=7
}
