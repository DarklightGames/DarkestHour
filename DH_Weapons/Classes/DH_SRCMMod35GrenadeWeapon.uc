//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_SRCMMod35GrenadeWeapon extends DHExplosiveWeapon;

defaultproperties
{
    ItemName="SRCM Mod.35 Grenade"
    FireModeClass(0)=class'DH_Weapons.DH_SRCMMod35GrenadeFire'
    FireModeClass(1)=class'DH_Weapons.DH_SRCMMod35GrenadeTossFire'
    AttachmentClass=class'DH_Weapons.DH_SRCMMod35GrenadeAttachment'
    PickupClass=class'DH_Weapons.DH_SRCMMod35GrenadePickup'
    Mesh=SkeletalMesh'Allies_F1nade_1st.F1-Grenade-Mesh'
    //Mesh=SkeletalMesh'DH_SRCMMod35_anm.SRCMMod35_1st'
    DisplayFOV=80.0
    GroupOffset=0
    bHasReleaseLever=true
}
