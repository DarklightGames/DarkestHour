//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// Effects
// [ ] Add a new sound for when the smoke grenade explodes (it's white phosphorus)
// [ ] Add WP emitter effects when the smoke grenade explodes
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
    SprintStartAnim="sprint_start"
    SprintLoopAnim="sprint_middle"
    SprintEndAnim="sprint_end"
}
