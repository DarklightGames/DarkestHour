//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// [ ] add smoke variant texture
// [ ] add fidgeting fingers in idle
// [ ] work on the keyframing for the pull tab action
// [ ] add sound notifies
// [ ] HUD elements
// [ ] sprint & crawl animations
//==============================================================================

class DH_SRCMMod35GrenadeWeapon extends DHExplosiveWeapon;

defaultproperties
{
    ItemName="SRCM Mod.35 Grenade"
    FireModeClass(0)=class'DH_Weapons.DH_SRCMMod35GrenadeFire'
    FireModeClass(1)=class'DH_Weapons.DH_SRCMMod35GrenadeTossFire'
    AttachmentClass=class'DH_Weapons.DH_SRCMMod35GrenadeAttachment'
    PickupClass=class'DH_Weapons.DH_SRCMMod35GrenadePickup'
    Mesh=SkeletalMesh'DH_SRCMMod35_anm.srcm_1st'
    DisplayFOV=80.0
    GroupOffset=0
    bHasReleaseLever=true
    PlayerViewOffset=(X=0.0,Y=0.0,Z=0.0)
}
