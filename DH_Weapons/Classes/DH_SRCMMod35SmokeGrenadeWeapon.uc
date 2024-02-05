//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_SRCMMod35SmokeGrenadeWeapon extends DHExplosiveWeapon;

defaultproperties
{
    ItemName="SRCM Mod.35 Smoke Grenade"
    FireModeClass(0)=class'DH_Weapons.DH_SRCMMod35SmokeGrenadeFire'
    FireModeClass(1)=class'DH_Weapons.DH_SRCMMod35SmokeGrenadeTossFire'
    AttachmentClass=class'DH_Weapons.DH_SRCMMod35SmokeGrenadeAttachment'
    PickupClass=class'DH_Weapons.DH_SRCMMod35SmokeGrenadePickup'
    Mesh=SkeletalMesh'DH_SRCMMod35_anm.srcm_1st'
    DisplayFOV=80.0

    Skins(2)=Shader'DH_SRCMMod35_tex.SRCMMod35.SRCM35_Phosphorous_S'

    InventoryGroup=4
    GroupOffset=0
    Priority=2

    bHasReleaseLever=true
}
