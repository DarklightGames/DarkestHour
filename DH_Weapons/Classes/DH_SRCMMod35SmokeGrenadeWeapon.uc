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
    Mesh=SkeletalMesh'Allies_F1nade_1st.F1-Grenade-Mesh'
    //Mesh=SkeletalMesh'DH_SRCMMod35_anm.SRCMMod35_1st'
    DisplayFOV=80.0

    InventoryGroup=4
    GroupOffset=0
    Priority=2

    bHasReleaseLever=true
}
